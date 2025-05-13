import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Livro {
  String  id;
  String  nome;
  String  autor;
  String  editor;
  String  quant_pag;
  String  genero;

  Livro({
    required this.id,
    required this.nome,
    required this.autor,
    required this.editor,
    required this.quant_pag,
    required this.genero,
  });

  factory Livro.fromParse(ParseObject object) {
    return Livro(
      id: object.objectId!,
      nome: object.get<String>('nome') ?? '',
      autor: object.get<String>('autor') ?? '',
      editor: object.get<String>('editor') ?? '',
      quant_pag: object.get<String>('quant_pag') ?? '',
      genero: object.get<String>('genero') ?? '',

    );
  }
}
