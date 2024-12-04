import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_shop/screens/login_screen.dart';
import 'package:project_shop/services/announcement_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:project_shop/services/account_firestore.dart';

TextEditingController titleController = TextEditingController();
TextEditingController prizeController = TextEditingController();
TextEditingController locationController = TextEditingController();
TextEditingController descriptionController = TextEditingController();

AnnouncementService announcementService = AnnouncementService();

bool isImageReady = false;

void _addImage() async {
  isImageReady = false;
  ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
  print('${file?.path}');

  announcementService.addImage(file); //.then((_) { isImageReady = true; });
}

class CreateAnnouncementScreen extends StatefulWidget {
  final Account account;
  CreateAnnouncementScreen({required this.account});

  @override
  State<CreateAnnouncementScreen> createState() =>
      _CreateAnnouncementScreenState();
}

class _CreateAnnouncementScreenState extends State<CreateAnnouncementScreen> {
  String message = '';

  void _makeAnnouncement(String title, double prize, String location,
      String description, Account account) {
    announcementService
        .addAnnouncement(title, prize, location, description, account)
        .then((result) {
      setState(() {
        if (result != null) {
          message = result;
        } else {
          message = 'Announcement created successfully';
          titleController.text = "";
          prizeController.text = "";
          locationController.text = "";
          descriptionController.text = "";
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Add listing',
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: GoogleFonts.lato(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 22,
              ),
            ),
            SizedBox(height: screenHeight / 30),
            Container(
              width: screenWidth / 1.5,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5), // Kolor przezroczysty
                borderRadius: BorderRadius.circular(10.0), // Zaokrąglenie
              ),
              child: TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'title',
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0), // Wielkość wewnętrznego odstępu
                ),
              ),
            ),
            SizedBox(height: screenHeight / 50),
            Container(
              width: screenWidth / 1.5,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5), // Kolor przezroczysty
                borderRadius: BorderRadius.circular(10.0), // Zaokrąglenie
              ),
              child: TextField(
                controller: prizeController,
                decoration: const InputDecoration(
                  hintText: 'prize',
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0), // Wielkość wewnętrznego odstępu
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(height: screenHeight / 50),
            Container(
              width: screenWidth / 1.5,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5), // Kolor przezroczysty
                borderRadius: BorderRadius.circular(10.0), // Zaokrąglenie
              ),
              child: TextField(
                controller: locationController,
                decoration: const InputDecoration(
                  hintText: 'location',
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0), // Wielkość wewnętrznego odstępu
                ),
              ),
            ),
            SizedBox(height: screenHeight / 50),
            Container(
              width: screenWidth / 1.5,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5), // Kolor przezroczysty
                borderRadius: BorderRadius.circular(10.0), // Zaokrąglenie
              ),
              child: TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: 'description',
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0), // Wielkość wewnętrznego odstępu
                ),
              ),
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
                        double prize =
                            double.tryParse(prizeController.text) ?? 0.0;
                        _makeAnnouncement(
                            titleController.text,
                            prize,
                            locationController.text,
                            descriptionController.text,
                            widget.account);
                      },
                      icon: Icon(
                        Icons.arrow_circle_right_outlined,
                        size: 50,
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
