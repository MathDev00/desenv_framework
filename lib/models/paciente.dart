import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Paciente {
  String id;
  String nome;
  String genero;
  String cpf;
  String email;
  String endereco;
  String cidade;
  String cep;
  String senha;
  String dataNascimento;

  Paciente({
    required this.id,
    required this.nome,
    required this.genero,
    required this.cpf,
    required this.email,
    required this.endereco,
    required this.cidade,
    required this.cep,
    required this.senha,
    required this.dataNascimento,
  });

  factory Paciente.fromParse(ParseObject object) {
    return Paciente(
      id: object.objectId!,
      nome: object.get<String>('nome') ?? '',
      genero: object.get<String>('genero') ?? '',
      cpf: object.get<String>('cpf') ?? '',
      email: object.get<String>('email') ?? '',
      endereco: object.get<String>('endereco') ?? '',
      cidade: object.get<String>('cidade') ?? '',
      cep: object.get<String>('cep') ?? '',
      senha: object.get<String>('senha') ?? '',
      dataNascimento: object.get<String>('data_nascimento') ?? '',
    );
  }
}
