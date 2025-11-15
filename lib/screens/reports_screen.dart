import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTime _selectedDate = DateTime.now();
  Map<String, dynamic> _reportData = {};

  @override
  void initState() {
    super.initState();
    _loadReportData();
  }

  void _loadReportData() {
    final provider = Provider.of<AppProvider>(context, listen: false);
    // Mock report data - in a real app, this would come from Firestore analytics
    setState(() {
      _reportData = {
        'totalUsers': provider.userCount,
        'activeUsers': provider.activeUsersCount,
        'totalMeals': provider.totalMealsToday,
        'averageCalories': 1850,
        'topFoods': [
          {'name': 'Arroz Branco', 'count': 45},
          {'name': 'Frango Grelhado', 'count': 38},
          {'name': 'Salada Verde', 'count': 32},
        ],
        'userGrowth': [
          {'month': 'Jan', 'users': 120},
          {'month': 'Fev', 'users': 145},
          {'month': 'Mar', 'users': 168},
          {'month': 'Abr', 'users': 192},
        ],
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatórios'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                setState(() {
                  _selectedDate = picked;
                });
                _loadReportData();
              }
            },
            tooltip: 'Selecionar data',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Relatório baixado - Em breve!')),
              );
            },
            tooltip: 'Baixar relatório',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date selector
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.green),
                    const SizedBox(width: 16),
                    Text(
                      'Relatório de ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Key Metrics
            Text(
              'Métricas Principais',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Total Usuários',
                    _reportData['totalUsers']?.toString() ?? '0',
                    Icons.people,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricCard(
                    'Usuários Ativos',
                    _reportData['activeUsers']?.toString() ?? '0',
                    Icons.person,
                    Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Refeições Hoje',
                    _reportData['totalMeals']?.toString() ?? '0',
                    Icons.restaurant,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricCard(
                    'Calorias Médias',
                    '${_reportData['averageCalories'] ?? 0}',
                    Icons.local_fire_department,
                    Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Top Foods
            Text(
              'Alimentos Mais Consumidos',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: (_reportData['topFoods'] as List?)?.length ?? 0,
                itemBuilder: (context, index) {
                  final food = (_reportData['topFoods'] as List)[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green[100],
                      child: Text('${index + 1}'),
                    ),
                    title: Text(food['name']),
                    trailing: Text('${food['count']} vezes'),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // User Growth Chart (Mock)
            Text(
              'Crescimento de Usuários',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Simple bar chart mock
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: (_reportData['userGrowth'] as List?)?.map<Widget>((data) {
                        return Column(
                          children: [
                            Container(
                              height: (data['users'] / 2.0).clamp(20, 100),
                              width: 30,
                              color: Colors.green,
                              child: Center(
                                child: Text(
                                  '${data['users']}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(data['month'], style: const TextStyle(fontSize: 12)),
                          ],
                        );
                      }).toList() ?? [],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Número de usuários por mês',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Export Options
            Text(
              'Opções de Exportação',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Exportando para PDF...')),
                      );
                    },
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('PDF'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Exportando para Excel...')),
                      );
                    },
                    icon: const Icon(Icons.table_chart),
                    label: const Text('Excel'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
