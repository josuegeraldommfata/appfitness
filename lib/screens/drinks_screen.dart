import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'package:intl/intl.dart';

class DrinksScreen extends StatelessWidget {
  const DrinksScreen({super.key});

  String _formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Bebidas'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.pushNamed(context, '/add_drink');
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Bebidas de Hoje',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/add_drink');
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Adicionar'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (provider.todayDrinks.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.local_drink, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'Nenhuma bebida registrada hoje',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  ...provider.todayDrinks.map((drink) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Icon(
                          Icons.local_drink,
                          color: Colors.blue[600],
                        ),
                        title: Text(drink.name),
                        subtitle: Text('${drink.amount.round()}ml - ${drink.calories} kcal'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _formatTime(drink.dateTime),
                              style: TextStyle(color: Colors.grey[600], fontSize: 12),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 20),
                              onPressed: () async {
                                await provider.deleteDrink(drink.id);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Bebida removida')),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                const SizedBox(height: 24),
                const Text(
                  'Sugestões de Bebidas',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                // Mock suggestions
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.local_cafe),
                    title: const Text('Café Preto'),
                    subtitle: const Text('200ml - 5 kcal'),
                    trailing: const Icon(Icons.add),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Bebida adicionada!')),
                      );
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.local_bar),
                    title: const Text('Suco de Laranja'),
                    subtitle: const Text('300ml - 120 kcal'),
                    trailing: const Icon(Icons.add),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Bebida adicionada!')),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: 2,
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.pushNamed(context, '/home');
                  break;
                case 1:
                  Navigator.pushNamed(context, '/meals');
                  break;
                case 2:
                  // Já nas bebidas
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
      },
    );
  }
}
