import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/payment_config.dart';

class AIResponse {
  final String content;
  final bool isUser;

  AIResponse({required this.content, required this.isUser});
}

class AIService {
  // Usa o backend para ChatGPT (chave API fica no backend)
  static String get backendUrl => PaymentConfig.backendApiUrl;

  Future<AIResponse?> getResponse(String prompt) async {
    try {
      // Chamar backend que processa ChatGPT
      final response = await http.post(
        Uri.parse('$backendUrl/api/chatgpt/message'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'message': prompt,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['response'] != null) {
          return AIResponse(content: data['response'], isUser: false);
        }
        return null;
      } else {
        print('ChatGPT error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('AI Service error: $e');
      return null;
    }
  }
}
