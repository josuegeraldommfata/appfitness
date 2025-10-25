import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações'),
      ),
      body: ListView(
        children: [
          // Mock notifications
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Lembrete de Refeição'),
            subtitle: const Text('Não esqueça de registrar seu almoço!'),
            trailing: const Text('2h atrás'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.emoji_events),
            title: const Text('Conquista Desbloqueada!'),
            subtitle: const Text('Você completou 7 dias de dieta consecutivos!'),
            trailing: const Text('1d atrás'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Conquista do Amigo'),
            subtitle: const Text('Maria Silva perdeu 2kg esta semana!'),
            trailing: const Text('2d atrás'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.article),
            title: const Text('Novo Artigo'),
            subtitle: const Text('Dicas para uma alimentação saudável'),
            trailing: const Text('3d atrás'),
          ),
        ],
      ),
    );
  }
}
