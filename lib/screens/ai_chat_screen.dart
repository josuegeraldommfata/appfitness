import 'package:flutter/material.dart';
import '../services/ai_service.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<AIResponse> _messages = [];
  final AIService _aiService = AIService();
  bool _isLoading = false;

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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Text(
                    message.content,
                    style: TextStyle(
                      color: message.isUser ? Colors.blue : Colors.black,
                      fontWeight: message.isUser ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    message.isUser ? 'Você' : 'Assistente IA',
                    style: TextStyle(
                      color: message.isUser ? Colors.blue[300] : Colors.grey,
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading) const CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Pergunte sobre fitness, dieta ou exercícios...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    final userMessage = AIResponse(content: _controller.text, isUser: true);
    _messages.add(userMessage);
    _controller.clear();
    setState(() => _isLoading = true);

    final aiResponse = await _aiService.getResponse(userMessage.content);
    if (aiResponse != null) {
      _messages.add(aiResponse);
    } else {
      _messages.add(AIResponse(content: 'Desculpe, erro ao gerar resposta.', isUser: false));
    }

    setState(() => _isLoading = false);
  }
}
