import 'package:flutter/material.dart';
import 'package:project_shop/UI_elements/announcement_view.dart';

class AnnouncementsScreen extends StatelessWidget {
  AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
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
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (int i = 0; i < 20; i++)
              Row(
                children: [AnnouncementView(), AnnouncementView()],
              )
          ],
        ),
      ),
    );
  }
}
