import 'package:flutter/material.dart';
import 'package:revitalize_mobile/controllers/funcionario.dart';
import 'package:revitalize_mobile/models/funcionario.dart';
import 'package:revitalize_mobile/models/ocupacao.dart';
import 'package:revitalize_mobile/models/cidade.dart';
import 'package:revitalize_mobile/widgets/app_bar.dart';

class FormEditFuncionarioPage extends StatefulWidget {
  final Funcionario? funcionario;

  const FormEditFuncionarioPage({Key? key, this.funcionario}) : super(key: key);

  @override
  _FormEditFuncionarioPageState createState() => _FormEditFuncionarioPageState();
}

class _FormEditFuncionarioPageState extends State<FormEditFuncionarioPage> {
  late TextEditingController nomeController;
  late TextEditingController cpfController;
  late TextEditingController emailController;
  late TextEditingController enderecoController;
  late TextEditingController cepController;
  late TextEditingController dataNascimentoController;
  String ocupacaoId = '';
  String cidadeId = '';
  String genero = 'Masculino';

  List<Ocupacao> ocupacaoItems = [];
  List<Cidade> cidadeItems = [];
  final FuncionarioController _controller = FuncionarioController();

  @override
  void initState() {
    super.initState();

    // Inicializa os controladores
    nomeController = TextEditingController();
    cpfController = TextEditingController();
    emailController = TextEditingController();
    enderecoController = TextEditingController();
    cepController = TextEditingController();
    dataNascimentoController = TextEditingController();

    if (widget.funcionario != null) {
      final funcionario = widget.funcionario!;
      nomeController.text = funcionario.nome ?? '';
      cpfController.text = funcionario.cpf ?? '';
      emailController.text = funcionario.email ?? '';
      enderecoController.text = funcionario.endereco ?? '';
      cepController.text = funcionario.cep ?? '';
      dataNascimentoController.text = funcionario.dataNascimento ?? '';
      ocupacaoId = funcionario.ocupacao ?? '';
      genero = funcionario.genero ?? '';
      cidadeId = funcionario.cidade ?? '';
    }
    _loadOcupacoesECidades();
  }

  Future<void> _loadOcupacoesECidades() async {
    try {
      ocupacaoItems = await _controller.fetchOcupacoes();
      cidadeItems = await _controller.fetchCidades();
      setState(() {});
    } catch (e) {
      print("Erro ao carregar ocupações e cidades: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Editar Funcionário"),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
               Center(child: Icon(Icons.person, size: 60)),
              SizedBox(height: 20),

              buildTextField('Nome', nomeController),
              buildTextField('CPF', cpfController),
              buildTextField('Email', emailController),
              buildTextField('Endereço', enderecoController),
              buildTextField('CEP', cepController),
              buildTextField(
                'Data de Nascimento',
                dataNascimentoController,
                readOnly: true,
              ),
              const SizedBox(height: 16.0),
              buildDropdownField<Ocupacao>(
                'Ocupação',
                ocupacaoItems.isNotEmpty
                    ? ocupacaoItems.firstWhere(
                        (e) => e.id == ocupacaoId,
                        orElse: () => ocupacaoItems.first,
                      )
                    : null, 
                ocupacaoItems,
                (value) {
                  setState(() {
                    ocupacaoId = value?.id ?? ''; 
                  });
                },
                (e) => e.nome,
              ),
              const SizedBox(height: 16.0),
              buildDropdownField<String>(
                'Gênero',
                genero,
                ['Masculino', 'Feminino', 'Outro'],
                (value) {
                  setState(() {
                    genero = value!;
                  });
                },
                (value) => value,
              ),
              const SizedBox(height: 16.0),
              buildDropdownField<Cidade>(
                'Cidade',
                cidadeItems.isNotEmpty
                    ? cidadeItems.firstWhere(
                        (e) => e.id == cidadeId,
                        orElse: () => cidadeItems.first,
                      )
                    : null, 
                cidadeItems,
                (value) {
                  setState(() {
                    cidadeId = value?.id ?? ''; 
                  });
                },
                (e) => e.nome,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  final funcionario = Funcionario(
                    id: widget.funcionario?.id ?? '',
                    nome: nomeController.text,
                    ocupacao: ocupacaoId,
                    genero: genero,
                    cpf: cpfController.text,
                    email: emailController.text,
                    endereco: enderecoController.text,
                    cidade: cidadeId,
                    cep: cepController.text,
                    senha: '',
                    dataNascimento: dataNascimentoController.text,
                  );

                  _controller.saveFuncionario(funcionario);
                },
                child: const Text('Salvar Alterações'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildDropdownField<T>(
    String label,
    T? value,
    List<T> items,
    Function(T?) onChanged,
    String Function(T) getItemLabel,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<T>(
        value: value,
        items: items.map((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(getItemLabel(item)),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            onChanged(newValue);
          });
        },
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
