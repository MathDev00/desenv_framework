import 'package:flutter/material.dart';
import 'package:book/controllers/resenha.dart';
import 'package:book/models/resenha.dart';
import 'package:book/widgets/app_bar.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class EditarResenhaPage extends StatefulWidget {
  final Resenha resenha;

  const EditarResenhaPage({super.key, required this.resenha});

  @override
  _EditarResenhaPageState createState() => _EditarResenhaPageState();
}

class _EditarResenhaPageState extends State<EditarResenhaPage> {
  final ResenhaController _controller = ResenhaController();
  
  TextEditingController _comentarioController = TextEditingController();
  String? _livroIdSelecionado;
  List<ParseObject> _livros = [];

  @override
  void initState() {
    super.initState();
    _carregarLivros();
    _comentarioController.text = widget.resenha.comentario;
    _livroIdSelecionado = widget.resenha.livroId;
  }

  Future<void> _carregarLivros() async {
    final livros = await _controller.fetchLivros();
    setState(() {
      _livros = livros;
    });
  }

  Future<void> _salvarResenha() async {
    if (_livroIdSelecionado != null) {
      final resenhaAtualizada = Resenha(
        id: widget.resenha.id,
        livroId: _livroIdSelecionado!,
        comentario: _comentarioController.text,
        createdAt: widget.resenha.createdAt, 
      );

      try {
        await _controller.atualizarResenha(resenhaAtualizada);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resenha atualizada com sucesso!')),
        );
        Navigator.pop(context, resenhaAtualizada);  
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
      appBar: const CustomAppBar(title: "Editar Resenha"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _livros.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
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
                    child: const Text('Salvar Alterações'),
                  ),
                ],
              ),
      ),
    );
  }
}
