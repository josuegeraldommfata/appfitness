import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/user.dart';
import 'reports_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppProvider>(context, listen: false).loadAdminData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              provider.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bem-vindo, Admin!',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Gerencie usuários, visualize estatísticas e configure o sistema.',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Quick Stats
            Text(
              'Estatísticas Gerais',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(
                            Icons.people,
                            size: 32,
                            color: Colors.blue[600],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Total Usuários',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          Text(
                            '${provider.userCount}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(
                            Icons.restaurant,
                            size: 32,
                            color: Colors.green[600],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Refeições Hoje',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          Text(
                            '${provider.totalMealsToday}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Admin Actions
            Text(
              'Ações Administrativas',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildAdminActionCard(
                  context,
                  'Gerenciar Usuários',
                  Icons.people,
                  Colors.blue,
                  () {
                    _showUserManagementDialog(context, provider);
                  },
                ),
                _buildAdminActionCard(
                  context,
                  'Relatórios',
                  Icons.analytics,
                  Colors.purple,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ReportsScreen()),
                    );
                  },
                ),
                _buildAdminActionCard(
                  context,
                  'Configurações',
                  Icons.settings,
                  Colors.orange,
                  () {
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
                _buildAdminActionCard(
                  context,
                  'Notificações',
                  Icons.notifications,
                  Colors.red,
                  () {
                    Navigator.pushNamed(context, '/notifications');
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // User List
            Text(
              'Lista de Usuários',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.allUsers.length,
                itemBuilder: (context, index) {
                  final user = provider.allUsers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green[100],
                      child: Text(user.name[0].toUpperCase()),
                    ),
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'delete') {
                          _confirmDeleteUser(context, provider, user);
                        } else if (value == 'role') {
                          _changeUserRole(context, provider, user);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'role',
                          child: Text('Alterar Função'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Excluir Usuário'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUserManagementDialog(BuildContext context, AppProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gerenciar Usuários'),
        content: const Text('Aqui você pode visualizar e gerenciar todos os usuários do sistema.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteUser(BuildContext context, AppProvider provider, User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Tem certeza que deseja excluir o usuário ${user.name}? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await provider.deleteUser(user.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Usuário ${user.name} excluído com sucesso.')),
              );
            },
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
        content: const Text('Selecione a nova função para o usuário:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await provider.updateUserRole(user.id, 'admin');
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Função alterada para admin.')),
              );
            },
            child: const Text('Admin'),
          ),
          TextButton(
            onPressed: () async {
              await provider.updateUserRole(user.id, 'user');
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Função alterada para user.')),
              );
            },
            child: const Text('User'),
          ),
        ],
      ),
    );
  }
}
