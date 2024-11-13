import 'package:flutter/material.dart';
import 'package:revitalize_mobile/pages/form_paciente.dart';
import 'package:revitalize_mobile/testes/home_page.dart';
import 'package:revitalize_mobile/widgets/app_bar.dart';
import 'package:revitalize_mobile/widgets/custom_table.dart';
//import 'package:revitalize_mobile/widgets/custom_text_widget.dart';

void main() => runApp(const PacientePage());

class PacientePage extends StatefulWidget {
  const PacientePage({super.key});

  @override
  _PacientePageState createState() => _PacientePageState();
}

class _PacientePageState extends State<PacientePage> {
  // Lista de pacientes para exibição
  List<Map<String, String>> pacientes = [
    {
      'Id': '1',
      'Paciente': 'João',
      'Gênero': 'Masculino',
      'Data Nascimento': '01-01-2024',
      'E-mail': 'joao@gmail.com',
      'Endereço': 'Rua 09 s/n',
      'Cidade': 'Ceres',
      'CEP': '76300'
    },
    {
      'Id': '2',
      'Paciente': 'Maria',
      'Gênero': 'Feminino',
      'Data Nascimento': '02-02-2023',
      'E-mail': 'maria@gmail.com',
      'Endereço': 'Rua 10 nº 16',
      'Cidade': 'Anápolis',
      'CEP': '75000'
    },
  ];

  // Função para deletar um paciente
  void _deletePaciente(int index) {
    setState(() {
      pacientes.removeAt(index);
    });
  }

  // Função para adicionar um novo paciente
  void _addPaciente() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const FormPacientePage(),
      ),
    ).then((newPaciente) {
      if (newPaciente != null) {
        setState(() {
          pacientes.add(newPaciente);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> nomeCampo = [
      'Id',
      'Paciente',
      'Gênero',
      'Data Nascimento',
      'E-mail',
      'Endereço',
      'Cidade',
      'CEP',
    ];

    return Scaffold(
      appBar: CustomAppBar(title: "Pacientes"),
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth >= 600) {
              // Layout para web
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  Center(
                    child: IconButton(
                      onPressed: _addPaciente,
                      icon: const Icon(Icons.add),
                      tooltip: 'Adicionar',
                    ),
                  ),
                  ...List.generate(pacientes.length, (index) {
                    return CustomTextWidget(
                      titulo: nomeCampo,
                      dados: pacientes[index].values.toList(),
                      onDelete: () => _deletePaciente(index), // Deletar paciente
                    );
                  }),
                ],
              );
            } else {
              // Layout para Android/iOS
              return Column(
                children: [
                  IconButton(
                    onPressed: _addPaciente,
                    icon: const Icon(Icons.add),
                    tooltip: 'Adicionar',
                  ),
                  SizedBox(height: 8),
                  ...List.generate(pacientes.length, (index) {
                    return CustomTable(
                      quantidadeCampo: '8',
                      nomeCampo: nomeCampo,
                      dados: pacientes[index].values.toList(),
                    );
                  }),
                  SizedBox(height: 8),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}



class CustomTextWidget extends StatelessWidget {
  final List<String> titulo;
  final List<String> dados;
  final VoidCallback onDelete; // Callback para deletar

  // ignore: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
  CustomTextWidget({required this.titulo, required this.dados, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0), // Top spacing
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(150, 173, 216, 230),
          borderRadius: BorderRadius.circular(12.0), // Circular border radius
          border: Border.all(
            color: const Color.fromARGB(150, 173, 216, 230),
            width: 2.0, // Border width
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align items to the start
            children: [
              ...List.generate(titulo.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: RichText(
                    text: TextSpan(
                      text: '${titulo[index]}: ',
                      style: TextStyle(
                        fontSize: 18.0, // Font size for titulo
                        fontWeight: FontWeight.bold, // Font weight for titulo
                        color: Colors.grey, // Text color for titulo
                      ),
                      children: [
                        TextSpan(
                          text: dados[index],
                          style: TextStyle(
                            fontSize: 16.0, // Font size for dados
                            fontWeight: FontWeight.bold, // Font weight for dados
                            color: Colors.black, // Text color for dados
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              // Botão de Editar
              Row(
                mainAxisAlignment: MainAxisAlignment.end, // Colocar os botões no final
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => HomePage(
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.pageview_outlined),
                    tooltip: 'Editar',
                  ),
                  // Botão de Deletar
                  IconButton(
                    onPressed: onDelete, // Chama o callback para deleção
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Excluir',
                    color: Colors.red, // Cor vermelha para indicar deleção
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
