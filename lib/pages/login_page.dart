import 'package:flutter/material.dart';
import 'package:revitalize_mobile/pages/tela_inicial.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:revitalize_mobile/testes/home_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  __LoginPageState createState() => __LoginPageState();
}

class __LoginPageState extends State<LoginPage> {
  String email = '';
  String password = '';
  bool isLoggedIn = false;


  @override
  void initState() {
    super.initState();
  }

     void showSuccess(String message) {
     showDialog(
       context: context,
       builder: (BuildContext context) {
         return AlertDialog(
           title: const Text("Success!"),
           content: Text(message),
           actions: <Widget>[
             new TextButton(
               child: const Text("OK"),
               onPressed: () {
                 Navigator.of(context).pop();
               },
             ),
           ],
         );
       },
     );
   }

void showError(String errorMessage) {
     showDialog(
       context: context,
       builder: (BuildContext context) {
         return AlertDialog(
           title: const Text("Error!"),
           content: Text(errorMessage),
           actions: <Widget>[
             new TextButton(
               child: const Text("OK"),
               onPressed: () {
                 Navigator.of(context).pop();
               },
             ),
           ],
         );
       },
     );
   }


 void login(String email, String password) async {

      final user = ParseUser(email, password, null);
 
       var response = await user.login();

      if (response.success) {
      showSuccess("User was successfully login!");
          
          Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const MyHomePage()));

        setState(() {
          isLoggedIn = true;
          
        });

         

      } else {
        showError(response.error!.message);
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
                  onPressed: ()  {
                    login(email, password);
  
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
