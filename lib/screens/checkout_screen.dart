import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/plan.dart';
import '../models/subscription.dart';
import '../providers/subscription_provider.dart';
import '../services/payment_service.dart';
import '../services/api_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/payment_config.dart';

class CheckoutScreen extends StatefulWidget {
  final Plan plan;
  final BillingPeriod billingPeriod;
  final String? source; // 'herbalife' ou 'admin'

  const CheckoutScreen({
    super.key,
    required this.plan,
    required this.billingPeriod,
    this.source,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  PaymentProvider _selectedProvider = PaymentProvider.stripe;
  bool _isProcessing = false;

  // Stripe fields
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvcController = TextEditingController();
  final _cardNameController = TextEditingController();

  // Mercado Pago
  String? _pixQrCode;
  String? _pixCopyPaste;
  String? _preferenceId;

  @override
  void initState() {
    super.initState();
    _loadMercadoPagoPix();
  }

  Future<void> _loadMercadoPagoPix() async {
    if (_selectedProvider == PaymentProvider.mercadoPago) {
      await _createMercadoPagoPixPayment();
    }
  }

  Future<void> _createMercadoPagoPixPayment() async {
    setState(() => _isProcessing = true);
    
    try {
      final apiService = ApiService();
      final user = apiService.currentUser;
      if (user == null) {
        _showError('Usuário não autenticado');
        return;
      }

      final paymentService = PaymentService();
      final amount = paymentService.getPlanAmount(widget.plan, widget.billingPeriod);

      // Create PIX payment directly
      final response = await http.post(
        Uri.parse('${PaymentConfig.backendApiUrl}/api/mercado-pago/create-pix-payment'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'amount': amount,
          'userId': user.id,
          'planType': widget.plan.type.name,
          'billingPeriod': widget.billingPeriod.name,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _preferenceId = data['paymentId'];
          _pixQrCode = data['pixQrCode'];
          _pixCopyPaste = data['pixCopyPaste'];
        });
      } else {
        final errorData = jsonDecode(response.body);
        _showError(errorData['error'] ?? 'Erro ao criar pagamento PIX');
      }
    } catch (e) {
      _showError('Erro: $e');
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _processStripePayment() async {
    if (!_validateStripeFields()) return;

    setState(() => _isProcessing = true);

    try {
      final apiService = ApiService();
      final user = apiService.currentUser;
      if (user == null) {
        _showError('Usuário não autenticado');
        return;
      }

      final paymentService = PaymentService();
      final amount = paymentService.getPlanAmount(widget.plan, widget.billingPeriod);

      // Criar payment intent
      final paymentIntent = await paymentService.createStripePaymentIntent(
        amount: amount,
        currency: 'BRL',
        userId: user.id,
        planType: widget.plan.type,
        billingPeriod: widget.billingPeriod,
      );

      if (paymentIntent == null) {
        _showError('Erro ao criar pagamento');
        return;
      }

      // Processar pagamento com cartão via backend
      final response = await http.post(
        Uri.parse('${PaymentConfig.backendApiUrl}/api/stripe/process-payment'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'paymentIntentId': paymentIntent['paymentIntentId'],
          'clientSecret': paymentIntent['clientSecret'],
          'cardNumber': _cardNumberController.text.replaceAll(' ', ''),
          'expiryDate': _expiryController.text,
          'cvc': _cvcController.text,
          'cardName': _cardNameController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          // Criar assinatura usando SubscriptionProvider
          final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);
          await subscriptionProvider.subscribeToPlan(
            widget.plan.type,
            widget.billingPeriod,
            PaymentProvider.stripe,
            context,
          );
          
          if (mounted) {
            Navigator.pop(context);
            // Success message já é mostrado pelo SubscriptionProvider
          }
        } else {
          _showError(data['error'] ?? 'Erro ao processar pagamento');
        }
      } else {
        final errorData = jsonDecode(response.body);
        _showError(errorData['error'] ?? 'Erro ao processar pagamento');
      }
    } catch (e) {
      _showError('Erro: $e');
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _processMercadoPagoPayment() async {
    if (_pixCopyPaste == null || _preferenceId == null) {
      _showError('Aguardando dados do PIX...');
      return;
    }

    setState(() => _isProcessing = true);

    try {
      // Para PIX, criamos a assinatura com status pendente
      // O backend verifica o pagamento via webhook e atualiza o status
      final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);
      
      // Criar assinatura pendente
      await subscriptionProvider.subscribeToPlan(
        widget.plan.type,
        widget.billingPeriod,
        PaymentProvider.mercadoPago,
        context,
      );
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Após o pagamento via PIX, sua assinatura será ativada automaticamente!'),
            duration: Duration(seconds: 5),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e) {
      _showError('Erro: $e');
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  bool _validateStripeFields() {
    if (_cardNumberController.text.isEmpty ||
        _expiryController.text.isEmpty ||
        _cvcController.text.isEmpty ||
        _cardNameController.text.isEmpty) {
      _showError('Preencha todos os campos do cartão');
      return false;
    }
    return true;
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    _cardNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final amount = PaymentService().getPlanAmount(widget.plan, widget.billingPeriod);
    final period = widget.billingPeriod == BillingPeriod.monthly ? 'mês' : 'ano';

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const Text('FitLife Coach'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plan Info
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
                    Text(
                      widget.plan.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.plan.description,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Valor',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          'R\$ ${amount.toStringAsFixed(2)}/$period',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Payment Provider Selection
            const Text(
              'Escolha a forma de pagamento',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildPaymentOption(
                    'Stripe',
                    Icons.credit_card,
                    PaymentProvider.stripe,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPaymentOption(
                    'Mercado Pago',
                    Icons.qr_code,
                    PaymentProvider.mercadoPago,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Payment Form
            if (_selectedProvider == PaymentProvider.stripe)
              _buildStripeForm()
            else
              _buildMercadoPagoForm(),

            const SizedBox(height: 24),

            // Process Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessing
                    ? null
                    : (_selectedProvider == PaymentProvider.stripe
                        ? _processStripePayment
                        : _processMercadoPagoPayment),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isProcessing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        _selectedProvider == PaymentProvider.stripe
                            ? 'Pagar com Cartão'
                            : 'Confirmar Pagamento PIX',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String label, IconData icon, PaymentProvider provider) {
    final isSelected = _selectedProvider == provider;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedProvider = provider;
          if (provider == PaymentProvider.mercadoPago) {
            _loadMercadoPagoPix();
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.blue[600]! : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? Colors.blue[600] : Colors.grey[600],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.blue[600] : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStripeForm() {
    return Card(
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
              'Dados do Cartão',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cardNumberController,
              decoration: InputDecoration(
                labelText: 'Número do Cartão',
                hintText: '1234 5678 9012 3456',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(19),
                CardNumberFormatter(),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _expiryController,
                    decoration: InputDecoration(
                      labelText: 'Validade (MM/AA)',
                      hintText: '12/25',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                      ExpiryDateFormatter(),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _cvcController,
                    decoration: InputDecoration(
                      labelText: 'CVC',
                      hintText: '123',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cardNameController,
              decoration: InputDecoration(
                labelText: 'Nome no Cartão',
                hintText: 'JOÃO SILVA',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              textCapitalization: TextCapitalization.characters,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMercadoPagoForm() {
    return Card(
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
              'Pagamento via PIX',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (_isProcessing)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (_pixQrCode != null && _pixCopyPaste != null) ...[
              // QR Code
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: QrImageView(
                    data: _pixQrCode!,
                    version: QrVersions.auto,
                    size: 200,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Copy Paste Code
              const Text(
                'Código PIX (Copiar e Colar)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
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
                        _pixCopyPaste!,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: _pixCopyPaste!));
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Código PIX copiado!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Após o pagamento via PIX, sua assinatura será ativada automaticamente em até 2 minutos.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ] else
              const Center(
                child: Text('Carregando dados do PIX...'),
              ),
          ],
        ),
      ),
    );
  }
}

// Formatters
class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;
    
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(text[i]);
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;
    if (text.length == 2 && !text.contains('/')) {
      return TextEditingValue(
        text: '$text/',
        selection: TextSelection.collapsed(offset: 3),
      );
    }
    return newValue;
  }
}

