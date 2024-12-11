import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_shop/UI_elements/announcement_view.dart';
import 'package:project_shop/screens/admin_delete_announcement_screen.dart';
import 'package:project_shop/screens/seller_account_screen.dart';
import 'package:project_shop/services/account_firestore.dart';
import 'package:project_shop/services/announcement_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SingleAnnouncementScreen extends StatefulWidget {
  final Announcement announcement;
  final Account? userAccount;

  SingleAnnouncementScreen(
      {required this.announcement, required this.userAccount});

  @override
  _SingleAnnouncementScreenState createState() =>
      _SingleAnnouncementScreenState();

  void _navigateToSellerScreen(BuildContext context, Account? sellerAccount) {
    if (sellerAccount != null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SellerAccountScreen(
                userAccount: userAccount,
                sellerAccount: sellerAccount,
              )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account was deleted.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _navigateToAdminDeleteAnnouncementScreen(BuildContext context,
      Announcement announcement, Account userAccount, Account sellerAccount) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AdminDeleteAnnouncementScreen(
              announcement: announcement,
              userAccout: userAccount,
              sellerAccout: sellerAccount,
            )));
  }

// potrzebne manifesty dla androida
  void _launchPhone(BuildContext context, String? phoneNumber) async {
    if (phoneNumber != null) {
      final Uri _phoneUri = Uri(
          scheme: 'tel',
          path: phoneNumber.replaceAll(' ', '').replaceAll('-', ''));

      // Sprawdzenie czy można otworzyć aplikację telefonu
      if (await canLaunchUrlString(_phoneUri.toString())) {
        await launchUrlString(
            _phoneUri.toString()); // Uruchomienie aplikacji telefonu
      } else {
        throw 'Nie można otworzyć aplikacji telefonu.';
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User does not have phone number.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _launchEmail(BuildContext context, String? email) async {
    if (email != null) {
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: email,
      );
      // Sprawdzenie, czy możemy otworzyć aplikację e-mailową
      if (await canLaunchUrlString(emailUri.toString())) {
        // Otwórz aplikację e-mailową z odpowiednimi parametrami
        await launchUrlString(emailUri.toString());
      } else {
        throw 'Nie można otworzyć aplikacji e-mailowej.';
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User does not have email.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}

class _SingleAnnouncementScreenState extends State<SingleAnnouncementScreen> {
  late Future<MapEntry<Announcement, Account?>> _updatedAnnouncement;

  @override
  void initState() {
    super.initState();
    _updatedAnnouncement = _fetchUpdatedAnnouncement();
  }

  Future<MapEntry<Announcement, Account?>> _fetchUpdatedAnnouncement() async {
    AnnouncementService announcementService = AnnouncementService();
    // Inkrementacja liczby wyświetleń w bazie
    await announcementService.incrementViews(widget.announcement.id);
    // Pobierz zaktualizowane dane
    Announcement? updatedAnnouncement =
        await announcementService.getAnnouncementByID(widget.announcement.id);

    AccountService accountService = AccountService();
    Account? account =
        await accountService.getAccountById(widget.announcement.owner);

    if (updatedAnnouncement == null) {
      throw Exception('Nie udało się pobrać zaktualizowanego ogłoszenia.');
    }

    return MapEntry(updatedAnnouncement, account);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: FutureBuilder<MapEntry<Announcement, Account?>>(
        future: _updatedAnnouncement,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Wystąpił błąd!'));
          } else if (snapshot.hasData) {
            Announcement announcement = snapshot.data!.key;
            Account? sellerAccount = snapshot.data!.value;
            String prizeString = announcement.prize.toStringAsFixed(2);
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Image.network(
                              announcement.imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                            if (widget.userAccount?.login != null &&
                                widget.userAccount?.login == "admin")
                              Positioned(
                                right: 4,
                                bottom: 4,
                                child: GestureDetector(
                                    onTap: () {
                                      widget
                                          ._navigateToAdminDeleteAnnouncementScreen(
                                              context,
                                              announcement,
                                              widget.userAccount!,
                                              sellerAccount!);
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: Color.fromARGB(125, 255, 0, 0),
                                      size: screenWidth / 6,
                                    )),
                              ),
                          ],
                        ),
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
                            const Icon(
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
                        const SizedBox(
                          height: 10,
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            widget._navigateToSellerScreen(
                                context, sellerAccount);
                          },
                          icon: const Icon(
                            Icons.account_circle,
                            color: Color.fromARGB(255, 63, 63, 63),
                          ),
                          label: Text(
                            sellerAccount?.login ?? "Anonim",
                            style: TextStyle(
                                color: Color.fromARGB(255, 63, 63, 63)),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: Color.fromARGB(255, 63, 63, 63),
                                width: 2), // Obwódka
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  100), // Zaokrąglone rogi
                            ),
                            // Odstępy
                            backgroundColor: Colors.white, // Tło przycisku
                          ),
                        ),
                        const SizedBox(
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
                        Text(
                          "category: ${announcement.category}",
                          textAlign: TextAlign.left,
                          style: GoogleFonts.lato(
                            color: Color.fromARGB(255, 59, 59, 59),
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(
                          height: 400,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          widget._launchPhone(
                              context, sellerAccount?.phoneNumber);
                        },
                        child: Container(
                          width: screenWidth / 2,
                          padding: const EdgeInsets.all(15),
                          color: Color.fromARGB(255, 0, 191, 25),
                          child: Center(
                              child: Icon(
                            Icons.call,
                            color: Colors.white,
                          )),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget._launchEmail(context, sellerAccount?.email);
                        },
                        child: Container(
                          width: screenWidth / 2,
                          padding: const EdgeInsets.all(15),
                          color: Colors.blue,
                          child: Center(
                              child: Icon(
                            Icons.mail,
                            color: Colors.white,
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
                if (announcement.reserved == true)
                  Positioned(
                    top: 25,
                    left: 5,
                    child: Text(
                      "RESERVED",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.lato(
                        color: Color.fromARGB(255, 255, 0, 0),
                        fontSize: 25,
                      ),
                    ),
                  ),
              ],
            );
          } else {
            return Center(child: Text('Brak danych!'));
          }
        },
      ),
    );
  }
}
