import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel Administrativo'),
        backgroundColor: Colors.green[600],
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              provider.logout();
            },
            tooltip: 'Sair',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bem-vindo, ${provider.currentUser?.name ?? 'Admin'}!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildAdminCard(
                    context,
                    'Usuários',
                    Icons.people,
                    () {
                      // TODO: Navigate to users management
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Gerenciamento de usuários em desenvolvimento')),
                      );
                    },
                  ),
                  _buildAdminCard(
                    context,
                    'Relatórios',
                    Icons.analytics,
                    () {
                      // TODO: Navigate to reports
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Relatórios em desenvolvimento')),
                      );
                    },
                  ),
                  _buildAdminCard(
                    context,
                    'Configurações',
                    Icons.settings,
                    () {
                      // TODO: Navigate to settings
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Configurações em desenvolvimento')),
                      );
                    },
                  ),
                  _buildAdminCard(
                    context,
                    'Notificações',
                    Icons.notifications,
                    () {
                      // TODO: Navigate to notifications
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sistema de notificações em desenvolvimento')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Colors.green[600],
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
