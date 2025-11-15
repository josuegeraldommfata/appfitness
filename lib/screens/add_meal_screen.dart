import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/app_provider.dart';
import '../models/meal.dart';

class AddMealScreen extends StatefulWidget {
  const AddMealScreen({super.key});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  String _mealType = 'Café da Manhã';
  final List<Map<String, dynamic>> _selectedFoods = [];
  final TextEditingController _searchController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  final List<String> _mealTypes = [
    'Café da Manhã',
    'Almoço',
    'Jantar',
    'Lanche',
  ];

  final List<Map<String, dynamic>> _mockFoods = [
    {
      'name': 'Aveia',
      'calories': 150,
      'protein': 5.0,
      'carbs': 27.0,
      'fat': 3.0,
      'serving': '100g',
    },
    {
      'name': 'Banana',
      'calories': 105,
      'protein': 1.3,
      'carbs': 27.0,
      'fat': 0.4,
      'serving': '1 unidade',
    },
    {
      'name': 'Peito de Frango',
      'calories': 165,
      'protein': 31.0,
      'carbs': 0.0,
      'fat': 3.6,
      'serving': '100g',
    },
    {
      'name': 'Arroz Branco',
      'calories': 130,
      'protein': 2.7,
      'carbs': 28.0,
      'fat': 0.3,
      'serving': '100g',
    },
    {
      'name': 'Brócolis',
      'calories': 55,
      'protein': 3.7,
      'carbs': 11.0,
      'fat': 0.6,
      'serving': '100g',
    },
  ];

  List<Map<String, dynamic>> get _filteredFoods {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) return _mockFoods;
    return _mockFoods.where((food) =>
        food['name'].toLowerCase().contains(query)).toList();
  }

  void _addFood(Map<String, dynamic> food) {
    setState(() {
      _selectedFoods.add({
        ...food,
        'quantity': 1.0,
      });
    });
  }

  void _removeFood(int index) {
    setState(() {
      _selectedFoods.removeAt(index);
    });
  }

  void _updateQuantity(int index, double quantity) {
    setState(() {
      _selectedFoods[index]['quantity'] = quantity;
    });
  }

  int get _totalCalories {
    return _selectedFoods.fold(0, (sum, food) {
      final quantity = food['quantity'] as double;
      final calories = food['calories'] as int;
      return sum + (calories * quantity).round();
    });
  }

  Map<String, double> get _totalMacros {
    double protein = 0;
    double carbs = 0;
    double fat = 0;

    for (final food in _selectedFoods) {
      final quantity = food['quantity'] as double;
      protein += (food['protein'] as double) * quantity;
      carbs += (food['carbs'] as double) * quantity;
      fat += (food['fat'] as double) * quantity;
    }

    return {
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
    };
  }

  Future<void> _scanBarcode() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null && mounted) {
        // Simular escaneamento - adicionar um alimento mockado
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Código escaneado! Adicionando alimento...')),
        );
        // Adicionar um alimento mockado como exemplo
        _addFood({
          'name': 'Produto Escaneado',
          'calories': 200,
          'protein': 10.0,
          'carbs': 20.0,
          'fat': 5.0,
          'serving': '100g',
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao escanear: $e')),
        );
      }
    }
  }

  void _saveMeal() {
    if (_selectedFoods.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adicione pelo menos um alimento')),
      );
      return;
    }

    final foods = _selectedFoods.map((food) => FoodItem(
      id: food['name'],
      name: food['name'],
      quantity: food['quantity'],
      calories: food['calories'],
      protein: food['protein'],
      carbs: food['carbs'],
      fat: food['fat'],
    )).toList();

    final meal = Meal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _mealType,
      type: _mealType,
      dateTime: DateTime.now(),
      foods: foods,
      totalCalories: _totalCalories,
      totalMacros: _totalMacros,
    );

    final provider = Provider.of<AppProvider>(context, listen: false);
    provider.addMeal(meal);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Refeição $_mealType adicionada!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Refeição'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: _scanBarcode,
            tooltip: 'Escanear Código de Barras',
          ),
          TextButton(
            onPressed: _saveMeal,
            child: const Text(
              'Salvar',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Meal Type Selector
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: DropdownButtonFormField<String>(
              // ignore: deprecated_member_use
              value: _mealType,
              decoration: const InputDecoration(
                labelText: 'Tipo de Refeição',
                border: OutlineInputBorder(),
              ),
              items: _mealTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _mealType = value!;
                });
              },
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar alimentos...',
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

          // Selected Foods Summary
          if (_selectedFoods.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.green[50],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_selectedFoods.length} alimentos',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$_totalCalories kcal • ${_totalMacros['protein']?.round()}g P • ${_totalMacros['carbs']?.round()}g C • ${_totalMacros['fat']?.round()}g G',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _selectedFoods.clear();
                      });
                    },
                  ),
                ],
              ),
            ),

          // Content
          Expanded(
            child: _selectedFoods.isEmpty
                ? _buildFoodList()
                : _buildSelectedFoodsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodList() {
    return ListView.builder(
      itemCount: _filteredFoods.length,
      itemBuilder: (context, index) {
        final food = _filteredFoods[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            title: Text(food['name']),
            subtitle: Text(
              '${food['calories']} kcal • ${food['protein']}g P • ${food['carbs']}g C • ${food['fat']}g G • ${food['serving']}',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _addFood(food),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectedFoodsList() {
    return ListView.builder(
      itemCount: _selectedFoods.length,
      itemBuilder: (context, index) {
        final food = _selectedFoods[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        food['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeFood(index),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('Quantidade: '),
                    Expanded(
                      child: Slider(
                        value: food['quantity'],
                        min: 0.1,
                        max: 5.0,
                        divisions: 49,
                        label: '${food['quantity'].toStringAsFixed(1)}x',
                        onChanged: (value) => _updateQuantity(index, value),
                      ),
                    ),
                    Text(food['quantity'].toStringAsFixed(1) + 'x'),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${(food['calories'] * food['quantity']).round()} kcal • ${(food['protein'] * food['quantity']).toStringAsFixed(1)}g P • ${(food['carbs'] * food['quantity']).toStringAsFixed(1)}g C • ${(food['fat'] * food['quantity']).toStringAsFixed(1)}g G',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
