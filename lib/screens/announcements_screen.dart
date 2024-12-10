import 'package:flutter/material.dart';
import 'package:project_shop/UI_elements/announcement_view.dart';
import 'package:project_shop/screens/single_announcement_screen.dart';
import 'package:project_shop/services/account_firestore.dart';
import 'package:project_shop/services/announcement_firestore.dart';

class AnnouncementsScreen extends StatefulWidget {
  final Account? account;
  AnnouncementsScreen({this.account});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  AnnouncementService announcementService = AnnouncementService();

  late List<Announcement> announcements = [];
  late List<Announcement> filteredAnnouncements = [];
  TextEditingController searchController = TextEditingController();

  bool isLoading = true;

  Future<void> loadAnnouncements() async {
    announcements = await announcementService.getAllAnnouncements();
    filteredAnnouncements = announcements;
    setState(() {
      isLoading = false; // Ustawienie stanu na zakończenie ładowania
    });
  }

  @override
  void initState() {
    super.initState();
    loadAnnouncements();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ponowne ładowanie danych, jeśli ekran jest odświeżany
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
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Wyświetl ładowanie
          : SingleChildScrollView(
              child: Column(
                children: [
                  for (int i = 0; i < filteredAnnouncements.length; i += 2)
                    Row(children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: (context) => SingleAnnouncementScreen(
                                announcement: filteredAnnouncements[i],
                                userAccount: widget.account,
                              ),
                            ),
                          )
                              .then((_) {
                            // Odśwież dane po powrocie
                            loadAnnouncements();
                          });
                        },
                        child: AnnouncementView(
                            announcement: filteredAnnouncements[i]),
                      ),
                      if (i + 1 < filteredAnnouncements.length)
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (context) => SingleAnnouncementScreen(
                                  announcement: filteredAnnouncements[i + 1],
                                  userAccount: widget.account,
                                ),
                              ),
                            )
                                .then((_) {
                              // Odśwież dane po powrocie
                              loadAnnouncements();
                            });
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
