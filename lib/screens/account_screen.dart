import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_shop/screens/single_announcement_screen.dart';

String word = '';

class AccountScreen extends StatelessWidget {
  final String login;
  AccountScreen({required this.login});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              size: screenWidth / 2,
            ),
            Text(
              '$login',
              textAlign: TextAlign.right,
              style: GoogleFonts.lato(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '$word',
              textAlign: TextAlign.right,
              style: GoogleFonts.lato(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: screenHeight / 3,
            )
          ],
        ),
      ),
    );
  }
}
