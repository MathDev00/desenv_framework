// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:revitalize_mobile/pages/form_funcionario.dart';
import 'package:revitalize_mobile/testes/home_page.dart';
import 'package:revitalize_mobile/widgets/custom_table.dart';
import 'package:revitalize_mobile/widgets/app_bar.dart';
import 'package:revitalize_mobile/controllers/funcionario.dart';
import 'package:revitalize_mobile/models/funcionario.dart';


class FuncionarioPageState extends StatefulWidget {
  const FuncionarioPageState({super.key});

  @override
  _FuncionarioPageState createState() => _FuncionarioPageState();
}

class _FuncionarioPageState extends State<FuncionarioPageState> {
  final FuncionarioController _controller = FuncionarioController();
  List<Funcionario> _funcionarios = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFuncionarios();
  }

  Future<void> _loadFuncionarios() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final funcionarios = await _controller.fetchFuncionarios();
      setState(() {
        _funcionarios = funcionarios;
      });
    } catch (e) {
      print("Erro ao buscar funcionários: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

 void _deleteFuncionario(int index) async {
  try {
    final funcionarioId = _funcionarios[index].id;

    await _controller.deleteFuncionario(funcionarioId);

    setState(() {
      _funcionarios.removeAt(index);
    });
  } catch (e) {
    print("Erro ao excluir funcionário: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Erro ao excluir funcionário: $e")),
    );
  }
}

void _editFuncionario(Funcionario funcionario) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => FormFuncionarioPage(funcionario: funcionario), // Passando o funcionario para edição
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    List<String> nomeCampo = ['Id', 'Nome', 'Ocupação', 'Gênero'];

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Funcionários"),
      body: Container(
        color: Colors.white, 
        child: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth >= 600) {
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    Center(
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const FormFuncionarioPage()),
                          );
                        },
                        icon: const Icon(Icons.add),
                        tooltip: 'Adicionar',
                      ),
                    ),
                    ..._funcionarios.map((funcionario) => CustomTextWidget(
                          titulo: nomeCampo,
                          dados: [
                            funcionario.id,
                            funcionario.nome,
                            funcionario.ocupacao,
                            funcionario.genero,
                            funcionario.email,                            
                          ],
                          onDelete: () {
                            _deleteFuncionario(_funcionarios.indexOf(funcionario)); 
                          },
                          onEdit: () {
                            _editFuncionario(funcionario); 
  },
                        )),
                  ],
                );
              } else {
                return Column(
                  children: [
                    Center(
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const FormFuncionarioPage()),
                          );
                        },
                        icon: const Icon(Icons.add),
                        tooltip: 'Adicionar',
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._funcionarios.map((funcionario) => CustomTable(
                          quantidadeCampo: '4',
                          nomeCampo: nomeCampo,
                          dados: [
                            funcionario.id,
                            funcionario.nome,
                            funcionario.ocupacao,
                            funcionario.genero,
                          ],
                        )),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}


class CustomTextWidget extends StatelessWidget {
  final List<String> titulo;
  final List<String> dados;
  final VoidCallback onDelete; 
  final VoidCallback onEdit;   

  // ignore: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
  CustomTextWidget({
    required this.titulo,
    required this.dados,
    required this.onDelete, 
    required this.onEdit,   
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0), // Top spacing
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(150, 173, 216, 230),
          borderRadius: BorderRadius.circular(12.0), 
          border: Border.all(
            color: const Color.fromARGB(150, 173, 216, 230),
            width: 2.0, // Border width
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, 
            children: [
              ...List.generate(titulo.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: RichText(
                    text: TextSpan(
                      text: '${titulo[index]}: ',
                      style: TextStyle(
                        fontSize: 18.0, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.grey, 
                      ),
                      children: [
                        TextSpan(
                          text: dados[index],
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold, 
                            color: Colors.black, 
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              Row(
                mainAxisAlignment: MainAxisAlignment.end, 
                children: [
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit),
                    tooltip: 'Editar',
                  ),
                  IconButton(
                    onPressed: onDelete, 
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Excluir',
                    color: Colors.red, 
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}