import 'package:flutter/material.dart';
import 'package:project_shop/UI_elements/announcement_view.dart';
import 'package:project_shop/screens/announcements_screen.dart';
import 'package:project_shop/screens/edit_announcement_screen.dart';
import 'package:project_shop/screens/single_announcement_screen.dart';
import 'package:project_shop/services/account_firestore.dart';
import 'package:project_shop/services/announcement_firestore.dart';

class MyAnnouncementsScreen extends StatefulWidget {
  final Account account;
  MyAnnouncementsScreen({required this.account});

  void _navigateToMainPage(BuildContext context, Announcement announcement) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EditAnnouncementScreen(
              announcement: announcement,
            )));
  }

  @override
  State<MyAnnouncementsScreen> createState() => _MyAnnouncementsScreenState();
}

class _MyAnnouncementsScreenState extends State<MyAnnouncementsScreen> {
  AnnouncementService announcementService = AnnouncementService();

  late List<Announcement> announcements;
  late List<Announcement> filteredAnnouncements;
  TextEditingController searchController = TextEditingController();

  Future<void> loadAnnouncements() async {
    announcements = await announcementService
        .getAllAnnouncementsByOwnerId(widget.account.id);
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
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (int i = 0; i < filteredAnnouncements.length; i += 2)
              Row(children: [
                GestureDetector(
                  onTap: () {
                    widget._navigateToMainPage(
                        context, filteredAnnouncements[i]);
                  },
                  child:
                      AnnouncementView(announcement: filteredAnnouncements[i]),
                ),
                if (i + 1 < filteredAnnouncements.length)
                  GestureDetector(
                    onTap: () {
                      widget._navigateToMainPage(
                          context, filteredAnnouncements[i + 1]);
                    },
                    child: AnnouncementView(
                        announcement: filteredAnnouncements[i + 1]),
                  )
              ]),
            SizedBox(
              height: screenHeight / 10,
            )
          ],
        ),
      ),
    );
  }
}
