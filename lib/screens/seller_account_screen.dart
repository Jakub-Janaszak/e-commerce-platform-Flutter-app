import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_shop/UI_elements/announcement_view.dart';
import 'package:project_shop/screens/admin_delete_account_screen.dart';
import 'package:project_shop/screens/announcements_screen.dart';
import 'package:project_shop/screens/edit_announcement_screen.dart';
import 'package:project_shop/screens/single_announcement_screen.dart';
import 'package:project_shop/services/account_firestore.dart';
import 'package:project_shop/services/announcement_firestore.dart';

class SellerAccountScreen extends StatefulWidget {
  final Account? userAccount;
  final Account sellerAccount;
  SellerAccountScreen({required this.sellerAccount, this.userAccount});

  void _navigateToMainPage(BuildContext context, Announcement announcement) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SingleAnnouncementScreen(
              announcement: announcement,
              userAccount: userAccount,
            )));
  }

  void _navigateToAdminDeleteAccountScreen(
      BuildContext context, Account userAccount, Account sellerAccount) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AdminDeleteAccountScreen(
              userAccout: userAccount,
              sellerAccout: sellerAccount,
            )));
  }

  @override
  State<SellerAccountScreen> createState() => _SellerAccountScreenState();
}

class _SellerAccountScreenState extends State<SellerAccountScreen> {
  AnnouncementService announcementService = AnnouncementService();

  late List<Announcement> announcements;
  late List<Announcement> filteredAnnouncements;
  TextEditingController searchController = TextEditingController();

  Future<void> loadAnnouncements() async {
    announcements = await announcementService
        .getAllAnnouncementsByOwnerId(widget.sellerAccount.id);
    filteredAnnouncements =
        announcements; // Początkowo wyświetl wszystkie ogłoszenia
    setState(() {}); // Odświeżenie widoku po załadowaniu danych
  }

  @override
  void initState() {
    super.initState();
    loadAnnouncements();
  }

  void filterAnnouncements(String query) {
    query = query.toLowerCase();
    setState(() {
      filteredAnnouncements = announcements.where((announcement) {
        return announcement.title.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) {
              filterAnnouncements(value);
            },
          ),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_circle_rounded,
                    size: screenWidth / 8,
                  ),
                  Text(
                    widget.sellerAccount.login,
                    style: GoogleFonts.lato(fontSize: 24),
                  ),
                  if (widget.userAccount?.login != null &&
                      widget.userAccount?.login == "admin")
                    GestureDetector(
                        onTap: () {
                          widget._navigateToAdminDeleteAccountScreen(context,
                              widget.userAccount!, widget.sellerAccount!);
                        },
                        child: Icon(
                          Icons.delete,
                          color: Color.fromARGB(125, 255, 0, 0),
                          size: screenWidth / 10,
                        )),
                ],
              ),
              for (int i = 0; i < filteredAnnouncements.length; i += 2)
                Row(children: [
                  GestureDetector(
                    onTap: () {
                      widget._navigateToMainPage(
                          context, filteredAnnouncements[i]);
                    },
                    child: AnnouncementView(
                        announcement: filteredAnnouncements[i]),
                  ),
                  if (i + 1 < filteredAnnouncements.length)
                    GestureDetector(
                      onTap: () {
                        widget._navigateToMainPage(
                            context, filteredAnnouncements[i + 1]);
                      },
                      child: AnnouncementView(
                          announcement: filteredAnnouncements[i + 1]),
                    ),
                ]),
              SizedBox(
                height: screenHeight / 10,
              )
            ],
          ),
        ));
  }
}
