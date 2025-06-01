import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:pokepedia_firebase_setup/screens/home_screen.dart';
import 'package:pokepedia_firebase_setup/widgets/button.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
    final  formKey = GlobalKey<FormState>();
  bool showPassword = false;
  bool showConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: SizedBox(
                  height: 250,
                  width: 250,
                  child: Lottie.asset('assets/animations/lottie2.json'),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow[200],
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  "Create a new account",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Name
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter your full name',
                  prefixIcon: const Icon(Icons.person, color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.yellow,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Email
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: const Icon(Icons.email, color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.yellow,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Password
              TextField(
                controller: passwordController,
                obscureText: !showPassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter password',
                  prefixIcon: const Icon(Icons.lock, color: Colors.black),
                  suffixIcon: IconButton(
                    icon: Icon(
                      showPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed:
                        () => setState(() => showPassword = !showPassword),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.yellow,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              LoadingAnimatedButton(
                child: Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow,
                  ),
                ),
                onTap: ()  {
                  print("Pressed Register");
                  registerUser();
                   final form=formKey.currentState!;
                  String email=emailController.text;
                  String password=passwordController.text;
                  print('$email is the email and $password is the password');
                  if(form.validate()){
                    final email=emailController.text;
                    final password=passwordController.text;
                  }else{

                  }
                },
              ),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.yellow[300],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void registerUser() {
    if (passwordController.text == "") {
      Fluttertoast.showToast(
        msg: "Password cannot be blank",
        backgroundColor: Colors.red,
      );
    } else if (emailController.text == "") {
      Fluttertoast.showToast(
        msg: "Email cannot be blank",
        backgroundColor: Colors.red,
      );
    } else if (nameController.text == "") {
      Fluttertoast.showToast(
        msg: "Name cannot be blank",
        backgroundColor: Colors.red,
      );
    } else {
        final email = emailController.text;
    final password = passwordController.text;
    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((value){
      if (value !=null) {
        var user=value.user;
        var uid=user!.uid;
        addUserData(uid);
      }
      }).catchError((e) {
        Fluttertoast.showToast(
        msg: e.message ?? e.toString(),
        backgroundColor: Colors.red,
      );
      });
    }

  
  }
    void addUserData(String uid){
       Map<String,dynamic>userData={
        'name':nameController.text,
        'email':emailController.text,
        'password':passwordController.text,
        'uid':uid,
       };
       FirebaseFirestore.instance.collection('users').doc(uid).set(userData).then((value){
        print('User data added');
        Fluttertoast.showToast(msg:"Registration Successful",backgroundColor:Colors.green);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>HomeScreen()));
        }).catchError((e) {
          Fluttertoast.showToast(
            msg: e.message ?? e.toString(),
            backgroundColor: Colors.red,
            );
            });
            
    }
}
