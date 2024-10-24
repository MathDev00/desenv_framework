import 'package:flutter/material.dart';
import 'package:revitalize_mobile/pages/tela_inicial.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  __LoginPageState createState() => __LoginPageState();
}

class __LoginPageState extends State<LoginPage> {
  String email = '';
  String password = '';

  @override
  void initState() {
    super.initState();
    initializeParse();
  }

  Future<void> initializeParse() async {
    await Parse().initialize(
      '9EFKCAxEBXXDQ8XY6Itu5opkksqQQLecwgngOZl7',
      'https://parseapi.back4app.com', 
      clientKey: 'u1oZ9MXK0choNhZIwjonc6MzTIiSXcvTQiCZgter', 
      autoSendSessionId: true,
      debug: true, 
    );
  }

  Future<bool> login(String email, String password) async {
    final query = QueryBuilder<ParseObject>(ParseObject('funcionario'))
      ..whereEqualTo('email', email)
      ..whereEqualTo('senha', password);

    final response = await query.query();

    if (response.success && response.results != null && response.results!.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png'),
                TextField(
                  onChanged: (text) {
                    email = text;
                  },
                  decoration: const InputDecoration(
                      labelText: 'Email', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  obscureText: true,
                  onChanged: (text) {
                    password = text;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    // Chama a função login para verificar se o email e senha são válidos
                    bool isSuccess = await login(email, password);
                    if (isSuccess) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MainApp()));
                    } else {
                      // Exibe uma mensagem de erro caso os dados estejam errados
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Email ou senha incorretos!')),
                      );
                    }
                  },
                  child: const Text('Entrar'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
