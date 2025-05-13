import 'package:book/pages/tela_inicial.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

void main() async {
  runApp(const AppWideget());

  const keyApplicationId = 'OGB9f6Gkvftw9u36ehGG9Hu0volq8lFgyZqEmuz1';
  const keyClientKey = 'UaW0KfW2fYV5KbndNVA9zsjCWrSZWwhzqYgo3wwJ';
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);

}

class AppWideget extends StatelessWidget {
  const AppWideget({super.key});

    //poderia ter melhorado com as rotas
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}
