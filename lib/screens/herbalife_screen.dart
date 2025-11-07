import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/app_provider.dart';

class HerbalifeScreen extends StatefulWidget {
  const HerbalifeScreen({super.key});

  @override
  State<HerbalifeScreen> createState() => _HerbalifeScreenState();
}

class _HerbalifeScreenState extends State<HerbalifeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _sponsorIdController = TextEditingController();
  final _sponsorLettersController = TextEditingController();
  bool _isHerbalifeClient = false;

  @override
  void initState() {
    super.initState();
    // Load current settings if any
    _loadHerbalifeSettings();
  }

  void _loadHerbalifeSettings() {
    // Mock loading - in real app, load from Firestore or local storage
    setState(() {
      _isHerbalifeClient = false; // Load from provider or storage
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Herbalife'),
        backgroundColor: Colors.green[600],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.business, size: 32, color: Colors.green[600]),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Cliente/Consultor Herbalife',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Acesse descontos exclusivos, materiais de apoio e vincule-se ao nosso time de acompanhamento.',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Toggle
            Card(
              elevation: 2,
              child: SwitchListTile(
                title: const Text('Sou cliente/consultor Herbalife'),
                subtitle: const Text('Ative para acessar recursos exclusivos'),
                value: _isHerbalifeClient,
                onChanged: (value) {
                  setState(() {
                    _isHerbalifeClient = value;
                  });
                  // Save to provider/storage
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(value ? 'Recursos Herbalife ativados!' : 'Recursos Herbalife desativados')),
                  );
                },
                activeColor: Colors.green[600],
              ),
            ),

            if (_isHerbalifeClient) ...[
              const SizedBox(height: 24),

              // Account Creation
              Text(
                'Criar Conta de Descontos',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Clique no link abaixo para criar sua conta de descontos e presentes exclusivos.',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () async {
                            const url = 'https://accounts.myherbalife.com/account/create';
                            try {
                              await launchUrl(Uri.parse(url));
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Erro ao abrir link')),
                              );
                            }
                          },
                          icon: const Icon(Icons.link),
                          label: const Text('Link de Cadastro Oficial'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            foregroundColor: Colors.white,
                            minimumSize: Size(double.infinity, 48),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Team Linkage
              Text(
                'Vincular ao Time',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Para vincular ao nosso time de acompanhamento, preencha:',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _sponsorIdController,
                          decoration: const InputDecoration(
                            labelText: 'Sponsor\'s Herbalife ID Number',
                            hintText: 'Digite o ID do upline',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Campo obrigatório';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _sponsorLettersController,
                          decoration: const InputDecoration(
                            labelText: '3 primeiras letras do sobrenome do upline',
                            hintText: 'Ex: SIL (para Silva)',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Campo obrigatório';
                            }
                            if (value!.length != 3) {
                              return 'Digite exatamente 3 letras';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              // Save to Firestore or provider
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Dados salvos com sucesso!')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            foregroundColor: Colors.white,
                            minimumSize: Size(double.infinity, 48),
                          ),
                          child: const Text('Salvar e Vincular'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Support
              Text(
                'Suporte',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Precisa de ajuda? Entre em contato com nosso suporte:',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: Icon(Icons.email, color: Colors.green[600]),
                        title: const Text('suporte@herbalife.com.br'),
                        subtitle: const Text('Email de suporte'),
                        onTap: () async {
                          const email = 'suporte@herbalife.com.br';
                          final url = 'mailto:$email?subject=Suporte Herbalife';
                          try {
                            await launchUrl(Uri.parse(url));
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Erro ao abrir email')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Materials
              Text(
                'Materiais de Apoio',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Acesse materiais que ajudam no desenvolvimento de textos e estratégias:',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () async {
                          const url = 'https://clienteherbalife.com.br';
                          try {
                            await launchUrl(Uri.parse(url));
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Erro ao abrir link')),
                            );
                          }
                        },
                        icon: const Icon(Icons.web),
                        label: const Text('clienteherbalife.com.br'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 48),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _sponsorIdController.dispose();
    _sponsorLettersController.dispose();
    super.dispose();
  }
}
