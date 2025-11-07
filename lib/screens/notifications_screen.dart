import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    // Mock notifications - in a real app, this would come from Firestore
    setState(() {
      _notifications = [
        {
          'id': '1',
          'type': 'meal_reminder',
          'title': 'Lembrete de Refeição',
          'message': 'Não esqueça de registrar seu almoço!',
          'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
          'read': false,
        },
        {
          'id': '2',
          'type': 'achievement',
          'title': 'Conquista Desbloqueada!',
          'message': 'Você completou 7 dias de dieta consecutivos!',
          'timestamp': DateTime.now().subtract(const Duration(days: 1)),
          'read': false,
        },
        {
          'id': '3',
          'type': 'friend_achievement',
          'title': 'Conquista do Amigo',
          'message': 'Maria Silva perdeu 2kg esta semana!',
          'timestamp': DateTime.now().subtract(const Duration(days: 2)),
          'read': true,
        },
        {
          'id': '4',
          'type': 'article',
          'title': 'Novo Artigo',
          'message': 'Dicas para uma alimentação saudável',
          'timestamp': DateTime.now().subtract(const Duration(days: 3)),
          'read': true,
        },
      ];
    });
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d atrás';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h atrás';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}min atrás';
    } else {
      return 'Agora';
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'meal_reminder':
        return Icons.notifications;
      case 'achievement':
        return Icons.emoji_events;
      case 'friend_achievement':
        return Icons.people;
      case 'article':
        return Icons.article;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações'),
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_email_read),
            onPressed: () {
              setState(() {
                _notifications = _notifications.map((n) => {...n, 'read': true}).toList();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Todas as notificações marcadas como lidas')),
              );
            },
            tooltip: 'Marcar todas como lidas',
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Nenhuma notificação', style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return Dismissible(
                  key: Key(notification['id']),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      _notifications.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notificação removida')),
                    );
                  },
                  child: ListTile(
                    leading: Icon(
                      _getNotificationIcon(notification['type']),
                      color: notification['read'] ? Colors.grey : Colors.green,
                    ),
                    title: Text(
                      notification['title'],
                      style: TextStyle(
                        fontWeight: notification['read'] ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(notification['message']),
                    trailing: Text(
                      _formatTimestamp(notification['timestamp']),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    onTap: () {
                      setState(() {
                        notification['read'] = true;
                      });
                      // Handle notification tap - could navigate to relevant screen
                      if (notification['type'] == 'meal_reminder') {
                        Navigator.pushNamed(context, '/add_meal');
                      } else if (notification['type'] == 'achievement') {
                        Navigator.pushNamed(context, '/progress');
                      }
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add a test notification
          setState(() {
            _notifications.insert(0, {
              'id': DateTime.now().millisecondsSinceEpoch.toString(),
              'type': 'meal_reminder',
              'title': 'Nova Notificação de Teste',
              'message': 'Esta é uma notificação de teste.',
              'timestamp': DateTime.now(),
              'read': false,
            });
          });
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        tooltip: 'Adicionar notificação de teste',
      ),
    );
  }
}
