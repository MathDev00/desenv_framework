import 'package:flutter/material.dart';
import 'package:revitalize_mobile/controllers/prontuario.dart';
import 'package:revitalize_mobile/models/campo_adicional.dart';
import 'package:revitalize_mobile/models/prontuario.dart';
import 'package:revitalize_mobile/widgets/app_bar.dart';
import 'package:revitalize_mobile/widgets/custom_pront.dart';

class ProntuarioDetalhadoPage extends StatefulWidget {
  final Prontuario prontuario;

  // ignore: use_super_parameters
  const ProntuarioDetalhadoPage({Key? key, required this.prontuario}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProntuarioDetalhadoPageState createState() => _ProntuarioDetalhadoPageState();
}

class _ProntuarioDetalhadoPageState extends State<ProntuarioDetalhadoPage> {
  final ProntuarioController _controller = ProntuarioController();
  late Future<List<CampoAdicional>> _camposAdicionais;

  @override
  void initState() {
    super.initState();
    // Buscar campos adicionais com base no prontuário
    _camposAdicionais = _controller.fetchCamposAdicionais(widget.prontuario.id);
  }

  @override
  Widget build(BuildContext context) {

   // ignore: unused_local_variable



    return Scaffold(
      appBar: CustomAppBar(title: "Detalhes do Prontuário"),
      body: FutureBuilder<List<CampoAdicional>>(
        future: _camposAdicionais,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum campo adicional encontrado.'));
          }

          List<CampoAdicional> camposAdicionais = snapshot.data!;
          String createdAtString = widget.prontuario.toString();


          return SingleChildScrollView(


            child: Column(
              children: [
                CustomPront(
                  nomeCampo: [
                    'Id',
                    'Paciente',
                    'Profissional',
                    'Data',
                    'Conteúdo',
                  ],
                  dados: [
                    widget.prontuario.id,
                    widget.prontuario.pacienteNome,
                    widget.prontuario.profissionalNome,
                    widget.prontuario.createdAt.toString(),
                    widget.prontuario.textoProntuario,
                  ],
                ),
                // Exibindo campos adicionais
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Campos Adicionais:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ...camposAdicionais.map((campo) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('Campo: ${campo.valor}'),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
