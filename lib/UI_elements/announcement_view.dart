import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_shop/services/announcement_firestore.dart';

class AnnouncementView extends StatelessWidget {
  Announcement announcement;
  String prizeString;
  AnnouncementView(
      {required this.announcement})
      : prizeString = announcement.prize.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.all(screenWidth / 45),
      width: screenWidth / 2.2,
      height: (screenWidth / 2.2) + 140,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 227, 227, 227),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: AspectRatio(
                aspectRatio: 1.0,
                child: Image.network(announcement.imageUrl,
                    fit: BoxFit
                        .cover) /*Image.asset(
                'assets/images/iphone.jpg',
                fit: BoxFit.cover,
              ), */
                ),
          ),
          Text(
            announcement.title,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: GoogleFonts.lato(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 22,
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
          Text(
            '$prizeString zł',
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: GoogleFonts.lato(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
