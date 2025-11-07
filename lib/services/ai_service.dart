import 'dart:convert';
import 'package:http/http.dart' as http;

class AIResponse {
  final String content;
  final bool isUser;

  AIResponse({required this.content, required this.isUser});
}

class AIService {
  static const String apiKey = 'YOUR_OPENAI_API_KEY_HERE'; // Substitua pela sua chave real da OpenAI após clonar o repo
  static const String baseUrl = 'https://api.openai.com/v1/chat/completions';
  static const String model = 'gpt-4o-mini';

  static const String systemPrompt = 'You are a helpful fitness coach for the Nudge app. Provide personalized advice on diet, exercise, water intake, and progress tracking. Keep responses concise, encouraging, and in Portuguese.';

  Future<AIResponse?> getResponse(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': model,
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': prompt},
          ],
          'max_tokens': 300,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        return AIResponse(content: content, isUser: false);
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('AI Service error: $e');
      return null;
    }
  }
}
