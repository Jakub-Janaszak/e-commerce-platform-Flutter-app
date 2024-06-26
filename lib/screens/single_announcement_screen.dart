import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_shop/UI_elements/announcement_view.dart';

class SingleAnnouncementScreen extends StatelessWidget {
  final String title;
  final double prize;
  final String location;
  final String description;
  final String imageURL;
  final String prizeString;

  SingleAnnouncementScreen(
      {required this.title,
      required this.prize,
      required this.location,
      required this.description,
      required this.imageURL})
      : prizeString = prize.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(imageURL, fit: BoxFit.cover),
          Text(
            '$title',
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
                '$location',
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
            '$description',
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
