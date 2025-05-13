import 'package:flutter/material.dart';
import 'package:book/controllers/livro.dart';
import 'package:book/controllers/resenha.dart';
import 'package:book/forms/form_edit_resenha.dart';
import 'package:book/models/resenha.dart';
import 'package:book/models/livro.dart';
import 'package:book/widgets/app_bar.dart';

class ResenhaPage extends StatefulWidget {
  const ResenhaPage({super.key});

  @override
  _ResenhaPageState createState() => _ResenhaPageState();
}

class _ResenhaPageState extends State<ResenhaPage> {
  late Future<List<Resenha>> _resenhasFuture;
  late Future<List<Livro>> _livrosFuture;
  final ResenhaController _resenhaController = ResenhaController();
  final LivroController _livroController = LivroController();

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() {
    setState(() {
      _resenhasFuture = _resenhaController.fetchResenhas();
      _livrosFuture = _livroController.getLivros();
    });
  }

  Future<void> _editarResenha(Resenha resenha) async {
    final resenhaAtualizada = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarResenhaPage(resenha: resenha),
      ),
    );
    if (resenhaAtualizada != null) _carregarDados();
  }

  Future<void> _deletarResenha(String id) async {
    await _resenhaController.deletarResenha(id);
    _carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Resenhas de Livros"),
      body: FutureBuilder<List<Resenha>>(
        future: _resenhasFuture,
        builder: (context, resenhaSnapshot) {
          if (resenhaSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (resenhaSnapshot.hasError) {
            return Center(child: Text('Erro ao carregar resenhas: ${resenhaSnapshot.error}'));
          }

          final resenhas = resenhaSnapshot.data ?? [];
          if (resenhas.isEmpty) {
            return const Center(child: Text('Nenhuma resenha encontrada.'));
          }

          return FutureBuilder<List<Livro>>(
            future: _livrosFuture,
            builder: (context, livroSnapshot) {
              if (livroSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (livroSnapshot.hasError) {
                return Center(child: Text('Erro ao carregar livros: ${livroSnapshot.error}'));
              }

              final livros = livroSnapshot.data ?? [];

              return ListView.builder(
                itemCount: resenhas.length,
                itemBuilder: (context, index) {
                  final resenha = resenhas[index];
                  final livroNome = livros.firstWhere(
                    (livro) => livro.id == resenha.livroId,
                  ).nome;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      elevation: 15,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 50,
                              height: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.orange[200],
                              ),
                              child: const Icon(Icons.book, size: 40, color: Colors.white),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    livroNome,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      color: Colors.deepPurple[700],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    resenha.comentario,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Data: ${resenha.createdAt.toLocal()}',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _editarResenha(resenha),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deletarResenha(resenha.id),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
