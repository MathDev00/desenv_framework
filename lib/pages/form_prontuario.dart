import 'package:flutter/material.dart';
import 'package:revitalize_mobile/widgets/app_bar.dart';

class FormProntuarioPage extends StatefulWidget {
  const FormProntuarioPage({super.key});

  @override
  __FormProntuarioPageState createState() => __FormProntuarioPageState();
}

class __FormProntuarioPageState extends State<FormProntuarioPage> {
  String paciente = 'Paciente A';
  String profissional = 'Profissional X';
  String privacidade = 'Privado';
  String prontuarioTexto = '';
  
  List<TextEditingController> _controllers = [];

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
              Center(child: Icon(Icons.person, size: 60)),
              SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      value: paciente,
                      isExpanded: true,
                      items: ['Paciente A', 'Paciente B', 'Paciente C']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          paciente = newValue!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      value: profissional,
                      isExpanded: true,
                      items: ['Profissional X', 'Profissional Y', 'Profissional Z']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          profissional = newValue!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      value: privacidade,
                      isExpanded: true,
                      items: ['Privado', 'Publicado'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          privacidade = newValue!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              TextField(
                onChanged: (text) {
                  prontuarioTexto = text;
                },
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Texto do Prontuário',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),

              // Campos de texto dinâmicos
              Column(
                children: _controllers.map((controller) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: TextField(
                      controller: controller,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        labelText: 'Campo Adicional',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  );
                }).toList(),
              ),

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
              SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  onPressed: () {
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
}
