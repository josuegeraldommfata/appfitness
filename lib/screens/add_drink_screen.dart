import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class AddDrinkScreen extends StatefulWidget {
  const AddDrinkScreen({super.key});

  @override
  State<AddDrinkScreen> createState() => _AddDrinkScreenState();
}

class _AddDrinkScreenState extends State<AddDrinkScreen> {
  final TextEditingController _searchController = TextEditingController();
  double _quantity = 1.0; // in liters or ml
  String _selectedDrink = 'Água';

  final List<Map<String, dynamic>> _mockDrinks = [
    {
      'name': 'Água',
      'calories': 0,
      'serving': '200ml',
    },
    {
      'name': 'Café Preto',
      'calories': 5,
      'serving': '200ml',
    },
    {
      'name': 'Suco de Laranja',
      'calories': 120,
      'serving': '300ml',
    },
    {
      'name': 'Refrigerante',
      'calories': 140,
      'serving': '350ml',
    },
    {
      'name': 'Leite',
      'calories': 150,
      'serving': '200ml',
    },
    {
      'name': 'Chá Verde',
      'calories': 0,
      'serving': '200ml',
    },
  ];

  List<Map<String, dynamic>> get _filteredDrinks {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) return _mockDrinks;
    return _mockDrinks.where((drink) =>
        drink['name'].toLowerCase().contains(query)).toList();
  }

  void _saveDrink() {
    final drink = _filteredDrinks.firstWhere(
      (d) => d['name'] == _selectedDrink,
      orElse: () => _mockDrinks[0],
    );

    final calories = (drink['calories'] as int) * _quantity;
    final amount = _quantity * 1000; // convert to ml

    final provider = Provider.of<AppProvider>(context, listen: false);
    provider.addWater(amount); // For now, treat all drinks as water intake

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${drink['name']} adicionado! +${calories.round()} kcal')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Bebida'),
        actions: [
          TextButton(
            onPressed: _saveDrink,
            child: const Text(
              'Salvar',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar bebidas...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),

          // Quantity Selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quantidade',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: _quantity,
                            min: 0.1,
                            max: 2.0,
                            divisions: 19,
                            label: '${_quantity.toStringAsFixed(1)}L',
                            onChanged: (value) {
                              setState(() {
                                _quantity = value;
                              });
                            },
                          ),
                        ),
                        Text('${_quantity.toStringAsFixed(1)}L'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Drinks List
          Expanded(
            child: ListView.builder(
              itemCount: _filteredDrinks.length,
              itemBuilder: (context, index) {
                final drink = _filteredDrinks[index];
                final isSelected = drink['name'] == _selectedDrink;

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  color: isSelected ? Colors.green[50] : null,
                  child: ListTile(
                    leading: Icon(
                      Icons.local_drink,
                      color: isSelected ? Colors.green : null,
                    ),
                    title: Text(drink['name']),
                    subtitle: Text(
                      '${drink['calories']} kcal • ${drink['serving']}',
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedDrink = drink['name'];
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
