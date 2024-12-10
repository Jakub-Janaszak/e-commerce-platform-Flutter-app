import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_shop/main_page.dart';
import 'package:project_shop/screens/login_screen.dart';
import 'package:project_shop/services/account_firestore.dart';
import 'package:project_shop/services/admin_deleted_announcement_firestore.dart';
import 'package:project_shop/services/announcement_firestore.dart';

class AdminDeleteAnnouncementScreen extends StatefulWidget {
  final Announcement announcement;
  final Account userAccout;
  final Account sellerAccout;
  AdminDeleteAnnouncementScreen(
      {required this.announcement,
      required this.userAccout,
      required this.sellerAccout});

  AdminDeletedAnnouncementsService adminDeletedAnnouncementsService =
      AdminDeletedAnnouncementsService();
  AnnouncementService announcementService = AnnouncementService();

  @override
  State<AdminDeleteAnnouncementScreen> createState() =>
      _AdminDeleteAnnouncementScreenState();

  void _navigateToLoginScreen(BuildContext context) {
    Navigator.of(context)
        .pop(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void _deleteAnnouncement(BuildContext context, Account userAccount,
      Account sellerAccount, Announcement announcement, String reason) {
    adminDeletedAnnouncementsService
        .addAdminDeletedAnnouncement(
            userAccount.id, sellerAccount.id, announcement.title, reason)
        .then((result) {
      announcementService.deleteAnnouncement(announcement.id);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => MainPage(
                  account: userAccount,
                  refreshFlag: true,
                )),
        (Route<dynamic> route) => false, // Usuwa wszystkie poprzednie trasy
      );
    });
  }

  void _goBack(BuildContext context) {
    Navigator.pop(context);
  }
}

class _AdminDeleteAnnouncementScreenState
    extends State<AdminDeleteAnnouncementScreen> {
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
            'Reason for deletion',
            style: GoogleFonts.lato(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 24,
            ),
          ),
          SizedBox(height: screenHeight / 20),
          Container(
            width: screenWidth / 1.5,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 137, 137, 137)
                  .withOpacity(0.5), // Kolor przezroczysty
              borderRadius: BorderRadius.circular(10.0), // Zaokrąglenie
            ),
            child: TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                hintText: 'reason...',
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
                    widget._deleteAnnouncement(
                        context,
                        widget.userAccout,
                        widget.sellerAccout,
                        widget.announcement,
                        reasonController.text);
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
