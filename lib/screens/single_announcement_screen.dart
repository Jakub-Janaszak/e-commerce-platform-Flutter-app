import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_shop/UI_elements/announcement_view.dart';
import 'package:project_shop/services/announcement_firestore.dart';

class SingleAnnouncementScreen extends StatelessWidget {
  final Announcement announcement;
  final String prizeString;

  SingleAnnouncementScreen({required this.announcement})
      : prizeString = announcement.prize.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
          SizedBox(
            height: 200,
          )
        ],
      )),
    );
  }
}
