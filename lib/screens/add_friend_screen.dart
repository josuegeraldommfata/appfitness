import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  final List<Map<String, dynamic>> _mockUsers = [
    {
      'id': '4',
      'name': 'Ana Oliveira',
      'email': 'ana@email.com',
      'photoUrl': null,
    },
    {
      'id': '5',
      'name': 'Carlos Pereira',
      'email': 'carlos@email.com',
      'photoUrl': null,
    },
    {
      'id': '6',
      'name': 'Beatriz Lima',
      'email': 'bia@email.com',
      'photoUrl': null,
    },
    {
      'id': '7',
      'name': 'Roberto Santos',
      'email': 'roberto@email.com',
      'photoUrl': null,
    },
  ];

  void _searchUsers(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Simulate API call
    Future.delayed(const Duration(milliseconds: 500), () {
      final results = _mockUsers.where((user) =>
          user['name'].toLowerCase().contains(query.toLowerCase()) ||
          user['email'].toLowerCase().contains(query.toLowerCase())).toList();

      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    });
  }

  void _sendFriendRequest(Map<String, dynamic> user) {
    // TODO: Implement friend request
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pedido de amizade enviado para ${user['name']}!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Amigo'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por nome ou email...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _searchUsers,
            ),
          ),

          // Search Results
          Expanded(
            child: _isSearching
                ? const Center(child: CircularProgressIndicator())
                : _searchResults.isEmpty && _searchController.text.isNotEmpty
                    ? const Center(
                        child: Text('Nenhum usuário encontrado'),
                      )
                    : ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final user = _searchResults[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.green[100],
                                child: Text(
                                  user['name'][0].toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.green[800],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(user['name']),
                              subtitle: Text(user['email']),
                              trailing: ElevatedButton(
                                onPressed: () => _sendFriendRequest(user),
                                child: const Text('Adicionar'),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
