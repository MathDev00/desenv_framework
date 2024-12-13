import 'package:flutter/material.dart';
import 'package:revitalize_mobile/pages/tela_inicial.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function? onBack; // Função de callback para recarregar dados

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          if (onBack != null) {
            onBack!(); // Chama a função de recarregar dados
          }
          Navigator.of(context).pop(); // Voltar para a tela anterior
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MyHomePage()),
              (Route<dynamic> route) => false, // Remove todas as rotas anteriores
            );
          },
        ),
      ],
      backgroundColor: const Color(0xFF0E37BB),
      elevation: 2,
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  @override
  Size get preferredSize {
    return const Size.fromHeight(kToolbarHeight);
  }
}
