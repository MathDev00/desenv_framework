import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:book/models/resenha.dart';

class ResenhaController {

  Future<List<Resenha>> fetchResenhas() async {
    List<Resenha> resenhas = [];

    final queryResenha = QueryBuilder<ParseObject>(ParseObject('resenha'))
      ..includeObject(['livro_id']); 

    final apiResponse = await queryResenha.query();

    if (apiResponse.success && apiResponse.results != null) {
      for (var item in apiResponse.results as List<ParseObject>) {
        resenhas.add(Resenha.fromParse(item));
      }
    } else {
      print('Erro ao buscar resenhas: ${apiResponse.error?.message}');
    }

    return resenhas;
  }

  Future<void> cadastrarResenha(Resenha resenha) async {
    final resenhaParse = ParseObject('resenha')
      ..set('livro_id', await _getLivro(resenha.livroId))
      ..set('comentario', resenha.comentario);

    final response = await resenhaParse.save();

    if (!response.success) {
      print('Erro ao cadastrar resenha: ${response.error?.message}');
      throw Exception('Erro ao cadastrar resenha: ${response.error?.message}');
    }
  }

  Future<void> atualizarResenha(Resenha resenha) async {
    final resenhaParse = ParseObject('resenha')..objectId = resenha.id
      ..set('livro_id', await _getLivro(resenha.livroId))
      ..set('comentario', resenha.comentario);

    final response = await resenhaParse.save();

    if (!response.success) {
      print('Erro ao atualizar resenha: ${response.error?.message}');
      throw Exception('Erro ao atualizar resenha: ${response.error?.message}');
    }
  }

  Future<void> deletarResenha(String resenhaId) async {
    final resenhaParse = ParseObject('resenha')..objectId = resenhaId;

    final response = await resenhaParse.delete();

    if (!response.success) {
      print('Erro ao deletar resenha: ${response.error?.message}');
      throw Exception('Erro ao deletar resenha: ${response.error?.message}');
    }
  }

  Future<ParseObject> _getLivro(String livroId) async {
    final query = QueryBuilder<ParseObject>(ParseObject('livro')) //nome do livro
      ..whereEqualTo('objectId', livroId);

    final apiResponse = await query.query();

    if (apiResponse.success && apiResponse.results != null && apiResponse.results!.isNotEmpty) {
      return apiResponse.results!.first as ParseObject;
    } else {
      print('Livro não encontrado: ${apiResponse.error?.message}');
      throw Exception('Livro não encontrado');
    }
  }
  
  Future<List<ParseObject>> fetchLivros() async { //na edição da resenha
    final query = QueryBuilder<ParseObject>(ParseObject('livro'));
    final response = await query.query();

    if (response.success && response.results != null) {
      return response.results as List<ParseObject>;
    } else {
      throw Exception('Erro ao buscar livros');
    }
  }
}
