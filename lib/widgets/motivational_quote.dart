import 'package:flutter/material.dart';
import 'dart:math';

class MotivationalQuote extends StatefulWidget {
  const MotivationalQuote({super.key});

  @override
  State<MotivationalQuote> createState() => _MotivationalQuoteState();
}

class _MotivationalQuoteState extends State<MotivationalQuote> {
  final List<String> _quotes = [
    "Cada passo conta na sua jornada para uma vida mais saudável!",
    "Você é mais forte do que pensa. Continue!",
    "Pequenas mudanças levam a grandes resultados.",
    "Sua saúde é seu maior patrimônio. Cuide bem dela!",
    "Hoje é o dia perfeito para começar algo novo!",
    "Cada refeição é uma oportunidade de nutrir seu corpo.",
    "Beba água, seu corpo agradece!",
    "Movimento é vida. Mantenha-se ativo!",
    "Você merece se sentir bem. Continue assim!",
    "Cada dia é uma nova chance de ser melhor.",
  ];

  late String _currentQuote;

  @override
  void initState() {
    super.initState();
    _currentQuote = _getRandomQuote();
  }

  String _getRandomQuote() {
    final random = Random();
    return _quotes[random.nextInt(_quotes.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green[200]!, width: 1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: Colors.green[600],
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _currentQuote,
              style: TextStyle(
                color: Colors.green[800],
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _currentQuote = _getRandomQuote();
              });
            },
            icon: Icon(
              Icons.refresh,
              color: Colors.green[600],
              size: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
