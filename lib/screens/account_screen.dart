import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

String name = 'Kubjana';
String password = 'Kuba123';

class AccountScreen extends StatelessWidget {
  AccountScreen({super.key});

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
              '$name',
              textAlign: TextAlign.right,
              style: GoogleFonts.lato(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '$password',
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
