import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/app_provider.dart';
import '../models/meal.dart';
import '../services/firebase_service.dart';

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
  final FirebaseService _firebaseService = FirebaseService();
  List<Map<String, dynamic>> _foods = [];
  bool _isLoadingFoods = false;

  final List<String> _mealTypes = [
    'Café da Manhã',
    'Almoço',
    'Jantar',
    'Lanche',
  ];

  @override
  void initState() {
    super.initState();
    _loadFoods();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Receber tipo de refeição como argumento - deve ser feito aqui, não no initState
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String && _mealType != args) {
      setState(() {
        _mealType = args;
      });
    }
  }

  Future<void> _loadFoods() async {
    setState(() {
      _isLoadingFoods = true;
    });
    try {
      // Buscar todos os alimentos do Firebase
      final allFoods = await _firebaseService.getAllFoods();
      setState(() {
        _foods = allFoods;
        _isLoadingFoods = false;
      });
    } catch (e) {
      print('Error loading foods: $e');
      setState(() {
        _isLoadingFoods = false;
      });
    }
  }

  List<Map<String, dynamic>> get _filteredFoods {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) return _foods;
    return _foods.where((food) =>
        food['name']?.toString().toLowerCase().contains(query) ?? false).toList();
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

  Future<void> _saveMeal() async {
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
    
    // Mostrar loading
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    try {
      // Aguardar o salvamento e recarregamento dos dados
      await provider.addMeal(meal);
      
      if (mounted) {
        Navigator.pop(context); // Fechar loading
        Navigator.pop(context); // Fechar tela de adicionar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Refeição $_mealType adicionada!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Fechar loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar refeição: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Refeição'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: _scanBarcode,
            tooltip: 'Escanear Código de Barras',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ElevatedButton.icon(
              onPressed: _saveMeal,
              icon: const Icon(Icons.save, size: 18),
              label: const Text('Salvar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue[600],
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
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

          // Content - Sempre mostrar ambos: alimentos selecionados E lista para adicionar mais
          Expanded(
            child: _isLoadingFoods
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      // Alimentos Selecionados (se houver)
                      if (_selectedFoods.isNotEmpty)
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Alimentos Adicionados (${_selectedFoods.length})',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          _selectedFoods.clear();
                                        });
                                      },
                                      icon: const Icon(Icons.clear, size: 18),
                                      label: const Text('Limpar tudo'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: _buildSelectedFoodsList(),
                              ),
                            ],
                          ),
                        ),
                      
                      // Divisor e botão para adicionar mais
                      if (_selectedFoods.isNotEmpty) ...[
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              Expanded(child: Divider(color: Colors.grey[300])),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Adicionar mais alimentos',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Expanded(child: Divider(color: Colors.grey[300])),
                            ],
                          ),
                        ),
                      ],
                      
                      // Lista de Alimentos Disponíveis
                      Expanded(
                        flex: _selectedFoods.isEmpty ? 1 : 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_selectedFoods.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: const Text(
                                  'Buscar e Adicionar Alimentos',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            Expanded(
                              child: _buildFoodList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodList() {
    if (_filteredFoods.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              _foods.isEmpty 
                  ? 'Nenhum alimento encontrado no banco de dados'
                  : 'Nenhum alimento encontrado com essa busca',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      itemCount: _filteredFoods.length,
      itemBuilder: (context, index) {
        final food = _filteredFoods[index];
        final calories = food['calories'] ?? 0;
        final protein = food['protein'] ?? 0.0;
        final carbs = food['carbs'] ?? 0.0;
        final fat = food['fat'] ?? 0.0;
        final serving = food['serving'] ?? '100g';
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            title: Text(food['name'] ?? 'Alimento'),
            subtitle: Text(
              '$calories kcal • ${protein}g P • ${carbs}g C • ${fat}g G • $serving',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _addFood({
                'name': food['name'] ?? 'Alimento',
                'calories': calories,
                'protein': protein,
                'carbs': carbs,
                'fat': fat,
                'serving': serving,
              }),
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
