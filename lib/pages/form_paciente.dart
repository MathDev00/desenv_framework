import 'package:flutter/material.dart';
import 'package:revitalize_mobile/controllers/funcionario.dart'; // Controller to fetch cities
import 'package:revitalize_mobile/widgets/app_bar.dart'; // Custom AppBar Widget
import 'package:revitalize_mobile/models/cidade.dart'; // Cidade model

class FormPacientePage extends StatefulWidget {
  const FormPacientePage({super.key});

  @override
  _FormPacientePageState createState() => _FormPacientePageState();
}

class _FormPacientePageState extends State<FormPacientePage> {
  final FuncionarioController _funcionarioController = FuncionarioController();

  String nome = '';
  String ocupacao = ''; // Occupation (not used here yet)
  String genero = ''; // Gender
  String cpf = '';
  String email = '';
  String endereco = '';
  Cidade? cidade; // Store selected city as a Cidade object
  String cep = '';
  String senha = '';
  String dataNascimento = '';

  final List<String> generoItems = ['Masculino', 'Feminino', 'Outro'];
  List<Cidade> cidadeItems = []; // Dynamically fetched cities

  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCidades(); // Load cities when the page initializes
  }

  // Fetch cities from the backend via the FuncionarioController
  Future<void> _loadCidades() async {
    List<Cidade> cidades = await _funcionarioController.fetchCidades();
    setState(() {
      cidadeItems = cidades;
    });
  }

  // Method to handle date selection
  Future<void> selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _dateController.text = picked.toString().split(" ")[0];
        dataNascimento = _dateController.text;
      });
    }
  }

  // Build text input fields with dynamic value updates
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

  // Build dropdown fields
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
      appBar: const CustomAppBar(title: "Cadastro Paciente"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Icon(Icons.person, size: 60)),
              SizedBox(height: 20),

              // Text field for "Nome"
              buildTextField('Nome', (text) => nome = text),
              SizedBox(height: 20),

              // Date picker for "Data de Nascimento"
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
                onTap: selectDate,
              ),
              SizedBox(height: 10),

              // Gender Dropdown
              buildDropdownField<String>(
                'Gênero',
                genero.isEmpty ? null : genero,
                generoItems,
                (newValue) => setState(() => genero = newValue!),
                (String genero) => genero,
              ),
              SizedBox(height: 10),

              // Text field for "CPF"
              buildTextField('CPF', (text) => cpf = text),
              SizedBox(height: 10),

              // Text field for "E-mail"
              buildTextField('E-mail', (text) => email = text),
              SizedBox(height: 10),

              // Text field for "Endereço"
              buildTextField('Endereço', (text) => endereco = text),
              SizedBox(height: 10),

              // City Dropdown - Dynamic data loading
              cidadeItems.isEmpty
                  ? CircularProgressIndicator()
                  : buildDropdownField<Cidade>(
                      'Cidade',
                      cidade,
                      cidadeItems,
                      (newValue) => setState(() => cidade = newValue),
                      (Cidade cidade) => cidade.nome,
                    ),
              SizedBox(height: 10),

              // Text field for "CEP"
              buildTextField('CEP', (text) => cep = text),
              SizedBox(height: 20),

              // Submit button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle form submission here
                    print("Nome: $nome, CPF: $cpf, E-mail: $email, Cidade: ${cidade?.nome}");
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
