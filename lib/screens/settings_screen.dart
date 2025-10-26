import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/app_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final user = provider.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('Usuário não encontrado'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.green[100],
              child: Text(
                user.name[0].toUpperCase(),
                style: TextStyle(
                  fontSize: 48,
                  color: Colors.green[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Name and Email
            Text(
              user.name,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user.email,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),

            // Settings
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text('Editar Informações'),
                    onTap: () {
                      // TODO: Implement edit profile
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Editar informações - Em breve!')),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.share),
                    title: const Text('Compartilhar App'),
                    onTap: () {
                      // TODO: Implement share app
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Compartilhar app - Em breve!')),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.business),
                    title: const Text('Herbalife'),
                    subtitle: const Text('Cliente/Consultor'),
                    trailing: Switch(
                      value: false, // Mock value
                      onChanged: (value) {
                        // TODO: Implement Herbalife setting
                      },
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('Notificações'),
                    trailing: Switch(
                      value: true, // Mock value
                      onChanged: (value) {
                        // TODO: Implement notification settings
                      },
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.dark_mode),
                    title: const Text('Tema Escuro'),
                    trailing: Switch(
                      value: provider.themeMode == ThemeMode.dark,
                      onChanged: (value) {
                        provider.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                      },
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.support_agent),
                    title: const Text('Chamar Coach'),
                    subtitle: const Text('Atendimento via WhatsApp'),
                    onTap: () async {
                      const phoneNumber = '5511999999999'; // Replace with actual coach number
                      final url = 'https://wa.me/$phoneNumber?text=Olá! Gostaria de falar com meu coach sobre minha dieta.';
                      try {
                        await launchUrl(Uri.parse(url));
                      } catch (e) {
                        // Ignore error or handle differently
                      }
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Sair'),
                    onTap: () {
                      // TODO: Implement logout
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Logout - Em breve!')),
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
}
