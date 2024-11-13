import 'package:flutter/material.dart';
import 'package:revitalize_mobile/pages/login_page.dart';
import 'package:revitalize_mobile/pages/funcionario_page.dart';
import 'package:revitalize_mobile/pages/paciente_page.dart';
import 'package:revitalize_mobile/pages/prontuarios_page.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';



  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

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


  void _onFuncionarioPressed () {

  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => const FuncionarioPageState()));

  }


  void _onPacientePressed () {

  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => const PacientePage()));

  }

  void _onProntuariosPressed () {

  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => const ProntuariosPage()));

  }


       void doUserLogout() async {
       final user = await ParseUser.currentUser() as ParseUser;
       var response = await user.logout();
   
       if (response.success) {
         showSuccess("User was successfully logout!");
         setState(() {
           var isLoggedIn = false;
      Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => const LoginPage()));
         });
      } else {
        showError(response.error!.message);
      }
    }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Revitalize",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 28, 5, 82),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          GestureDetector(
            onTap: _onProntuariosPressed, 
            child: Container(
              height: 100,
              width: 300,
              decoration: BoxDecoration(
                color: const Color.fromARGB(150, 173, 216, 230),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              margin: const EdgeInsets.only(bottom: 10), // Ajusta a margem inferior
              child: const Text(
                "Prontuários",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: _onPacientePressed, // Chama a função ao pressionar
            child: Container(
              height: 100,
              width: 300,
              decoration: BoxDecoration(
                color: const Color.fromARGB(150, 173, 216, 230),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              margin: const EdgeInsets.only(bottom: 10),
              child: const Text(
                "Paciente",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: _onFuncionarioPressed,
            child: Container(
              height: 100,
              width: 300,
              decoration: BoxDecoration(
                color: const Color.fromARGB(150, 173, 216, 230),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              margin: const EdgeInsets.only(bottom: 10), // Ajusta a margem inferior
              child: const Text(
                "Funcionário",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {

                doUserLogout();
              
              },
            ),
          ],
        ),
      ),
    );
  }
}
