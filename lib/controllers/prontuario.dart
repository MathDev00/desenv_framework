import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:revitalize_mobile/models/funcionario.dart';
import 'package:revitalize_mobile/models/paciente.dart';

class ProntuarioController {
  Future<List<Paciente>> fetchPacientes() async {
    List<Paciente> pacienteItems = [];
    QueryBuilder<ParseObject> queryPaciente =
        QueryBuilder<ParseObject>(ParseObject('paciente')); // Nome da classe do banco

    final ParseResponse apiResponse = await queryPaciente.query();

    if (apiResponse.success && apiResponse.results != null) {
      pacienteItems = (apiResponse.results as List<ParseObject>)
          .map((item) => Paciente.fromParse(item))
          .toList();
    }

    return pacienteItems;
  }

  Future<List<Funcionario>> fetchFuncionarios() async {
    List<Funcionario> funcionarioItems = [];
    QueryBuilder<ParseObject> queryFuncionario =
        QueryBuilder<ParseObject>(ParseObject('funcionario')); // Nome da classe do banco

    final ParseResponse apiResponse = await queryFuncionario.query();

    if (apiResponse.success && apiResponse.results != null) {
      funcionarioItems = (apiResponse.results as List<ParseObject>)
          .map((item) => Funcionario.fromParse(item))
          .toList();
    }

    return funcionarioItems;
  }
}
