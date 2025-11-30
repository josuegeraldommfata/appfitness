import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/user.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _targetWeightController = TextEditingController();
  final _dailyCalorieGoalController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();

  String _bodyType = 'mesomorfo';
  String _goal = 'manutenção';
  bool _isLoading = false;
  DateTime? _selectedDate;

  final List<String> _bodyTypes = ['ectomorfo', 'mesomorfo', 'endomorfo'];
  final List<String> _goals = ['perda de peso', 'ganho de peso', 'manutenção'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _birthDateController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    _dailyCalorieGoalController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _birthDateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem')),
      );
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione a data de nascimento')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = User(
        id: '', // Será definido pelo backend
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        birthDate: _selectedDate!,
        height: double.tryParse(_heightController.text) ?? 170,
        weight: double.tryParse(_weightController.text) ?? 70,
        bodyType: _bodyType,
        goal: _goal,
        targetWeight: double.tryParse(_targetWeightController.text) ?? 70,
        dailyCalorieGoal: int.tryParse(_dailyCalorieGoalController.text) ?? 2000,
        macroGoals: {
          'protein': double.tryParse(_proteinController.text) ?? 150,
          'carbs': double.tryParse(_carbsController.text) ?? 200,
          'fat': double.tryParse(_fatController.text) ?? 65,
        },
      );

      final provider = Provider.of<AppProvider>(context, listen: false);
      final success = await provider.signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        user,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cadastro realizado com sucesso!')),
        );
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao cadastrar. Tente novamente.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[400]!, Colors.green[800]!],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo/Title
                      Icon(
                        Icons.restaurant_menu,
                        size: 64,
                        color: Colors.green[600],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nudge',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Crie sua conta',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 32),

                      // Name Field
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Nome completo *',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nome é obrigatório';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),

                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email *',
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email é obrigatório';
                          }
                          if (!value.contains('@')) {
                            return 'Email inválido';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),

                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Senha *',
                          prefixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Senha é obrigatória';
                          }
                          if (value.length < 6) {
                            return 'Senha deve ter pelo menos 6 caracteres';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),

                      // Confirm Password Field
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Confirmar senha *',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Confirmação de senha é obrigatória';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),

                      // Birth Date Field
                      TextFormField(
                        controller: _birthDateController,
                        decoration: InputDecoration(
                          labelText: 'Data de nascimento',
                          prefixIcon: const Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.date_range),
                            onPressed: () => _selectDate(context),
                          ),
                        ),
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),

                      // Height and Weight Row
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _heightController,
                              decoration: InputDecoration(
                                labelText: 'Altura (cm)',
                                prefixIcon: const Icon(Icons.height),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _weightController,
                              decoration: InputDecoration(
                                labelText: 'Peso (kg)',
                                prefixIcon: const Icon(Icons.monitor_weight),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Body Type Dropdown
                      DropdownButtonFormField<String>(
                        value: _bodyType,
                        decoration: InputDecoration(
                          labelText: 'Tipo corporal',
                          prefixIcon: const Icon(Icons.accessibility),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: _bodyTypes.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type[0].toUpperCase() + type.substring(1)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _bodyType = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Goal Dropdown
                      DropdownButtonFormField<String>(
                        value: _goal,
                        decoration: InputDecoration(
                          labelText: 'Objetivo',
                          prefixIcon: const Icon(Icons.flag),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: _goals.map((goal) {
                          return DropdownMenuItem(
                            value: goal,
                            child: Text(goal[0].toUpperCase() + goal.substring(1)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _goal = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Target Weight and Daily Calorie Goal Row
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _targetWeightController,
                              decoration: InputDecoration(
                                labelText: 'Peso alvo (kg)',
                                prefixIcon: const Icon(Icons.track_changes),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _dailyCalorieGoalController,
                              decoration: InputDecoration(
                                labelText: 'Meta calórica',
                                prefixIcon: const Icon(Icons.local_fire_department),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Macronutrients Row
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _proteinController,
                              decoration: InputDecoration(
                                labelText: 'Proteína (g)',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _carbsController,
                              decoration: InputDecoration(
                                labelText: 'Carboidratos (g)',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _fatController,
                              decoration: InputDecoration(
                                labelText: 'Gordura (g)',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _register(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : const Text(
                                  'Cadastrar',
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Back to Login
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Já tem conta? Faça login',
                          style: TextStyle(color: Colors.green[600]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
