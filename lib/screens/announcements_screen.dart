import 'package:flutter/material.dart';
import 'package:project_shop/UI_elements/announcement_view.dart';
import 'package:project_shop/screens/single_announcement_screen.dart';
import 'package:project_shop/services/announcement_firestore.dart';

class AnnouncementsScreen extends StatefulWidget {
  AnnouncementsScreen({super.key});

  void _navigateToMainPage(BuildContext context, String title, double prize,
      String location, String description, String imageURL) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SingleAnnouncementScreen(
            title: title,
            prize: prize,
            location: location,
            description: description,
            imageURL: imageURL)));
  }

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  AnnouncementService announcementService = AnnouncementService();

  late List<Announcement> announcements;
  late List<Announcement> filteredAnnouncements;
  TextEditingController searchController = TextEditingController();

  Future<void> loadAnnouncements() async {
    announcements = await announcementService.getAllAnnouncements();
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
                        context,
                        filteredAnnouncements[i].title,
                        filteredAnnouncements[i].prize,
                        filteredAnnouncements[i].location,
                        filteredAnnouncements[i].description,
                        filteredAnnouncements[i].imageUrl);
                  },
                  child: AnnouncementView(
                    title: filteredAnnouncements[i].title,
                    prize: filteredAnnouncements[i].prize,
                    location: filteredAnnouncements[i].location,
                    imageURL: filteredAnnouncements[i].imageUrl,
                  ),
                ),
                if (i + 1 < filteredAnnouncements.length)
                  GestureDetector(
                    onTap: () {
                      widget._navigateToMainPage(
                          context,
                          filteredAnnouncements[i + 1].title,
                          filteredAnnouncements[i + 1].prize,
                          filteredAnnouncements[i + 1].location,
                          filteredAnnouncements[i + 1].description,
                          filteredAnnouncements[i + 1].imageUrl);
                    },
                    child: AnnouncementView(
                      title: filteredAnnouncements[i + 1].title,
                      prize: filteredAnnouncements[i + 1].prize,
                      location: filteredAnnouncements[i + 1].location,
                      imageURL: filteredAnnouncements[i + 1].imageUrl,
                    ),
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
