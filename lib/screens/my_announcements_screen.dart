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

  Future<void> _deleteAnnouncement(String announcementId) async {
    AnnouncementService announcementService = AnnouncementService();

    String? result =
        await announcementService.deleteAnnouncement(announcementId);

    if (result == null) {
      print("Announcement deleted successfully!");
    } else {
      print("$result");
    }
  }

  // Funkcja wyświetlająca okno dialogowe
  void _showDeleteDialog(BuildContext context, String announcementId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Do you really want to delete this listing?'),
          actions: [
            TextButton(
              onPressed: () {
                // Anulowanie operacji, zamknięcie dialogu
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _deleteAnnouncement(announcementId);
                loadAnnouncements();
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
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
            for (int i = 0; i < filteredAnnouncements.length; i += 2)
              Row(
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => EditAnnouncementScreen(
                                        announcement: filteredAnnouncements[i],
                                      )))
                              .then((_) {
                            loadAnnouncements();
                          });
                        },
                        child: AnnouncementView(
                            announcement: filteredAnnouncements[i]),
                      ),
                      Positioned(
                        left: 10,
                        top: 10,
                        child: GestureDetector(
                            onTap: () {
                              _showDeleteDialog(
                                  context, filteredAnnouncements[i].id);
                            },
                            child: Icon(
                              Icons.delete,
                              color: Color.fromARGB(125, 255, 0, 0),
                              size: screenWidth / 8,
                            )),
                      ),
                    ],
                  ),
                  if (i + 1 < filteredAnnouncements.length)
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) =>
                                        EditAnnouncementScreen(
                                          announcement:
                                              filteredAnnouncements[i + 1],
                                        )))
                                .then((_) {
                              loadAnnouncements();
                            });
                          },
                          child: AnnouncementView(
                              announcement: filteredAnnouncements[i + 1]),
                        ),
                        Positioned(
                          left: 10,
                          top: 10,
                          child: GestureDetector(
                              onTap: () {
                                _showDeleteDialog(
                                    context, filteredAnnouncements[i + 1].id);
                              },
                              child: Icon(
                                Icons.delete,
                                color: Color.fromARGB(125, 255, 0, 0),
                                size: screenWidth / 8,
                              )),
                        ),
                      ],
                    ),
                ],
              ),
            SizedBox(
              height: screenHeight / 10,
            ),
          ],
        ),
      ),
    );
  }
}
