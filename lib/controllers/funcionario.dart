
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
  final funcionarioObject = ParseObject('funcionario')
    ..set('nome', funcionario.nome)
    ..set('ocupacao_id', (ParseObject('ocupacao')..objectId = funcionario.ocupacao)) // Atribuindo o Pointer de ocupacao
    ..set('genero', funcionario.genero)
    ..set('cpf', funcionario.cpf)
    ..set('email', funcionario.email)
    ..set('endereco', funcionario.endereco)
    ..set('cidade_id', (ParseObject('cidade')..objectId = funcionario.cidade)) // Atribuindo o Pointer de cidade    ..set('cep', funcionario.cep)
    ..set('senha', funcionario.senha)
    ..set('cep', funcionario.cep)
    ..set('data_nascimento', funcionario.dataNascimento);


    //print('ID da Cidade: ${funcionario.cep}');
    print('ID da Cidade: ${funcionario.dataNascimento}');


  final response = await funcionarioObject.save();

  if (!response.success) {
    print('Error saving funcionario: ${response.error?.message}');
  } else {
    print('Funcionario saved successfully!');
  }
}

}
