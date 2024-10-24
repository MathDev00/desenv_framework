// views/form_funcionario_page.dart

import 'package:flutter/material.dart';
import 'package:revitalize_mobile/controllers/funcionario.dart';
import 'package:revitalize_mobile/models/funcionario.dart';
import 'package:revitalize_mobile/models/ocupacao.dart';
import 'package:revitalize_mobile/models/cidade.dart';
import 'package:revitalize_mobile/widgets/app_bar.dart';

class FormFuncionarioPage extends StatefulWidget {
  const FormFuncionarioPage({super.key});

  @override
  _FormFuncionarioPageState createState() => _FormFuncionarioPageState();
}

class _FormFuncionarioPageState extends State<FormFuncionarioPage> {
  final FuncionarioController _controller = FuncionarioController();

  // Variáveis de estado para os campos do formulário
  String nome = '';
  String? ocupacaoId; // Armazena apenas o ID da ocupação
  String? genero;
  String cpf = '';
  String email = '';
  String endereco = '';
  String? cidadeId; // Armazena apenas o ID da cidade
  String cep = '';
  String senha = '';
  String dataNascimento = '';
  List<Ocupacao> ocupacaoItems = []; // Lista de Ocupações
  List<Cidade> cidadeItems = []; // Lista de Cidades
  List<String> generoItems = ['Masculino', 'Feminino', 'Outro'];

  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadOcupacoesECidades(); // Carregar ocupações e cidades ao inicializar
  }

  // Método para carregar ocupações e cidades
  Future<void> _loadOcupacoesECidades() async {
    ocupacaoItems = await _controller.fetchOcupacoes();
    cidadeItems = await _controller.fetchCidades();
    setState(() {}); // Atualizar a UI quando os dados forem carregados
  }

  // Método para salvar o funcionário usando o controller
  Future<void> _saveFuncionario() async {
    final funcionario = Funcionario(
      nome: nome,
      ocupacao: ocupacaoId ?? '', // usa o ID da ocupação
      genero: genero ?? '',
      cpf: cpf,
      email: email,
      endereco: endereco,
      cidade: cidadeId ?? '', // usa o ID da cidade
      cep: cep,
      senha: senha,
      dataNascimento: dataNascimento,
    );

    await _controller.saveFuncionario(funcionario);
  }

  // Método para selecionar a data de nascimento
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

  // Métodos auxiliares para criar campos de formulário
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
