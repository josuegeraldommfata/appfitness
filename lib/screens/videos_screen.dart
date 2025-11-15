import 'package:flutter/material.dart';

class VideosScreen extends StatelessWidget {
  const VideosScreen({super.key});

  final List<Map<String, String>> _mockVideos = const [
    {
      'title': 'Como montar uma dieta saudável',
      'description': 'Aprenda os princípios básicos de uma alimentação balanceada',
      'duration': '15:30',
      'thumbnail': 'assets/video1.jpg',
    },
    {
      'title': 'Exercícios para emagrecer',
      'description': 'Rotina completa de exercícios para perda de peso',
      'duration': '25:45',
      'thumbnail': 'assets/video2.jpg',
    },
    {
      'title': 'Receitas fit rápidas',
      'description': 'Prepare refeições saudáveis em menos de 30 minutos',
      'duration': '12:20',
      'thumbnail': 'assets/video3.jpg',
    },
    {
      'title': 'Como controlar a ansiedade alimentar',
      'description': 'Dicas práticas para uma relação saudável com a comida',
      'duration': '18:10',
      'thumbnail': 'assets/video4.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vídeos e Tutoriais'),
        backgroundColor: Colors.green[600],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _mockVideos.length,
        itemBuilder: (context, index) {
          final video = _mockVideos[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Reproduzindo: ${video['title']}')),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.play_circle_fill,
                        color: Colors.green,
                        size: 40,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            video['title']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            video['description']!,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            video['duration']!,
                            style: TextStyle(
                              color: Colors.green[600],
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
          );
        },
      ),
    );
  }
}
