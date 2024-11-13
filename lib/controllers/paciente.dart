import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:revitalize_mobile/models/paciente.dart';

class PacienteController {
  // Função para salvar um paciente
 Future<void> savePaciente(Paciente paciente) async {
    final pacienteObject = ParseObject('paciente')
      ..set('nome', paciente.nome)
      ..set('genero', paciente.genero)
      ..set('cpf', paciente.cpf)
      ..set('email', paciente.email)
      ..set('endereco', paciente.endereco)
      ..set('cidade', paciente.cidade)
      ..set('cep', paciente.cep)
      ..set('senha', paciente.senha)
      ..set('data_nascimento', paciente.dataNascimento);

    final response = await pacienteObject.save();
    if (response.success) {
      print('Paciente salvo com sucesso!');
    } else {
      print('Erro ao salvar paciente: ${response.error?.message}');
    }
  }
}

  // Função para buscar todos os pacientes
  Future<List<Paciente>> fetchPacientes() async {
    List<Paciente> pacienteItems = [];
    QueryBuilder<ParseObject> queryPaciente = QueryBuilder<ParseObject>(ParseObject('paciente'));

    final ParseResponse apiResponse = await queryPaciente.query();
    if (apiResponse.success && apiResponse.results != null) {
      pacienteItems = (apiResponse.results as List<ParseObject>)
          .map((item) => Paciente.fromParse(item))
          .toList();
    }

    return pacienteItems;
  }

