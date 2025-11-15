import 'package:flutter/material.dart';
import '../widgets/today_meals_list.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Refeições'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/add_meal');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Refeições de Hoje',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const TodayMealsList(),
            const SizedBox(height: 24),
            const Text(
              'Sugestões de Refeições',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Mock suggestions
            Card(
              child: ListTile(
                leading: const Icon(Icons.restaurant),
                title: const Text('Café da Manhã Saudável'),
                subtitle: const Text('Aveia com frutas - 350 kcal'),
                trailing: const Icon(Icons.add),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Refeição adicionada!')),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.restaurant),
                title: const Text('Almoço Leve'),
                subtitle: const Text('Salada com frango - 450 kcal'),
                trailing: const Icon(Icons.add),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Refeição adicionada!')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              // Já nas refeições
              break;
            case 2:
              Navigator.pushNamed(context, '/drinks');
              break;
            case 3:
              Navigator.pushNamed(context, '/progress');
              break;
            case 4:
              Navigator.pushNamed(context, '/friends');
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
            icon: Icon(Icons.local_drink),
            label: 'Bebidas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Progresso',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Amigos',
          ),
        ],
        selectedItemColor: Colors.green[600],
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
