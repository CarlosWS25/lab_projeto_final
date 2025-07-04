// lib/screens/screen_profileadmin.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:dosewise/veri_device.dart';

class AdminUsersScreen extends StatefulWidget {
  final int currentUserId;
  const AdminUsersScreen({Key? key, required this.currentUserId}) : super(key: key);

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  bool loading = true;
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() => loading = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? prefs.getString('auth_token');
    if (token == null) {
      Navigator.pop(context);
      return;
    }

    final uri = await makeApiUri('/users');
    final resp = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (resp.statusCode == 200) {
      final rawList = (jsonDecode(resp.body)['utilizadores'] as List<dynamic>);
      setState(() {
        users = rawList.map((row) {
          return {
            'id': row[1] as int,
            'username': row[2] as String,
          };
        }).toList();
        loading = false;
      });
    } else {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao carregar (${resp.statusCode})')),
      );
    }
  }

  Future<void> _deleteUser(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? prefs.getString('auth_token');
    if (token == null) return;

    final uri = await makeApiUri('/users/$id');
    final resp = await http.delete(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (resp.statusCode == 200) {
      setState(() => users.removeWhere((u) => u['id'] == id));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Utilizador apagado com sucesso.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao apagar (${resp.statusCode})')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin: Lista de Utilizadores'),
        backgroundColor: colorScheme.primary,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (_, i) {
                final u = users[i];
                final bool isSelf = u['id'] == widget.currentUserId;
                return ListTile(
                  leading: Text(u['id'].toString()),
                  title: Text(u['username']),
                  trailing: isSelf
                      ? const SizedBox(width: 48)
                      : IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () => _deleteUser(u['id'] as int),
                        ),
                );
              },
            ),
    );
  }
}
