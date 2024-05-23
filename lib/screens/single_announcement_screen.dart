import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_shop/UI_elements/announcement_view.dart';

String name = "Iphone 13 i słuchawki";
double prize = 40001.1;
String location = "Gliwice";
String description =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce sed diam sit amet elit ornare ullamcorper. Phasellus euismod dolor vitae metus lacinia maximus. Etiam quis tellus nec nunc egestas elementum nec ut ex. Sed nec metus dolor. Pellentesque eu mollis mi, sed porttitor dolor. Integer consectetur tortor a magna lacinia, vel dictum lorem vulputate. Suspendisse tincidunt, sapien id consectetur vehicula, urna sapien consectetur dolor.";

class SingleAnnouncementScreen extends StatelessWidget {
  SingleAnnouncementScreen({super.key});

  String prizeString = prize.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/images/iphone.jpg'),
          Text(
            '$name',
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
