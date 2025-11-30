import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart';
import '../services/notification_service.dart';

class AdminNotificationsScreen extends StatefulWidget {
  const AdminNotificationsScreen({super.key});

  @override
  State<AdminNotificationsScreen> createState() => _AdminNotificationsScreenState();
}

class _AdminNotificationsScreenState extends State<AdminNotificationsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
    });
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('admin_notifications')
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();

      setState(() {
        _notifications = snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return data;
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading notifications: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sendNotification() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Salvar notificação no Firebase
      final notificationData = {
        'title': _titleController.text.trim(),
        'message': _messageController.text.trim(),
        'createdAt': Timestamp.now(),
        'createdBy': 'admin',
        'sentToAll': true,
      };

      await _firestore.collection('admin_notifications').add(notificationData);

      // Enviar para todos os usuários
      final users = await FirebaseService().getAllUsers();
      for (var user in users) {
        // Adicionar notificação para cada usuário
        await _firestore.collection('user_notifications').add({
          'userId': user.id,
          'title': _titleController.text.trim(),
          'message': _messageController.text.trim(),
          'read': false,
          'createdAt': Timestamp.now(),
        });

        // Enviar notificação push local
        await NotificationService().showNotification(
          id: DateTime.now().millisecondsSinceEpoch % 100000,
          title: _titleController.text.trim(),
          body: _messageController.text.trim(),
        );
      }

      _titleController.clear();
      _messageController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Notificação enviada para ${users.length} usuários!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error sending notification: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao enviar notificação: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Notificações'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddNotificationDialog();
            },
            tooltip: 'Adicionar Notificação',
          ),
        ],
      ),
      body: _isLoading && _notifications.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_none, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhuma notificação enviada',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () => _showAddNotificationDialog(),
                        icon: const Icon(Icons.add),
                        label: const Text('Criar Primeira Notificação'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    final notification = _notifications[index];
                    final timestamp = (notification['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Icon(Icons.notifications, color: Colors.red[600]),
                        title: Text(notification['title'] ?? 'Sem título'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(notification['message'] ?? ''),
                            const SizedBox(height: 4),
                            Text(
                              '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(color: Colors.grey[600], fontSize: 12),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, size: 20),
                          onPressed: () async {
                            await _firestore.collection('admin_notifications').doc(notification['id']).delete();
                            _loadNotifications();
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void _showAddNotificationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nova Notificação'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Digite um título';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    labelText: 'Mensagem',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Digite uma mensagem';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: _sendNotification,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Enviar'),
          ),
        ],
      ),
    );
  }
}

