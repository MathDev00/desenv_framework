import 'package:flutter/material.dart';
import 'package:book/controllers/resenha.dart';
import 'package:book/models/resenha.dart';
import 'package:book/widgets/app_bar.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class FormResenhaPage extends StatefulWidget {
  const FormResenhaPage({Key? key}) : super(key: key);

  @override
  State<FormResenhaPage> createState() => _FormResenhaPageState();
}

class _FormResenhaPageState extends State<FormResenhaPage> {
  final _formKey = GlobalKey<FormState>();
  final _comentarioController = TextEditingController();
  String? _livroIdSelecionado;
  final ResenhaController _resenhaController = ResenhaController();

  List<ParseObject> _livros = [];

  @override
  void initState() {
    super.initState();
    _carregarLivros();
  }

  Future<void> _carregarLivros() async {
    final livros = await _resenhaController.fetchLivros();
    setState(() {
      _livros = livros;
    });
  }

  Future<void> _salvarResenha() async {
    if (_formKey.currentState!.validate() && _livroIdSelecionado != null) {
      final resenha = Resenha(
        id: '', 
        livroId: _livroIdSelecionado!,
        comentario: _comentarioController.text,
        createdAt: DateTime.now(),

      );

      try {
        await _resenhaController.cadastrarResenha(resenha);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resenha salva com sucesso!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar resenha: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Nova Resenha"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _livros.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Livro'),
                      value: _livroIdSelecionado,
                      items: _livros.map((livro) {
                        return DropdownMenuItem<String>(
                          value: livro.objectId,
                          child: Text(livro.get<String>('nome') ?? 'Sem título'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _livroIdSelecionado = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Selecione um livro' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _comentarioController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Comentário',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Digite um comentário';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _salvarResenha,
                      child: const Text('Salvar Resenha'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
