import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

class ShareAppModal extends StatelessWidget {
  const ShareAppModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.share,
              size: 48,
              color: Colors.green[600],
            ),
            const SizedBox(height: 16),
            const Text(
              'Compartilhar App',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Compartilhe o NUDGE com seus amigos!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(
                  context,
                  icon: Icons.share,
                  label: 'Compartilhar',
                  onTap: () async {
                    await Share.share(
                      'Baixe o app NUDGE e comece sua jornada fitness! 🏋️‍♀️',
                      subject: 'NUDGE - App de Fitness',
                    );
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),
                _buildShareOption(
                  context,
                  icon: Icons.link,
                  label: 'Copiar Link',
                  onTap: () async {
                    // Link real do app (quando estiver na Play Store)
                    const appLink = 'https://play.google.com/store/apps/details?id=com.nudge.app';
                    await Clipboard.setData(const ClipboardData(text: appLink));
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Link copiado para a área de transferência!')),
                      );
                    }
                  },
                ),
                _buildShareOption(
                  context,
                  icon: Icons.qr_code,
                  label: 'QR Code',
                  onTap: () {
                    // TODO: Show QR code
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('QR Code - Em breve!')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: Colors.green[600],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

