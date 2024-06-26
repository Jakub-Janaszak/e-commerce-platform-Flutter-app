import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_shop/screens/login_screen.dart';
import 'package:project_shop/services/account_firestore.dart';

void _navigateToLoginScreen(BuildContext context) {
  Navigator.of(context)
      .pop(MaterialPageRoute(builder: (context) => LoginScreen()));
}



class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AccountService accountService = AccountService();
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String message = '';

  void registerAccount(String login, String email, String password) {
    AccountService().addAccount(login, email, password).then((result) {
      setState(() {
        if (result != null) {
          message = result;
        } else {
          message = 'Account created successfully';
          _navigateToLoginScreen(context);
        }
      });
    });
  }

  @override
  Widget build(context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 1, 47, 139),
                Color.fromARGB(255, 85, 42, 126)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    iconSize: 30,
                    onPressed: () {
                      _navigateToLoginScreen(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.white,
                  )),
            ),
            Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(
                'Register',
                style: GoogleFonts.lato(
                  color: const Color.fromARGB(255, 232, 216, 255),
                  fontSize: 24,
                ),
              ),
              SizedBox(height: screenHeight / 20),
              Container(
                width: screenWidth / 1.5,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5), // Kolor przezroczysty
                  borderRadius: BorderRadius.circular(10.0), // Zaokrąglenie
                ),
                child: TextField(
                  controller: loginController,
                  decoration: const InputDecoration(
                    hintText: 'Login',
                    border: InputBorder.none, // Usuwa domyślną obwódkę
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 10.0), // Wielkość wewnętrznego odstępu
                  ),
                ),
              ),
              SizedBox(height: screenHeight / 50),
              Container(
                width: screenWidth / 1.5,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5), // Kolor przezroczysty
                  borderRadius: BorderRadius.circular(10.0), // Zaokrąglenie
                ),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: 'E-mail',
                    border: InputBorder.none, // Usuwa domyślną obwódkę
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 10.0), // Wielkość wewnętrznego odstępu
                  ),
                ),
              ),
              SizedBox(height: screenHeight / 50),
              Container(
                width: screenWidth / 1.5,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5), // Kolor przezroczysty
                  borderRadius: BorderRadius.circular(10.0), // Zaokrąglenie
                ),
                child: TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    border: InputBorder.none, // Usuwa domyślną obwódkę
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 10.0), // Wielkość wewnętrznego odstępu
                  ),
                  obscureText: true,
                ),
              ),
              SizedBox(height: screenHeight / 50),
              Container(
                width: screenWidth / 1.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0), // Zaokrąglone rogi
                  border: Border.all(color: Colors.white), // Biała obwódka
                ),
                child: TextButton(
                  onPressed: () {
                    // Dodaj tutaj logikę dla przycisku
                    print("l: " +
                        loginController.text +
                        "   p: " +
                        passwordController.text);
                    registerAccount(loginController.text, emailController.text,
                        passwordController.text);
                  },
                  child: const Text(
                    'Create account',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text('$message', style: TextStyle(color: Colors.red))
            ]))
          ])),
    );
  }
}
