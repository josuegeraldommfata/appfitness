import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HerbalifeSection extends StatelessWidget {
  const HerbalifeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.business, color: Colors.green[600], size: 28),
                const SizedBox(width: 12),
                const Text(
                  'Cadastro Herbalife',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Crie sua conta de descontos e presentes exclusivos.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            
            // Link de Cadastro Oficial
            InkWell(
              onTap: () async {
                const url = 'https://accounts.myherbalife.com/account/create';
                try {
                  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao abrir link: $e')),
                    );
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.link, color: Colors.green[700]),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Link de Cadastro Oficial',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    const Text(
                      'Clique para criar sua conta',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.green[700]),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Como vincular ao nosso time
            const Text(
              'Como vincular ao nosso time:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            // Sponsor's Herbalife ID Number
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.green[600],
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '1',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Sponsor\'s Herbalife ID Number: Preencha com o ID do seu upline na Herbalife',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Código de Verificação
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.green[600],
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '2',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Código de Verificação: Digite as 3 primeiras letras do sobrenome do seu upline na Herbalife',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Material de Apoio
            InkWell(
              onTap: () async {
                const url = 'https://clienteherbalife.com.br';
                try {
                  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro ao abrir link: $e')),
                    );
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.description, color: Colors.blue[700]),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cliente Herbalife',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            'Acesse materiais que ajudam no desenvolvimento',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blue[700]),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Precisa de ajuda?
            Row(
              children: [
                Icon(Icons.help_outline, color: Colors.orange[600]),
                const SizedBox(width: 8),
                const Text(
                  'Precisa de ajuda?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Manda uma mensagem para o nosso suporte',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

