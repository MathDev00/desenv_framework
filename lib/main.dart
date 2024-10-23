import 'package:flutter/material.dart';
import 'package:revitalize_mobile/pages/login_page.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';


// Widget -> componentres (classes) (tela) -> recebe filhos
// StatelessWidget -> Nada se altera (estado)
// Container -> global, Text -> local
// Statefull permite alterar a visualização durante o app
// setState() -> modifica o estado, fruto do statefull
// Material App -> estilização
// Container() - > Parecido com a div
// Multi render (design sobre outros renders) e single render ->
// ChangeNotifier - > apenas regra de negócio!!

void main() async {

 runApp(const AppWideget());
 
 const keyApplicationId = '9EFKCAxEBXXDQ8XY6Itu5opkksqQQLecwgngOZl7';
  const keyClientKey = 'u1oZ9MXK0choNhZIwjonc6MzTIiSXcvTQiCZgter';
  const keyParseServerUrl = 'https://parseapi.back4app.com';

   await Parse().initialize(keyApplicationId, keyParseServerUrl,
       clientKey: keyClientKey, autoSendSessionId: true);

  var firstObject = ParseObject('FirstClass')
    ..set(
        'message', 'Hey, Parse is now connected!🙂');
  await firstObject.save();

Future<void> saveTodo(String nome_ocupacao) async {
  final todo = ParseObject('ocupacao')
    ..set('nome_ocupacao', nome_ocupacao)
    ..set('done', false);

  await todo.save();
}

saveTodo("TESTE");


 
}

// StatelessWidget -> É estático!

class AppWideget extends StatelessWidget {
  const AppWideget({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
      //routes:  ,
    );
  }
}
