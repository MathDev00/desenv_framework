import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:revitalize_mobile/models/funcionario.dart';
import 'package:revitalize_mobile/models/ocupacao.dart';
import 'package:revitalize_mobile/models/cidade.dart';

class FuncionarioController {
  Future<List<Ocupacao>> fetchOcupacoes() async {
    List<Ocupacao> ocupacaoItems = [];
    QueryBuilder<ParseObject> queryOcupacao =
        QueryBuilder<ParseObject>(ParseObject('ocupacao'));

    final ParseResponse apiResponse = await queryOcupacao.query();

    if (apiResponse.success && apiResponse.results != null) {
      ocupacaoItems = (apiResponse.results as List<ParseObject>)
          .map((item) => Ocupacao(
                id: item.objectId!,
                nome: item.get<String>('nome_ocupacao') ?? '',
              ))
          .where((ocupacao) => ocupacao.nome.isNotEmpty)
          .toList();
    }

    return ocupacaoItems;
  }

  Future<List<Cidade>> fetchCidades() async {
    List<Cidade> cidadeItems = [];
    QueryBuilder<ParseObject> queryCidade =
        QueryBuilder<ParseObject>(ParseObject('cidade'));

    final ParseResponse apiResponse = await queryCidade.query();

    if (apiResponse.success && apiResponse.results != null) {
      cidadeItems = (apiResponse.results as List<ParseObject>)
          .map((item) => Cidade(
                id: item.objectId!,
                nome: item.get<String>('cidade_nome') ?? '',
              ))
          .where((cidade) => cidade.nome.isNotEmpty)
          .toList();
    }

    return cidadeItems;
  }

  Future<void> saveFuncionario(Funcionario funcionario) async {
    // Função para criar o usuário ParseUser
    Future<String?> doUserRegistration(String email, String senha) async {
      final user = ParseUser.createUser(email, senha, email);
      final response = await user.signUp();

      if (response.success) {
        return user.objectId;
      } else {
        print("Erro no registro do usuário: ${response.error?.message}");
        return null;
      }
    }

    // Realiza o registro do usuário e captura o objectId
    final lastId = await doUserRegistration(funcionario.email, funcionario.senha);
    if (lastId == null) {
      print("Erro: não foi possível obter o objectId do usuário.");
      return;
    }

    // Criar objeto Funcionario e salvar com referência ao usuario_id
    final funcionarioObject = ParseObject('funcionario')
      ..set('nome', funcionario.nome)
      ..set('ocupacao_id', ParseObject('ocupacao')..objectId = funcionario.ocupacao) // Pointer para ocupacao
      ..set('genero', funcionario.genero)
      ..set('cpf', funcionario.cpf)
      ..set('email', funcionario.email)
      ..set('endereco', funcionario.endereco)
      ..set('cidade_id', ParseObject('cidade')..objectId = funcionario.cidade) // Pointer para cidade
      ..set('cep', funcionario.cep)
      ..set('data_nascimento', funcionario.dataNascimento)
      ..set('usuario_id', ParseObject('_User')..objectId = lastId); // Pointer para usuário

  print('Ocupacao ID: ${funcionario.ocupacao}');

    final response = await funcionarioObject.save();

    if (!response.success) {
      print('Erro ao salvar funcionário: ${response.error?.message}');
    } else {
      print('Funcionário salvo com sucesso!');
    }
  }
}
