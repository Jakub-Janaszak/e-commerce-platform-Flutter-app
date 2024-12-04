import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_shop/screens/register_screen.dart';
import 'package:project_shop/services/account_firestore.dart';
import 'package:project_shop/main_page.dart';

const startAlignment = Alignment.topLeft;
const endAlignment = Alignment.bottomRight;

TextEditingController loginController = TextEditingController();
TextEditingController passwordController = TextEditingController();

String errorMessage = "";

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _navigateToRegisterScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => RegisterScreen()));
  }

  void _navigateToMainPage(BuildContext context, Account account) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => MainPage(account: account)));
  }

  void attemptLogin(String login, String password, BuildContext context) async {
    AccountService accountService = AccountService();
    LoginResult result = await accountService.login(login, password);

    Account? account = await accountService.getAccountByLogin(login);

    if (result.success) {
      print(result.message);
      _navigateToMainPage(context, account!);
    } else {
      errorMessage = result.message;
      print(result.message);
    }
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
          child: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
            Image.asset(
              'assets/logos/Logo_white_trans.png',
              width: screenWidth / 2,
              //color: const Color.fromARGB(197, 255, 255, 255), //przezroczystosc
            ),
            Text(
              'Shop',
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
                  attemptLogin(
                      loginController.text, passwordController.text, context);

                  // Dodaj tutaj logikę dla przycisku
                  //print("l: " +loginController.text + "   p: " + passwordController.text);
                },
                child: const Text(
                  'Log in',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Text(errorMessage, style: TextStyle(color: Colors.red)),
            Container(
              width: screenWidth / 1.5,
              child: TextButton(
                onPressed: () {
                  _navigateToRegisterScreen(context);
                },
                style: ButtonStyle(
                  textStyle: WidgetStateProperty.all<TextStyle>(
                    const TextStyle(
                      decoration:
                          TextDecoration.underline, // Podkreślenie tekstu
                      color: Colors.white, // Kolor tekstu
                    ),
                  ),
                ),
                child: const Text(
                  'Create account',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ]))),
    );
  }
}
