import 'package:flutter/material.dart';
import 'package:revitalize_mobile/pages/form_paciente.dart';
import 'package:revitalize_mobile/widgets/app_bar.dart';
import 'package:revitalize_mobile/widgets/custom_table.dart';
import 'package:revitalize_mobile/controllers/paciente.dart'; 
import 'package:revitalize_mobile/models/paciente.dart';
import 'package:revitalize_mobile/widgets/custom_text.dart'; 

void main() => runApp(const PacientePage());

class PacientePage extends StatefulWidget {
  const PacientePage({super.key});

  @override
  _PacientePageState createState() => _PacientePageState();
}

class _PacientePageState extends State<PacientePage> {
  List<Paciente> pacientes = [];

  final PacienteController _pacienteController = PacienteController();

  void _fetchPacientes() async {
    List<Paciente> pacientesFromServer = await _pacienteController.getPacientes();
    setState(() {
      pacientes = pacientesFromServer; 
    });
  }

  void _deletePaciente(String id, int index) async {
    await _pacienteController.deletePaciente(id);
    setState(() {
      pacientes.removeAt(index); 
    });
  }

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
  void initState() {
    super.initState();
    _fetchPacientes(); 
  }

  @override
  Widget build(BuildContext context) {
    List<String> nomeCampo = [
      'Id',
      'Paciente',
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
              return Column(
                children: [
                  IconButton(
                    onPressed: _addPaciente,
                    icon: const Icon(Icons.add),
                    tooltip: 'Adicionar',
                  ),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: List.generate(pacientes.length, (index) {
                      return CustomTextWidget(
                        titulo: nomeCampo,
                        dados: [
                          pacientes[index].id,
                          pacientes[index].nome,
                          pacientes[index].dataNascimento,
                          pacientes[index].email,
                          pacientes[index].endereco,
                          pacientes[index].cidade,
                          pacientes[index].cep,
                        ],
                        onDelete: () => _deletePaciente(pacientes[index].id, index),
                        onEdit: () => _deletePaciente(pacientes[index].id, index), 
                      );
                    }),
                  ),
                ],
              );
            } else {
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
                      dados: [
                        pacientes[index].id,
                        pacientes[index].nome,
                        pacientes[index].dataNascimento,
                        pacientes[index].email,
                        pacientes[index].endereco,
                        pacientes[index].cidade,
                        pacientes[index].cep,
                      ],
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
