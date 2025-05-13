import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Resenha {
  final String id;
  final String livroId;
  final String comentario;
  final DateTime createdAt;

  Resenha({
    required this.id,
    required this.livroId,
    required this.comentario,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'livroId': livroId,
      'comentario': comentario,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Resenha.fromParse(ParseObject parseObject) {
    final livro = parseObject.get<ParseObject>('livro_id');
    final livroId = livro?.objectId ?? '';

    final comentario = parseObject.get<String>('comentario') ?? '';
    final createdAt = parseObject.createdAt ?? DateTime.now();

    return Resenha(
      id: parseObject.objectId!,
      livroId: livroId,
      comentario: comentario,
      createdAt: createdAt,
    );
  }
}
