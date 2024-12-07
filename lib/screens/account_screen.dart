import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_shop/screens/my_announcements_screen.dart';
import 'package:project_shop/screens/single_announcement_screen.dart';
import 'package:project_shop/services/account_firestore.dart';
import 'package:project_shop/services/announcement_firestore.dart';

String word = '';

class AccountScreen extends StatelessWidget {
  final Account account;
  AccountScreen({required this.account});

  void _navigateToMyListing(BuildContext context, Account account) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MyAnnouncementsScreen(
              account: account,
            )));
  }

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
              account.login,
              textAlign: TextAlign.right,
              style: GoogleFonts.lato(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                _navigateToMyListing(context, account);
              },
              child: const Text(
                'my listings',
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
              style: TextButton.styleFrom(
                fixedSize: Size(screenWidth, 50),
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
