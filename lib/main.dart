import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pokepedia_firebase_setup/screens/login_screen.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Pokepedia());
}

class Pokepedia extends StatelessWidget {
  const Pokepedia({super.key});

  @override
  Widget build(BuildContext context) {
   
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}