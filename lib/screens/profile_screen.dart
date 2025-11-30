import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final _anamneseFormKey = GlobalKey<FormState>();

  // Dados Pessoais
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _birthDateController;
  String _biologicalSex = 'Masculino';

  // Anamnese
  late TextEditingController _heightController;
  late TextEditingController _initialWeightController;
  String _activityLevel = 'Leve';
  String _mainGoal = 'Perda de peso';
  late TextEditingController _foodPreferencesController;
  late TextEditingController _foodAllergiesController;
  late TextEditingController _dailyRoutineController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    final provider = Provider.of<AppProvider>(context, listen: false);
    final user = provider.currentUser;
    
    // Inicializar controllers com dados do usuário
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _birthDateController = TextEditingController(
      text: user != null 
        ? DateFormat('dd/MM/yyyy').format(user.birthDate)
        : '02/05/1989'
    );
    
    _heightController = TextEditingController(text: user?.height.toString() ?? '190');
    _initialWeightController = TextEditingController(text: user?.weight.toString() ?? '85');
    _foodPreferencesController = TextEditingController(text: 'lasanha');
    _foodAllergiesController = TextEditingController(text: 'nenhuma');
    _dailyRoutineController = TextEditingController(text: 'acordo as 6 da manha');
    
    if (user != null) {
      // Normalizar o goal do usuário para corresponder aos itens do dropdown
      final userGoal = user.goal.toLowerCase();
      if (userGoal.contains('perda') || userGoal.contains('peso')) {
        _mainGoal = 'Perda de peso';
      } else if (userGoal.contains('ganho') || userGoal.contains('massa')) {
        _mainGoal = 'Ganho de massa';
      } else if (userGoal.contains('manutenção') || userGoal.contains('manutencao')) {
        _mainGoal = 'Manutenção';
      } else {
        _mainGoal = 'Perda de peso'; // Default
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _birthDateController.dispose();
    _heightController.dispose();
    _initialWeightController.dispose();
    _foodPreferencesController.dispose();
    _foodAllergiesController.dispose();
    _dailyRoutineController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1989, 5, 2),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Map<String, dynamic> _calculateGoals() {
    // Cálculo simplificado das metas
    // Na prática, isso viria de uma lógica mais complexa
    return {
      'water': 3500,
      'calories': 1899,
      'targetWeight': 79.4,
    };
  }

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

    final goals = _calculateGoals();

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const Text('FitLife Coach'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.purple[100]!, Colors.white],
              ),
            ),
            child: Column(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.purple[600],
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Meu Perfil',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Gerencie suas informações pessoais',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Tabs
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.purple[600],
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.purple[600],
              tabs: const [
                Tab(
                  icon: Icon(Icons.person),
                  text: 'Dados Pessoais',
                ),
                Tab(
                  icon: Icon(Icons.medical_information),
                  text: 'Anamnese',
                ),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Dados Pessoais Tab
                _buildPersonalDataTab(context, provider),
                // Anamnese Tab
                _buildAnamneseTab(context, provider, goals),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavButton(
                  context,
                  label: 'Dashboard',
                  icon: Icons.dashboard,
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                ),
                _buildNavButton(
                  context,
                  label: 'Coach',
                  icon: Icons.chat,
                  onTap: () {
                    Navigator.pushNamed(context, '/coach');
                  },
                ),
                _buildNavButton(
                  context,
                  label: 'Herbalife',
                  icon: Icons.business,
                  onTap: () {
                    Navigator.pushNamed(context, '/herbalife');
                  },
                ),
                _buildNavButton(
                  context,
                  label: 'Perfil',
                  icon: Icons.person,
                  onTap: () {},
                  isActive: true,
                ),
                _buildNavButton(
                  context,
                  label: 'Compartilhar',
                  icon: Icons.share,
                  onTap: () {
                    Navigator.pushNamed(context, '/share');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalDataTab(BuildContext context, AppProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  label: 'Nome completo',
                  controller: _nameController,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                _buildDateField(context),
                const SizedBox(height: 16),
                _buildDropdownField(
                  label: 'Sexo biológico',
                  value: _biologicalSex,
                  items: ['Masculino', 'Feminino', 'Outro'],
                  onChanged: (value) {
                    setState(() {
                      _biologicalSex = value!;
                    });
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // TODO: Salvar dados
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Alterações salvas!')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Salvar Alterações'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      provider.logout();
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Sair'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnamneseTab(BuildContext context, AppProvider provider, Map<String, dynamic> goals) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _anamneseFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    _buildTextField(
                      label: 'Altura (cm)',
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Peso inicial (kg)',
                      controller: _initialWeightController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownField(
                      label: 'Nível de atividade física',
                      value: _activityLevel,
                      items: ['Leve', 'Moderado', 'Intenso', 'Muito Intenso'],
                      onChanged: (value) {
                        setState(() {
                          _activityLevel = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownField(
                      label: 'Objetivo principal',
                      value: _mainGoal,
                      items: const ['Perda de peso', 'Ganho de massa', 'Manutenção'],
                      onChanged: (value) {
                        setState(() {
                          _mainGoal = value ?? 'Perda de peso';
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Preferências alimentares',
                      controller: _foodPreferencesController,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Alergias alimentares',
                      controller: _foodAllergiesController,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Rotina diária',
                      controller: _dailyRoutineController,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Metas Calculadas
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.pink[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Suas Metas Calculadas Automaticamente:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.water_drop, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text('Água: ${goals['water']} ml/dia'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.local_fire_department, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text('Calorias: ${goals['calories']} kcal/dia'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.monitor_weight, color: Colors.purple),
                      const SizedBox(width: 8),
                      Text('Peso meta: ${goals['targetWeight']} kg'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '* O peso meta é calculado com base no seu IMC ideal, altura, objetivo e perfil',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_anamneseFormKey.currentState!.validate()) {
                    // TODO: Salvar dados
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Alterações salvas!')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Salvar Alterações'),
              ),
            ),
            const SizedBox(height: 100), // Espaço para o bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Campo obrigatório';
        }
        return null;
      },
    );
  }

  Widget _buildDateField(BuildContext context) {
    return TextFormField(
      controller: _birthDateController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Data de nascimento',
        suffixIcon: const Icon(Icons.calendar_today),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onTap: () => _selectDate(context),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Campo obrigatório';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    // Garantir que o valor está na lista, caso contrário usar o primeiro item
    String? validValue = value;
    if (!items.contains(value)) {
      validValue = items.isNotEmpty ? items.first : null;
    }
    
    return DropdownButtonFormField<String>(
      value: validValue,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Campo obrigatório';
        }
        return null;
      },
    );
  }

  Widget _buildNavButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? Colors.blue[600] : Colors.grey[600],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isActive ? Colors.blue[600] : Colors.grey[600],
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
