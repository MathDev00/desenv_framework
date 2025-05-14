import 'package:flutter/material.dart';
import 'package:book/models/livro.dart';

class BookCard extends StatelessWidget {
  final Livro livro;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BookCard({
    super.key,
    required this.livro,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: 320,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: const DecorationImage(
                    image: AssetImage('assets/img.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      livro.nome,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    Text('Autor: ${livro.autor}'),
                    Text('Editor: ${livro.editor}'),
                    Text('Gênero: ${livro.genero}'),
                    Text('Páginas: ${livro.quant_pag}'),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: onEdit),
                  IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: onDelete),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
