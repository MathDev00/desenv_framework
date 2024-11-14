// views/form_funcionario_page.dart

import 'package:flutter/material.dart';
import 'package:revitalize_mobile/controllers/funcionario.dart';
import 'package:revitalize_mobile/models/funcionario.dart';
import 'package:revitalize_mobile/models/ocupacao.dart';
import 'package:revitalize_mobile/models/cidade.dart';
import 'package:revitalize_mobile/widgets/app_bar.dart';

class FormFuncionarioPage extends StatefulWidget {
  final Funcionario? funcionario; // Adicionando o campo para receber o funcionario

  const FormFuncionarioPage({super.key, this.funcionario});

  @override
  _FormFuncionarioPageState createState() => _FormFuncionarioPageState();
}

class _FormFuncionarioPageState extends State<FormFuncionarioPage> {
  final FuncionarioController _controller = FuncionarioController();

  String nome = '';
  String? ocupacaoId;
  String? genero;
  String cpf = '';
  String email = '';
  String endereco = '';
  String? cidadeId;
  String cep = '';
  String senha = '';
  String dataNascimento = '';
  List<Ocupacao> ocupacaoItems = [];
  List<Cidade> cidadeItems = [];
  List<String> generoItems = ['Masculino', 'Feminino', 'Outro'];

  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadOcupacoesECidades();

    // Se o formulário for de edição, preenche os campos com os dados existentes
    if (widget.funcionario != null) {
      final funcionario = widget.funcionario!;
      nome = funcionario.nome;
      ocupacaoId = funcionario.ocupacao;
      genero = funcionario.genero;
      cpf = funcionario.cpf!;
      email = funcionario.email;
      endereco = funcionario.endereco!;
      cidadeId = funcionario.cidade;
      cep = funcionario.cep!;
      dataNascimento = funcionario.dataNascimento!;

      // Setando a data de nascimento
      _dateController.text = dataNascimento;
    }
  }

  Future<void> _loadOcupacoesECidades() async {
    ocupacaoItems = await _controller.fetchOcupacoes();
    cidadeItems = await _controller.fetchCidades();
    setState(() {});
  }

  Future<void> _saveFuncionario() async {
    final funcionario = Funcionario(
      id: widget.funcionario?.id ?? '', // Se tiver id, é edição, senão é cadastro
      nome: nome,
      ocupacao: ocupacaoId ?? '',
      genero: genero ?? '',
      cpf: cpf,
      email: email,
      endereco: endereco,
      cidade: cidadeId ?? '',
      cep: cep,
      senha: senha,
      dataNascimento: dataNascimento,
    );

      await _controller.saveFuncionario(funcionario); // Cadastro
    
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _dateController.text = picked.toString().split(" ")[0];
        dataNascimento = _dateController.text;
      });
    }
  }

  Widget buildTextField(String label, Function(String) onChanged, {bool obscureText = false}) {
    return TextField(
      onChanged: onChanged,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget buildDropdownField<T>(
      String label, T? value, List<T> items, Function(T?) onChanged, String Function(T) getItemLabel) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(getItemLabel(item)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Cadastro Funcionário"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Icon(Icons.person, size: 60)),
              SizedBox(height: 20),

              buildTextField('Nome', (text) => nome = text),
              SizedBox(height: 20),

              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Data de Nascimento',
                  filled: true,
                  prefixIcon: Icon(Icons.calendar_today),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                ),
                readOnly: true,
                onTap: _selectDate,
              ),
              SizedBox(height: 10),

              // Dropdown para ocupação
              buildDropdownField<Ocupacao>(
                  'Ocupação',
                  ocupacaoItems.firstWhere(
                    (item) => item.id == ocupacaoId,
                    orElse: () => ocupacaoItems.isNotEmpty ? ocupacaoItems.first : ocupacaoItems[0]
                  ),
                  ocupacaoItems,
                  (newValue) => setState(() => ocupacaoId = newValue?.id),
                  (Ocupacao ocupacao) => ocupacao.nome),
              SizedBox(height: 10),

              buildDropdownField<String>(
                  'Gênero',
                  genero,
                  generoItems,
                  (newValue) => setState(() => genero = newValue),
                  (String genero) => genero),
              SizedBox(height: 10),

              buildTextField('CPF', (text) => cpf = text),
              SizedBox(height: 10),

              buildTextField('E-mail', (text) => email = text),
              SizedBox(height: 10),

              buildTextField('Endereço', (text) => endereco = text),
              SizedBox(height: 10),

              // Dropdown para cidade
              buildDropdownField<Cidade>(
                  'Cidade',
                  cidadeItems.firstWhere(
                    (item) => item.id == cidadeId,
                    orElse: () => cidadeItems.isNotEmpty ? cidadeItems.first : cidadeItems[0]
                  ),
                  cidadeItems,
                  (newValue) => setState(() => cidadeId = newValue?.id),
                  (Cidade cidade) => cidade.nome),
              SizedBox(height: 10),

              buildTextField('CEP', (text) => cep = text),
              SizedBox(height: 10),

              buildTextField('Senha', (text) => senha = text, obscureText: true),
              SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  onPressed: _saveFuncionario,
                  child: const Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
