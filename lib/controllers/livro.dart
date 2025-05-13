import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:book/models/livro.dart';

class LivroController {
  Future<void> saveLivro(Livro livro) async { //uso da função com Future (lembrar)

    final livroObject = ParseObject('livro') //facilidade das funções parse
      ..set('nome', livro.nome)
      ..set('autor', livro.autor)
      ..set('editor', livro.editor)
      ..set('quant_pag', livro.quant_pag)
      ..set('genero', livro.genero);

    if (livro.id.isNotEmpty) {
      livroObject.objectId = livro.id;
    }

    final response = await livroObject.save();

    if (response.success) {
      print('Livro salvo ou atualizado com sucesso!');
    } else {
      print('Erro ao salvar ou atualizar livro: ${response.error?.message}');
    }
  }

  Future<List<Livro>> getLivros() async {
    List<Livro> livros = [];
    QueryBuilder<ParseObject> queryLivro = QueryBuilder<ParseObject>(ParseObject('livro'));

    final ParseResponse apiResponse = await queryLivro.query();

    if (apiResponse.success && apiResponse.results != null) {
      livros = (apiResponse.results as List<ParseObject>)
          .map((item) => Livro.fromParse(item))
          .toList();
    }

    return livros;
  }

  Future<void> deleteLivro(String id) async {
    final livro = ParseObject('livro')..objectId = id;
    final response = await livro.delete();

    if (response.success) {
      print('Livro deletado com sucesso!');
    } else {
      print('Erro ao deletar livro: ${response.error?.message}');
    }
  }
}
