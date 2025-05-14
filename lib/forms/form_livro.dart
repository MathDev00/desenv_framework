import 'package:flutter/material.dart';
import 'package:book/controllers/livro.dart';
import 'package:book/models/livro.dart';
import 'package:book/pages/tela_inicial.dart';
import 'package:book/widgets/app_bar.dart';

class FormLivroPage extends StatefulWidget {
  final Livro? livro; 
  const FormLivroPage({super.key, this.livro});

  @override
  _FormLivroPageState createState() => _FormLivroPageState();
}

class _FormLivroPageState extends State<FormLivroPage> {
  final LivroController _controller = LivroController();

  String nome = '';
  String autor = '';
  String editor = '';
  String quantPag = '';
  String genero = '';

  @override
  void initState() {
    super.initState();
    if (widget.livro != null) {
      final livro = widget.livro!;
      nome = livro.nome;
      autor = livro.autor;
      editor = livro.editor;
      quantPag = livro.quant_pag;
      genero = livro.genero;
    }
  }

  Future<void> _saveLivro() async {
    final livro = Livro(
      id: widget.livro?.id ?? '', 
      nome: nome,
      autor: autor,
      editor: editor,
      quant_pag: quantPag,
      genero: genero,
    );

    await _controller.saveLivro(livro);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  }

  Widget _campos(String label, Function(String) onChanged) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Cadastro Livro"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Icon(Icons.book, size: 60)),
              SizedBox(height: 20),

              _campos('Nome', (text) => nome = text),
              SizedBox(height: 10),

              _campos('Autor', (text) => autor = text),
              SizedBox(height: 10),

              _campos('Editora', (text) => editor = text),
              SizedBox(height: 10),

              _campos('Quantidade de Páginas', (text) => quantPag = text),
              SizedBox(height: 10),

              _campos('Gênero', (text) => genero = text),
              SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  onPressed: _saveLivro,
                  child: const Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}