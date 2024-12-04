import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_shop/UI_elements/announcement_view.dart';
import 'package:project_shop/services/account_firestore.dart';
import 'package:project_shop/services/announcement_firestore.dart';

class SingleAnnouncementScreen extends StatefulWidget {
  final Announcement announcement;

  SingleAnnouncementScreen({required this.announcement});

  @override
  _SingleAnnouncementScreenState createState() =>
      _SingleAnnouncementScreenState();
}

class _SingleAnnouncementScreenState extends State<SingleAnnouncementScreen> {
  late Future<Announcement> _updatedAnnouncement;

  @override
  void initState() {
    super.initState();
    _updatedAnnouncement = _fetchUpdatedAnnouncement();
  }

  Future<Announcement> _fetchUpdatedAnnouncement() async {
    AnnouncementService announcementService = AnnouncementService();
    // Inkrementacja liczby wyświetleń w bazie
    await announcementService.incrementViews(widget.announcement.id);
    // Pobierz zaktualizowane dane
    Announcement? updatedAnnouncement =
        await announcementService.getAnnouncementByID(widget.announcement.id);

    AccountService accountService = AccountService();
    Account? account =
        await accountService.getAccountById(widget.announcement.id);

    if (updatedAnnouncement == null) {
      throw Exception('Nie udało się pobrać zaktualizowanego ogłoszenia.');
    }

    return updatedAnnouncement;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Announcement>(
        future: _updatedAnnouncement,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Wystąpił błąd!'));
          } else if (snapshot.hasData) {
            Announcement announcement = snapshot.data!;
            String prizeString = announcement.prize.toStringAsFixed(2);
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(announcement.imageUrl, fit: BoxFit.cover),
                  Text(
                    announcement.title,
                    style: GoogleFonts.lato(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$prizeString zł',
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: GoogleFonts.lato(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 30,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                      ),
                      Text(
                        announcement.location,
                        style: GoogleFonts.lato(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 14,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "views: " + (announcement.views ?? 0).toString(),
                        textAlign: TextAlign.left,
                        style: GoogleFonts.lato(
                          color: Color.fromARGB(255, 74, 74, 74),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    announcement.description,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.lato(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 20,
                    ),
                  ),
                  // TextButton.icon(
                  //   onPressed: () {
                  //     // Akcja po kliknięciu
                  //   },
                  //   icon: Icon(Icons.person, size: 24),
                  //   label: Text(
                  //     "Account",
                  //     style: TextStyle(fontSize: 16),
                  //   ),
                  //   style: TextButton.styleFrom(
                  //     foregroundColor: Colors.black,
                  //     padding:
                  //         EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  //   ),
                  // ),
                  SizedBox(
                    height: 200,
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('Brak danych!'));
          }
        },
      ),
    );
  }
}
