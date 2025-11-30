import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTime _selectedDate = DateTime.now();
  Map<String, dynamic> _reportData = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadReportData();
  }

  Future<void> _loadReportData() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Buscar dados reais do Firebase para a data selecionada
      final reportData = await provider.getReportDataForDate(_selectedDate);
      setState(() {
        _reportData = reportData;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading report data: $e');
      // Fallback para dados básicos mesmo se houver erro
      setState(() {
        _reportData = {
          'totalUsers': provider.userCount,
          'activeUsers': provider.activeUsersCount,
          'totalMeals': 0,
          'averageCalories': 0,
          'topFoods': [],
          'userGrowth': [],
          'revenue': 0.0,
          'subscriptions': [],
        };
        _isLoading = false;
      });
    }
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
          PopupMenuButton<String>(
            icon: const Icon(Icons.download),
            tooltip: 'Baixar relatório',
            onSelected: (value) {
              if (value == 'pdf') {
                _exportToPDF();
              } else if (value == 'excel') {
                _exportToExcel();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'pdf',
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Exportar PDF'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'excel',
                child: Row(
                  children: [
                    Icon(Icons.table_chart, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Exportar Excel'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                    onPressed: _exportToPDF,
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
                    onPressed: _exportToExcel,
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

  Future<void> _exportToPDF() async {
    final dateStr = DateFormat('dd/MM/yyyy').format(_selectedDate);
    final reportText = _generateReportText();
    
    final pdfContent = '''
RELATÓRIO NUDGE - $dateStr

$_reportDivider

$reportText

$_reportDivider
Gerado em: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}
''';

    await Share.share(
      pdfContent,
      subject: 'Relatório NUDGE - $dateStr',
    );
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Relatório compartilhado!')),
      );
    }
  }

  Future<void> _exportToExcel() async {
    final dateStr = DateFormat('dd/MM/yyyy').format(_selectedDate);
    final csvContent = _generateCSVContent();
    
    await Share.share(
      csvContent,
      subject: 'Relatório NUDGE - $dateStr.csv',
    );
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Relatório CSV compartilhado!')),
      );
    }
  }

  String _generateReportText() {
    return '''
MÉTRICAS PRINCIPAIS
Total de Usuários: ${_reportData['totalUsers'] ?? 0}
Usuários Ativos: ${_reportData['activeUsers'] ?? 0}
Refeições Registradas: ${_reportData['totalMeals'] ?? 0}
Calorias Médias: ${_reportData['averageCalories'] ?? 0} kcal
Receita do Dia: R\$ ${(_reportData['revenue'] ?? 0.0).toStringAsFixed(2)}
Assinaturas Ativas: ${_reportData['subscriptions'] ?? 0}

ALIMENTOS MAIS CONSUMIDOS
${(_reportData['topFoods'] as List?)?.map((f) => '${f['name']}: ${f['count']} vezes').join('\n') ?? 'Nenhum dado disponível'}
''';
  }

  String _generateCSVContent() {
    final lines = <String>[
      'Relatório NUDGE - ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
      '',
      'Métrica,Valor',
      'Total de Usuários,${_reportData['totalUsers'] ?? 0}',
      'Usuários Ativos,${_reportData['activeUsers'] ?? 0}',
      'Refeições Registradas,${_reportData['totalMeals'] ?? 0}',
      'Calorias Médias,${_reportData['averageCalories'] ?? 0}',
      'Receita do Dia,${_reportData['revenue'] ?? 0.0}',
      'Assinaturas Ativas,${_reportData['subscriptions'] ?? 0}',
      '',
      'Alimento,Quantidade',
    ];
    
    for (var food in (_reportData['topFoods'] as List?) ?? []) {
      lines.add('${food['name']},${food['count']}');
    }
    
    return lines.join('\n');
  }

  String get _reportDivider => '─' * 50;
}
