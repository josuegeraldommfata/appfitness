import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/subscription_provider.dart';
import '../models/plan.dart';
import '../models/subscription.dart';
import 'checkout_screen.dart';

class HerbalifeScreen extends StatefulWidget {
  const HerbalifeScreen({super.key});

  @override
  State<HerbalifeScreen> createState() => _HerbalifeScreenState();
}

class _HerbalifeScreenState extends State<HerbalifeScreen> {
  bool _isHerbalifeClient = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const Text('FitLife Coach'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Herbalife Icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.green[600],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Herbalife',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gerencie sua rede de afiliados',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Sou Cliente/Consultor Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.lightBlue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person, color: Colors.blue[600]),
                          const SizedBox(width: 8),
                          const Text(
                            'Sou Cliente/Consultor Herbalife',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      CheckboxListTile(
                        title: const Text('Sou Cliente / Consultor Herbalife'),
                        value: _isHerbalifeClient,
                        onChanged: (value) {
                          setState(() {
                            _isHerbalifeClient = value ?? false;
                          });
                        },
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Complete seu cadastro Herbalife para ter acesso a produtos exclusivos, descontos especiais e muito mais.',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Cadastre-se com seu Consultor Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.lightGreen[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.people, color: Colors.green[600]),
                          const SizedBox(width: 8),
                          const Text(
                            'Cadastre-se com seu Consultor',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Seu consultor recomendado na rede é:',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Consultant Info Card
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Nome',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const Text(
                              'Marcelo Lima',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'ID Herbalife',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '432778451',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.green[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Letras',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const Text(
                              'LIM',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Fazer Cadastro Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    const url = 'https://accounts.myherbalife.com/account/create';
                    try {
                      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Erro ao abrir link')),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Fazer Cadastro Herbalife'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Minha Rede de Afiliados Section
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.purple[50],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Minha Rede de Afiliados',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          icon: Icons.people,
                          value: '0',
                          label: 'Total de Afiliados',
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricCard(
                          icon: Icons.check_circle,
                          value: '0',
                          label: 'Com Herbalife',
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMetricCard(
                          icon: Icons.trending_up,
                          value: '0%',
                          label: 'Taxa de Conversão',
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Plano Líder Section
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.yellow[50],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.workspace_premium, color: Colors.amber[700], size: 32),
                      const SizedBox(width: 8),
                      const Text(
                        'Plano Líder',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Tenha acesso a benefícios exclusivos para líderes de rede:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildBenefitItem('Relatórios avançados da sua rede'),
                  _buildBenefitItem('Ferramentas de comunicação com afiliados'),
                  _buildBenefitItem('Suporte prioritário'),
                  _buildBenefitItem('Badge exclusivo de Líder'),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'R\$ 99,90/mês',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber[700],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final leaderPlan = Plans.leaderPlan;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckoutScreen(
                                plan: leaderPlan,
                                billingPeriod: BillingPeriod.monthly,
                                source: 'herbalife',
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Ativar Plano Líder'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100), // Espaço para o bottom nav
          ],
        ),
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
                  onTap: () {},
                  isActive: true,
                ),
                _buildNavButton(
                  context,
                  label: 'Perfil',
                  icon: Icons.person,
                  onTap: () {
                    Navigator.pushNamed(context, '/profile');
                  },
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

  Widget _buildMetricCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green[600], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
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
