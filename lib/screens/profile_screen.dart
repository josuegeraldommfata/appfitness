import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
        title: const Text('Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Implement edit profile
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Editar perfil - Em breve!')),
              );
            },
          ),
        ],
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

            // Diet Streak
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: Colors.orange,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${provider.dietStreak} dias',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const Text(
                      'Sequência de Dieta',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Goals Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Objetivos',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _GoalItem(
                      icon: Icons.monitor_weight,
                      label: 'Meta',
                      value: user.goal,
                    ),
                    const SizedBox(height: 12),
                    _GoalItem(
                      icon: Icons.scale,
                      label: 'Peso Atual',
                      value: '${user.weight} kg',
                    ),
                    const SizedBox(height: 12),
                    _GoalItem(
                      icon: Icons.flag,
                      label: 'Peso Alvo',
                      value: '${user.targetWeight} kg',
                    ),
                    const SizedBox(height: 12),
                    _GoalItem(
                      icon: Icons.local_fire_department,
                      label: 'Calorias Diárias',
                      value: '${user.dailyCalorieGoal} kcal',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Body Info Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informações Corporais',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _BodyInfoItem(
                            label: 'Altura',
                            value: '${user.height} cm',
                          ),
                        ),
                        Expanded(
                          child: _BodyInfoItem(
                            label: 'Tipo Corporal',
                            value: user.bodyType,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _BodyInfoItem(
                      label: 'Idade',
                      value: '${DateTime.now().year - user.birthDate.year} anos',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Macros Goals Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Metas de Macronutrientes',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _MacroItem(
                      label: 'Proteína',
                      value: '${user.macroGoals['protein']?.toInt() ?? 0}g',
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    _MacroItem(
                      label: 'Carboidratos',
                      value: '${user.macroGoals['carbs']?.toInt() ?? 0}g',
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 12),
                    _MacroItem(
                      label: 'Gordura',
                      value: '${user.macroGoals['fat']?.toInt() ?? 0}g',
                      color: Colors.yellow,
                    ),
                  ],
                ),
              ),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/meals');
              break;
            case 2:
              Navigator.pushNamed(context, '/progress');
              break;
            case 3:
              Navigator.pushNamed(context, '/friends');
              break;
            case 4:
              // Já no perfil
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Refeições',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Progresso',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Amigos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        selectedItemColor: Colors.green[600],
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class _GoalItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _GoalItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.green[600]),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(color: Colors.grey[600]),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _BodyInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _BodyInfoItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _MacroItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MacroItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
