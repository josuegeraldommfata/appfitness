import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/drink.dart';
import '../services/firebase_service.dart';

class AddDrinkScreen extends StatefulWidget {
  const AddDrinkScreen({super.key});

  @override
  State<AddDrinkScreen> createState() => _AddDrinkScreenState();
}

class _AddDrinkScreenState extends State<AddDrinkScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();
  final List<Map<String, dynamic>> _selectedDrinks = []; // Lista de bebidas selecionadas
  List<Map<String, dynamic>> _drinks = [];
  bool _isLoadingDrinks = false;

  @override
  void initState() {
    super.initState();
    _loadDrinks();
  }

  Future<void> _loadDrinks() async {
    setState(() {
      _isLoadingDrinks = true;
    });
    try {
      final allDrinks = await _firebaseService.getAllDrinks();
      setState(() {
        _drinks = allDrinks;
        _isLoadingDrinks = false;
      });
    } catch (e) {
      print('Error loading drinks: $e');
      setState(() {
        _isLoadingDrinks = false;
      });
    }
  }

  List<Map<String, dynamic>> get _filteredDrinks {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) return _drinks;
    return _drinks.where((drink) =>
        drink['name']?.toString().toLowerCase().contains(query) ?? false).toList();
  }

  void _addDrink(Map<String, dynamic> drink) {
    setState(() {
      _selectedDrinks.add({
        ...drink,
        'quantity': 1.0, // em litros
      });
    });
  }

  void _removeDrink(int index) {
    setState(() {
      _selectedDrinks.removeAt(index);
    });
  }

  void _updateQuantity(int index, double quantity) {
    setState(() {
      _selectedDrinks[index]['quantity'] = quantity;
    });
  }

  int get _totalCalories {
    return _selectedDrinks.fold(0, (sum, drink) {
      final baseCalories = (drink['calories'] ?? 0) as int;
      final servingMl = _parseServingToMl(drink['serving'] ?? '200ml');
      final caloriesPerMl = servingMl > 0 ? baseCalories / servingMl : 0;
      final totalMl = (drink['quantity'] as double) * 1000;
      return sum + (caloriesPerMl * totalMl).round();
    });
  }

  Future<void> _saveDrinks() async {
    if (_selectedDrinks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adicione pelo menos uma bebida')),
      );
      return;
    }

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
      // Salvar todas as bebidas
      for (final drinkData in _selectedDrinks) {
        final baseCalories = (drinkData['calories'] ?? 0) as int;
        final servingMl = _parseServingToMl(drinkData['serving'] ?? '200ml');
        final caloriesPerMl = servingMl > 0 ? baseCalories / servingMl : 0;
        final totalMl = (drinkData['quantity'] as double) * 1000;
        final calories = (caloriesPerMl * totalMl).round();

        final drinkModel = Drink(
          id: '',
          name: drinkData['name'] as String,
          amount: totalMl,
          calories: calories,
          dateTime: DateTime.now(),
        );

        await provider.addDrink(drinkModel);
      }

      if (mounted) {
        Navigator.pop(context); // Fechar loading
        Navigator.pop(context); // Fechar tela de adicionar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_selectedDrinks.length} bebida(s) adicionada(s)! +$_totalCalories kcal'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Fechar loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar bebidas: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  int _parseServingToMl(String serving) {
    // Parse "200ml" or "1 copo" to ml
    if (serving.toLowerCase().contains('ml')) {
      final match = RegExp(r'(\d+)').firstMatch(serving);
      if (match != null) return int.parse(match.group(1)!);
    }
    return 200; // default
  }

  Widget _buildDrinksList() {
    if (_filteredDrinks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_drink, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              _drinks.isEmpty
                  ? 'Nenhuma bebida encontrada no banco de dados'
                  : 'Nenhuma bebida encontrada com essa busca',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      itemCount: _filteredDrinks.length,
      itemBuilder: (context, index) {
        final drink = _filteredDrinks[index];
        final drinkName = drink['name'] ?? 'Bebida';
        final calories = drink['calories'] ?? 0;
        final serving = drink['serving'] ?? '200ml';

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: Icon(Icons.local_drink, color: Colors.blue[600]),
            title: Text(drinkName),
            subtitle: Text(
              '$calories kcal • $serving',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _addDrink({
                'name': drinkName,
                'calories': calories,
                'serving': serving,
              }),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectedDrinksList() {
    return ListView.builder(
      itemCount: _selectedDrinks.length,
      itemBuilder: (context, index) {
        final drink = _selectedDrinks[index];
        final baseCalories = (drink['calories'] ?? 0) as int;
        final servingMl = _parseServingToMl(drink['serving'] ?? '200ml');
        final caloriesPerMl = servingMl > 0 ? baseCalories / servingMl : 0;
        final totalMl = (drink['quantity'] as double) * 1000;
        final calories = (caloriesPerMl * totalMl).round();

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
                        drink['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeDrink(index),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('Quantidade: '),
                    Expanded(
                      child: Slider(
                        value: drink['quantity'],
                        min: 0.1,
                        max: 2.0,
                        divisions: 19,
                        label: '${drink['quantity'].toStringAsFixed(1)}L',
                        onChanged: (value) => _updateQuantity(index, value),
                      ),
                    ),
                    Text('${drink['quantity'].toStringAsFixed(1)}L'),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '$calories kcal • ${(totalMl / 1000).toStringAsFixed(1)}L',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Bebida'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ElevatedButton.icon(
              onPressed: _saveDrinks,
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

          // Selected Drinks Summary
          if (_selectedDrinks.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue[50],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_selectedDrinks.length} bebida(s)',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$_totalCalories kcal',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _selectedDrinks.clear();
                      });
                    },
                  ),
                ],
              ),
            ),

          // Content - Sempre mostrar ambos: bebidas selecionadas E lista para adicionar mais
          Expanded(
            child: _isLoadingDrinks
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      // Bebidas Selecionadas (se houver)
                      if (_selectedDrinks.isNotEmpty)
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
                                      'Bebidas Adicionadas (${_selectedDrinks.length})',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          _selectedDrinks.clear();
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
                                child: _buildSelectedDrinksList(),
                              ),
                            ],
                          ),
                        ),
                      
                      // Divisor e texto para adicionar mais
                      if (_selectedDrinks.isNotEmpty) ...[
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              Expanded(child: Divider(color: Colors.grey[300])),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Adicionar mais bebidas',
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
                      
                      // Lista de Bebidas Disponíveis
                      Expanded(
                        flex: _selectedDrinks.isEmpty ? 1 : 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_selectedDrinks.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: const Text(
                                  'Buscar e Adicionar Bebidas',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            Expanded(
                              child: _buildDrinksList(),
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
}
