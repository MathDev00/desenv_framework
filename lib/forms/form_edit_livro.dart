import 'package:flutter/material.dart';
import 'package:book/controllers/livro.dart';
import 'package:book/models/livro.dart';
import 'package:book/widgets/app_bar.dart';

class EditarLivroPage extends StatefulWidget {
  final Livro livro;

  const EditarLivroPage({super.key, required this.livro});

  @override
  _EditarLivroPageState createState() => _EditarLivroPageState();
}


class _EditarLivroPageState extends State<EditarLivroPage> {
  final LivroController _controller = LivroController();

  TextEditingController _nomeController = TextEditingController();
  TextEditingController _autorController = TextEditingController();
  TextEditingController _editorController = TextEditingController();
  TextEditingController _quantPagController = TextEditingController();
  TextEditingController _generoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nomeController.text = widget.livro.nome;
    _autorController.text = widget.livro.autor;
    _editorController.text = widget.livro.editor;
    _quantPagController.text = widget.livro.quant_pag; 
    _generoController.text = widget.livro.genero;
  }

  Future<void> _saveLivro() async {
    int quantPag = int.tryParse(_quantPagController.text) ?? 0;

    final livro = Livro(
      id: widget.livro.id, 
      nome: _nomeController.text,
      autor: _autorController.text,
      editor: _editorController.text,
      quant_pag: quantPag.toString(), 
      genero: _generoController.text,
    );

    await _controller.saveLivro(livro);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Livro atualizado com sucesso!')),
    );
    Navigator.of(context).pop(livro);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Editar Livro"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Center(child: Icon(Icons.book, size: 60)),
              SizedBox(height: 20),
              _campo('Nome', _nomeController),
              _campo('Autor', _autorController),
              _campo('Editora', _editorController),
              _campo('Quantidade de Páginas', _quantPagController, keyboardType: TextInputType.number),
              _campo('Gênero', _generoController),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveLivro,
                child: const Text('Salvar Alterações'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campo(String label, TextEditingController controller, {bool readOnly = false, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
