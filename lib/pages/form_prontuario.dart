import 'package:flutter/material.dart';
import 'package:revitalize_mobile/models/funcionario.dart';
import 'package:revitalize_mobile/models/paciente.dart';
import 'package:revitalize_mobile/controllers/prontuario.dart';

import 'package:revitalize_mobile/widgets/app_bar.dart';

class FormProntuarioPage extends StatefulWidget {
  const FormProntuarioPage({super.key});

  @override
  __FormProntuarioPageState createState() => __FormProntuarioPageState();
}

class __FormProntuarioPageState extends State<FormProntuarioPage> {
  String? paciente;
  String? profissional;
  String prontuarioTexto = '';

  final List<Paciente> pacientes = [];
  final List<Funcionario> profissionais = [];
  final ProntuarioController _controller = ProntuarioController();
  List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final fetchedPacientes = await _controller.fetchPacientes();
    final fetchedFuncionarios = await _controller.fetchFuncionarios();

    setState(() {
      pacientes.addAll(fetchedPacientes);
      profissionais.addAll(fetchedFuncionarios);
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Cadastro Prontuário"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: Icon(Icons.person, size: 60)),
              const SizedBox(height: 20),

              // Dropdown de Pacientes
              _buildDropdown(
                label: 'Paciente',
                value: paciente,
                items: pacientes.map((p) => p.nome).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    paciente = newValue;
                  });
                },
              ),
              const SizedBox(height: 10),

              // Dropdown de Profissionais
              _buildDropdown(
                label: 'Profissional',
                value: profissional,
                items: profissionais.map((f) => f.nome).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    profissional = newValue;
                  });
                },
              ),
              const SizedBox(height: 10),

              // Campo de Texto do Prontuário
              TextField(
                onChanged: (text) {
                  prontuarioTexto = text;
                },
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Prontuário',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              // Campos de texto dinâmicos adicionados pelo usuário
              Column(
                children: _controllers.map((controller) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: TextField(
                      controller: controller,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Informação Adicional',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  );
                }).toList(),
              ),

              // Botão para Adicionar Campo de Texto
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _controllers.add(TextEditingController());
                    });
                  },
                  child: const Text('Adicionar Campo'),
                ),
              ),
              const SizedBox(height: 10),

              // Botão para Remover o Último Campo de Texto
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_controllers.isNotEmpty) {
                      setState(() {
                        _controllers.removeLast();
                      });
                    }
                  },
                  child: const Text('Remover Último Campo'),
                ),
              ),
              const SizedBox(height: 20),

              // Botão de Cadastrar
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Lógica de cadastro pode ser implementada aqui
                  },
                  child: const Text('Cadastrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget de Dropdown com Label
  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          hint: Text('Selecione um $label'),
          underline: Container(
            height: 1,
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }
}