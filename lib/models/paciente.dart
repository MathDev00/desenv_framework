import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';


class Paciente {
  String nome;
  String genero;
  String cpf;
  String email;
  String endereco;
  String cidade;
  String cep;
  String dataNascimento;

  Paciente({
    required this.nome,
    required this.genero,
    required this.cpf,
    required this.email,
    required this.endereco,
    required this.cidade,
    required this.cep,
    required this.dataNascimento,
  });

  // Método de conversão para criar um Paciente a partir de um ParseObject
  factory Paciente.fromParse(ParseObject object) {
    return Paciente(
      nome: object.get<String>('nome') ?? '',
      genero: object.get<String>('genero') ?? '',
      cpf: object.get<String>('cpf') ?? '',
      email: object.get<String>('email') ?? '',
      endereco: object.get<String>('endereco') ?? '',
      cidade: object.get<String>('cidade') ?? '',
      cep: object.get<String>('cep') ?? '',
      dataNascimento: object.get<String>('dataNascimento') ?? '',
    );
  }
}
