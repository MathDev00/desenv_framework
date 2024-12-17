import 'package:flutter/material.dart';
import 'package:revitalize_mobile/controllers/funcionario.dart';
import 'package:revitalize_mobile/models/funcionario.dart';
import 'package:revitalize_mobile/models/ocupacao.dart';
import 'package:revitalize_mobile/models/cidade.dart';
import 'package:revitalize_mobile/pages/funcionario_page.dart';
import 'package:revitalize_mobile/widgets/app_bar.dart';

class FormFuncionarioPage extends StatefulWidget {
  final Funcionario? funcionario;

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

      _dateController.text = dataNascimento;
    }
  }

  Future<void> _loadOcupacoesECidades() async {
    ocupacaoItems = await _controller.fetchOcupacoes();
    cidadeItems = await _controller.fetchCidades();
    setState(() {});
  }

  bool _isCPFValid(String cpf) {
    final RegExp cpfRegex = RegExp(r'^\d{11}$');
    return cpfRegex.hasMatch(cpf);
  }

  Future<void> _saveFuncionario() async {
    if (!_isCPFValid(cpf)) {
      _showErrorMessage('CPF inválido. Insira apenas números e um CPF válido.');
      return;
    }

    try {
      final funcionario = Funcionario(
        id: widget.funcionario?.id ?? '',
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

      await _controller.saveFuncionario(funcionario);

      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const FuncionarioPageState()),
      );
    } catch (e, stackTrace) {
      String errorMessage;

      if (e.toString().contains('Account already exists for this username')) {
        errorMessage =
            'Erro: Já existe uma conta registrada com este e-mail ou CPF.';
      } else if (e
          .toString()
          .contains('não foi possível obter o objectId do usuário')) {
        errorMessage =
            'Erro: Não foi possível concluir o registro do funcionário.';
      } else {
        errorMessage = 'Erro desconhecido: $e';
      }

      _showErrorMessage(errorMessage);
      _handleError(e, stackTrace, 'Erro ao salvar funcionário');
    }
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

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _handleError(Object e, StackTrace stackTrace, String contextMessage) {
    debugPrint('$contextMessage: $e\n$stackTrace');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('$contextMessage. Consulte o console para mais detalhes.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget buildTextField(String label, Function(String) onChanged,
      {bool obscureText = false}) {
    return TextField(
      onChanged: onChanged,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget buildPasswordField() {
    return Row(
      children: [
        Expanded(
          child: buildTextField(
            'Senha',
            (text) => senha = text,
            obscureText: true,
          ),
        ),
        IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Requisitos de Senha'),
                  content: Text(
                    'A senha deve conter:\n\n'
                    '- Pelo menos 8 caracteres\n'
                    '- Letras maiúsculas e minúsculas\n'
                    '- Pelo menos 1 número\n'
                    '- Pelo menos 1 caractere especial (@, #, !, etc.).',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Entendi'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget buildDropdownField<T>(String label, T? value, List<T> items,
      Function(T?) onChanged, String Function(T) getItemLabel) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      items: items.isNotEmpty
          ? items.map((T item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(getItemLabel(item)),
              );
            }).toList()
          : [],
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
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                readOnly: true,
                onTap: _selectDate,
              ),
              SizedBox(height: 10),
              buildDropdownField<Ocupacao>(
                'Ocupação',
                ocupacaoItems.isNotEmpty && ocupacaoId != null
                    ? ocupacaoItems.firstWhere(
                        (item) => item.id == ocupacaoId,
                        orElse: () => ocupacaoItems[0],
                      )
                    : null,
                ocupacaoItems,
                (newValue) => setState(() => ocupacaoId = newValue?.id),
                (Ocupacao ocupacao) => ocupacao.nome,
              ),
              SizedBox(height: 10),
              buildDropdownField<String>(
                'Gênero',
                genero,
                generoItems,
                (newValue) => setState(() => genero = newValue),
                (String genero) => genero,
              ),
              SizedBox(height: 10),
              buildTextField('CPF', (text) => cpf = text),
              SizedBox(height: 10),
              buildTextField('E-mail', (text) => email = text),
              SizedBox(height: 10),
              buildTextField('Endereço', (text) => endereco = text),
              SizedBox(height: 10),
              buildDropdownField<Cidade>(
                'Cidade',
                cidadeItems.isNotEmpty && cidadeId != null
                    ? cidadeItems.firstWhere(
                        (item) => item.id == cidadeId,
                        orElse: () => cidadeItems[0],
                      )
                    : null,
                cidadeItems,
                (newValue) => setState(() => cidadeId = newValue?.id),
                (Cidade cidade) => cidade.nome,
              ),
              SizedBox(height: 10),
              buildTextField('CEP', (text) => cep = text),
              SizedBox(height: 10),
              buildPasswordField(),
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
