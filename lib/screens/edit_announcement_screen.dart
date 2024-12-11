import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_shop/UI_elements/announcement_view.dart';
import 'package:project_shop/models/categories.dart';
import 'package:project_shop/services/announcement_firestore.dart';

TextEditingController titleController = TextEditingController();
TextEditingController prizeController = TextEditingController();
TextEditingController locationController = TextEditingController();
TextEditingController descriptionController = TextEditingController();
String selectedCategory = categories.first;
bool _isReserved = false;

AnnouncementService announcementService = AnnouncementService();
bool isImageReady = false;

void _addImage() async {
  isImageReady = false;
  ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
  print('${file?.path}');

  announcementService.addImage(file); //.then((_) { isImageReady = true; });
}

class EditAnnouncementScreen extends StatefulWidget {
  final Announcement announcement;

  EditAnnouncementScreen({required this.announcement});

  @override
  _EditAnnouncementScreenState createState() => _EditAnnouncementScreenState();
}

class _EditAnnouncementScreenState extends State<EditAnnouncementScreen> {
  late Future<Announcement> _updatedAnnouncement;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.announcement.title);
    prizeController =
        TextEditingController(text: widget.announcement.prize.toString());
    locationController =
        TextEditingController(text: widget.announcement.location);
    descriptionController =
        TextEditingController(text: widget.announcement.description);
    selectedCategory = widget.announcement.category;
    _isReserved = widget.announcement.reserved;
    _updatedAnnouncement = _fetchUpdatedAnnouncement();
  }

  Future<Announcement> _fetchUpdatedAnnouncement() async {
    AnnouncementService announcementService = AnnouncementService();
    // Pobierz zaktualizowane dane
    Announcement? updatedAnnouncement =
        await announcementService.getAnnouncementByID(widget.announcement.id);

    if (updatedAnnouncement == null) {
      throw Exception('Nie udało się pobrać zaktualizowanego ogłoszenia.');
    }

    return updatedAnnouncement;
  }

  void _editAnnouncement(String announcementId) async {
    String? result = await announcementService.updateAnnouncement(
      announcementId,
      title: titleController.text,
      prize: double.tryParse(prizeController.text) ?? 0.0,
      location: locationController.text,
      description: descriptionController.text,
      category: selectedCategory,
      reserved: _isReserved,
    );

    if (result != null) {
      print("Update failed: $result");
    } else {
      print("Announcement updated successfully");
    }
    announcementService.imageUrl = '';
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.network(announcement.imageUrl, fit: BoxFit.cover),
                    Text(
                      "Edit listing",
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: GoogleFonts.lato(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 30,
                      ),
                    ),
                    Text(
                      "title:",
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: GoogleFonts.lato(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 15,
                      ),
                    ),
                    Container(
                      width: screenWidth / 1.5,
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(0.5), // Kolor przezroczysty
                        borderRadius:
                            BorderRadius.circular(10.0), // Zaokrąglenie
                      ),
                      child: TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal:
                                  10.0), // Wielkość wewnętrznego odstępu
                        ),
                      ),
                    ),
                    Text(
                      "prize:",
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: GoogleFonts.lato(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 15,
                      ),
                    ),
                    Container(
                      width: screenWidth / 1.5,
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(0.5), // Kolor przezroczysty
                        borderRadius:
                            BorderRadius.circular(10.0), // Zaokrąglenie
                      ),
                      child: TextField(
                        controller: prizeController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal:
                                  10.0), // Wielkość wewnętrznego odstępu
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Text(
                      "location:",
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: GoogleFonts.lato(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 15,
                      ),
                    ),
                    Container(
                      width: screenWidth / 1.5,
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(0.5), // Kolor przezroczysty
                        borderRadius:
                            BorderRadius.circular(10.0), // Zaokrąglenie
                      ),
                      child: TextField(
                        controller: locationController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal:
                                  10.0), // Wielkość wewnętrznego odstępu
                        ),
                      ),
                    ),
                    Text(
                      "description:",
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: GoogleFonts.lato(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 15,
                      ),
                    ),
                    Container(
                      width: screenWidth / 1.5,
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(0.5), // Kolor przezroczysty
                        borderRadius:
                            BorderRadius.circular(10.0), // Zaokrąglenie
                      ),
                      child: TextField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal:
                                  10.0), // Wielkość wewnętrznego odstępu
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight / 50),
                    DropdownButton<String>(
                      value: selectedCategory,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCategory = newValue!;
                        });
                      },
                      items: categories
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: screenHeight / 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Reserved: "),
                        Checkbox(
                          value: _isReserved, // stan checkboxa
                          onChanged: (bool? value) {
                            setState(() {
                              _isReserved =
                                  value ?? false; // zmiana stanu checkboxa
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight / 30,
                    ),
                    IconButton(
                        onPressed: _addImage,
                        icon: Icon(
                          Icons.add_a_photo_outlined,
                          size: 40,
                        )),
                    Container(
                      width: screenWidth / 1.3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () {
                                _editAnnouncement(widget.announcement.id);
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_circle_right_outlined,
                                size: 50,
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 200,
                    ),
                  ],
                ),
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
