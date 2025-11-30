import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../providers/app_provider.dart';

class ShareScreen extends StatefulWidget {
  const ShareScreen({super.key});

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  String? _referralCode;
  String? _referralLink;

  @override
  void initState() {
    super.initState();
    _generateReferralCode();
  }

  void _generateReferralCode() {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final user = provider.currentUser;
    
    if (user != null) {
      // Usar código existente ou gerar um novo
      if (user.referralCode != null && user.referralCode!.isNotEmpty) {
        _referralCode = user.referralCode;
      } else {
        // Gerar código único aleatório
        final random = Random();
        const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        _referralCode = String.fromCharCodes(
          Iterable.generate(12, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
        );
        // TODO: Salvar o código no backend quando o usuário for atualizado
      }
      
      // URL base - será atualizada quando o app estiver na Play Store
      // Por enquanto usa a URL web, depois será substituída pela URL da Play Store
      const baseUrl = 'https://fit-life-coach-72a67c9e.base44.app';
      _referralLink = '$baseUrl/referral?ref=$_referralCode';
      
      setState(() {});
    }
  }

  Future<void> _copyLink() async {
    if (_referralLink != null) {
      await Clipboard.setData(ClipboardData(text: _referralLink!));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Link copiado para a área de transferência!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

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
                  const SizedBox(height: 20),
                  // Share Icon with Gradient
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.purple[400]!, Colors.pink[400]!],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.share,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Compartilhe',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Convide amigos e construa sua rede',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Referral Link Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Seu link de indicação',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _referralLink ?? 'Carregando...',
                                style: const TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _copyLink,
                          icon: const Icon(Icons.copy),
                          label: const Text('Copiar Link'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple[600],
                            foregroundColor: Colors.white,
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

            const SizedBox(height: 24),

            // Benefits Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildBenefitCard(
                      icon: Icons.all_inclusive,
                      text: 'Convites ilimitados',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildBenefitCard(
                      icon: Icons.card_giftcard,
                      text: 'Benefícios exclusivos',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildBenefitCard(
                      icon: Icons.attach_money,
                      text: 'Ganhe comissões',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // How It Works Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.lightBlue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Como funciona?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildStepItem('1', 'Copie seu link único de indicação'),
                    _buildStepItem('2', 'Compartilhe com amigos e familiares'),
                    _buildStepItem('3', 'Quando eles se cadastrarem, farão parte da sua rede'),
                    _buildStepItem('4', 'Acumule benefícios conforme sua rede cresce'),
                  ],
                ),
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
                  onTap: () {
                    Navigator.pushNamed(context, '/herbalife');
                  },
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
                  onTap: () {},
                  isActive: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitCard({
    required IconData icon,
    required String text,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple[100]!, Colors.pink[100]!],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.purple[400]!, Colors.pink[400]!],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.blue[600],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
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

