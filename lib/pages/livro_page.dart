import 'package:flutter/material.dart';
import 'package:book/forms/form_edit_livro.dart';
import 'package:book/forms/form_livro.dart';
import 'package:book/widgets/app_bar.dart';
import 'package:book/widgets/book_card.dart';
import 'package:book/controllers/livro.dart';
import 'package:book/models/livro.dart';

/*void main() => runApp(const LivroPage());*/

class LivroPage extends StatefulWidget {
  //se fosse junto, deveria estar sempre carragando tudo.
  // deve separar
  const LivroPage({super.key});

  @override
  _LivroPageState createState() => _LivroPageState();
}

class _LivroPageState extends State<LivroPage> {
  late Future<List<Livro>> _livrosFuture;
  final LivroController _livroController = LivroController();

  @override
  void initState() {
    super.initState();
    _carregarLivros();
  }

  void _carregarLivros() => setState(() {
        _livrosFuture = _livroController.getLivros();
      });

  Future<void> _abrirPagina(Widget pagina) async {
    final atualizado = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => pagina),
    );
    if (atualizado != null) _carregarLivros();
  }

  void _adicionarLivro() => 
  _abrirPagina(const FormLivroPage());

  void _editarLivro(Livro livro) => 
  _abrirPagina(EditarLivroPage(livro: livro));

  void _removerLivro(String id) async {
    await _livroController.deleteLivro(id);


    _carregarLivros();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Livros"),
      body: FutureBuilder<List<Livro>>(
        future: _livrosFuture,
        builder: (context, snapshot) {
          final livros = snapshot.data;

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
                child: Text('Erro ao carregar livros: ${snapshot.error}'));
          }

          if (livros == null || livros.isEmpty) {
            return const Center(child: Text('Nenhum livro encontrado.'));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: _adicionarLivro,
                    icon: const Icon(Icons.add),
                    label: const Text('Adicionar Novo Livro'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 24),
                      backgroundColor: Colors.deepPurpleAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: livros
                      .map((livro) => BookCard(
                            livro: livro,
                            onEdit: () => _editarLivro(livro),
                            onDelete: () => _removerLivro(livro.id),
                          ))
                      .toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
