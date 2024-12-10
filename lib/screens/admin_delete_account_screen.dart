import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_shop/main_page.dart';
import 'package:project_shop/screens/login_screen.dart';
import 'package:project_shop/services/account_firestore.dart';
import 'package:project_shop/services/admin_deleted_announcement_firestore.dart';
import 'package:project_shop/services/announcement_firestore.dart';

class AdminDeleteAccountScreen extends StatefulWidget {
  final Account userAccout;
  final Account sellerAccout;
  AdminDeleteAccountScreen(
      {required this.userAccout, required this.sellerAccout});

  AccountService accountService = AccountService();
  AnnouncementService announcementService = AnnouncementService();

  @override
  State<AdminDeleteAccountScreen> createState() =>
      _AdminDeleteAccountScreenState();

  void _navigateToLoginScreen(BuildContext context) {
    Navigator.of(context)
        .pop(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void _deleteAccount(
      BuildContext context, Account userAccount, Account sellerAccount) async {
    List<Announcement> sellersAnnouncements = [];
    String info;
    sellersAnnouncements = await announcementService
        .getAllAnnouncementsByOwnerId(sellerAccount.id);
    for (Announcement announcement in sellersAnnouncements) {
      await announcementService.deleteAnnouncement(announcement.id);
    }
    await accountService.deleteAccount(sellerAccount.id);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (context) => MainPage(
                account: userAccount,
                refreshFlag: true,
              )),
      (Route<dynamic> route) => false, // Usuwa wszystkie poprzednie trasy
    );
  }

  void _goBack(BuildContext context) {
    Navigator.pop(context);
  }
}

class _AdminDeleteAccountScreenState extends State<AdminDeleteAccountScreen> {
  TextEditingController reasonController = TextEditingController();
  String message = '';

  @override
  Widget build(context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
          child: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                iconSize: 30,
                onPressed: () {},
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,
              )),
        ),
        Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
            'Do you realy want to delete this account?',
            style: GoogleFonts.lato(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight / 40),
          Container(
            width: screenWidth / 1.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0), // Zaokrąglone rogi
              border: Border.all(color: Colors.white), // Biała obwódka
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    widget._goBack(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
                SizedBox(width: screenWidth / 8),
                TextButton(
                  onPressed: () {
                    widget._deleteAccount(
                        context, widget.userAccout, widget.sellerAccout);
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Color.fromARGB(255, 255, 0, 0)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Text('$message', style: TextStyle(color: Colors.red))
        ]))
      ])),
    );
  }
}
