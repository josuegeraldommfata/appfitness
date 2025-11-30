import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/challenge.dart';

class AddChallengeScreen extends StatefulWidget {
  const AddChallengeScreen({super.key});

  @override
  State<AddChallengeScreen> createState() => _AddChallengeScreenState();
}

class _AddChallengeScreenState extends State<AddChallengeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetController = TextEditingController();
  
  String _selectedType = 'custom';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));

  final List<Map<String, String>> _challengeTypes = [
    {'value': 'water', 'label': 'Água', 'unit': 'ml'},
    {'value': 'calories', 'label': 'Calorias', 'unit': 'kcal'},
    {'value': 'exercise', 'label': 'Exercício', 'unit': 'minutos'},
    {'value': 'custom', 'label': 'Personalizado', 'unit': ''},
  ];

  String get _currentUnit {
    return _challengeTypes.firstWhere((t) => t['value'] == _selectedType)['unit'] ?? '';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate.add(const Duration(days: 7));
        }
      });
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _saveChallenge() async {
    if (!_formKey.currentState!.validate()) return;

    final challenge = Challenge(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      type: _selectedType,
      target: double.tryParse(_targetController.text) ?? 0,
      unit: _currentUnit,
      startDate: _startDate,
      endDate: _endDate,
      userId: '',
      participants: [],
      isActive: true,
      createdAt: DateTime.now(),
    );

    final provider = Provider.of<AppProvider>(context, listen: false);
    await provider.addChallenge(challenge);

    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Desafio criado com sucesso!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Desafio'),
        actions: [
          TextButton(
            onPressed: _saveChallenge,
            child: const Text(
              'Salvar',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tipo de Desafio
              Text(
                'Tipo de Desafio',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _challengeTypes.map((type) {
                  final isSelected = _selectedType == type['value'];
                  return FilterChip(
                    label: Text(type['label']!),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedType = type['value']!;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Título
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título do Desafio',
                  hintText: 'Ex: Beber 2L de água por dia',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Digite um título para o desafio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Descrição
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  hintText: 'Descreva o desafio...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Digite uma descrição';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Meta
              TextFormField(
                controller: _targetController,
                decoration: InputDecoration(
                  labelText: 'Meta',
                  hintText: 'Ex: 2000',
                  suffixText: _currentUnit.isNotEmpty ? _currentUnit : null,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Digite a meta';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Digite um número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Datas
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: ListTile(
                        title: const Text('Data de Início'),
                        subtitle: Text(
                          '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                        ),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: _selectStartDate,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Card(
                      child: ListTile(
                        title: const Text('Data de Término'),
                        subtitle: Text(
                          '${_endDate.day}/${_endDate.month}/${_endDate.year}',
                        ),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: _selectEndDate,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

