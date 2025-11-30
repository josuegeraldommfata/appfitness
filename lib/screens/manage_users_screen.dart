import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/user.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filterRole = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<User> get _filteredUsers {
    final provider = Provider.of<AppProvider>(context, listen: false);
    var users = provider.allUsers;

    // Filter by role
    if (_filterRole != 'all') {
      users = users.where((u) => u.role == _filterRole).toList();
    }

    // Filter by search
    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      users = users.where((u) =>
          u.name.toLowerCase().contains(query) ||
          u.email.toLowerCase().contains(query)).toList();
    }

    return users;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Usuários'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              provider.loadAdminData();
            },
            tooltip: 'Atualizar',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar usuários...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) => setState(() {}),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Filtrar por: '),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: 'all', label: Text('Todos')),
                          ButtonSegment(value: 'admin', label: Text('Admin')),
                          ButtonSegment(value: 'user', label: Text('Usuário')),
                        ],
                        selected: {_filterRole},
                        onSelectionChanged: (Set<String> newSelection) {
                          setState(() {
                            _filterRole = newSelection.first;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Users List
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredUsers.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'Nenhum usuário encontrado',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = _filteredUsers[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: user.role == 'admin' ? Colors.purple[100] : Colors.blue[100],
                                child: Text(
                                  user.name[0].toUpperCase(),
                                  style: TextStyle(
                                    color: user.role == 'admin' ? Colors.purple[800] : Colors.blue[800],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(user.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(user.email),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: user.role == 'admin' ? Colors.purple[100] : Colors.blue[100],
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          user.role == 'admin' ? 'Admin' : 'Usuário',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: user.role == 'admin' ? Colors.purple[800] : Colors.blue[800],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      if (user.currentPlan != null) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.green[100],
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            user.currentPlan ?? 'Free',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.green[800],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                              trailing: PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'view') {
                                    _showUserDetails(context, user);
                                  } else if (value == 'role') {
                                    _changeUserRole(context, provider, user);
                                  } else if (value == 'delete') {
                                    _confirmDeleteUser(context, provider, user);
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'view',
                                    child: Row(
                                      children: [
                                        Icon(Icons.info, size: 20),
                                        SizedBox(width: 8),
                                        Text('Ver Detalhes'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'role',
                                    child: Row(
                                      children: [
                                        Icon(Icons.swap_horiz, size: 20),
                                        SizedBox(width: 8),
                                        Text('Alterar Função'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, size: 20, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text('Excluir', style: TextStyle(color: Colors.red)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  void _showUserDetails(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(user.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Email', user.email),
              _buildDetailRow('Função', user.role == 'admin' ? 'Administrador' : 'Usuário'),
              _buildDetailRow('Plano', user.currentPlan ?? 'Free'),
              _buildDetailRow('ID Herbalife', user.herbalifeId ?? 'Não informado'),
              _buildDetailRow('Altura', '${user.height} cm'),
              _buildDetailRow('Peso', '${user.weight} kg'),
              _buildDetailRow('Meta de Calorias', '${user.dailyCalorieGoal} kcal'),
              _buildDetailRow('Idade', '${user.age} anos'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _confirmDeleteUser(BuildContext context, AppProvider provider, User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Tem certeza que deseja excluir o usuário ${user.name}?\n\nEsta ação não pode ser desfeita e excluirá todos os dados do usuário.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await provider.deleteUser(user.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Usuário ${user.name} excluído com sucesso.')),
                );
                setState(() {});
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  void _changeUserRole(BuildContext context, AppProvider provider, User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alterar Função'),
        content: Text('Selecione a nova função para ${user.name}:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await provider.updateUserRole(user.id, 'admin');
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Função alterada para admin.')),
                );
                setState(() {});
              }
            },
            child: const Text('Admin'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await provider.updateUserRole(user.id, 'user');
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Função alterada para user.')),
                );
                setState(() {});
              }
            },
            child: const Text('User'),
          ),
        ],
      ),
    );
  }
}

