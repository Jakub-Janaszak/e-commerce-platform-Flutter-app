import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:project_shop/screens/announcements_screen.dart';
import 'package:project_shop/screens/single_announcement_screen.dart';
import 'package:project_shop/screens/login_screen.dart';
import 'package:project_shop/screens/register_screen.dart';
import 'package:project_shop/screens/account_screen.dart';
import 'package:project_shop/screens/create_announcement_screen.dart';
import 'package:project_shop/main_page.dart';
import 'package:project_shop/services/account_firestore.dart';

class MainPage extends StatefulWidget {
  final Account account;
  MainPage({required this.account});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;
  late List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      AnnouncementsScreen(account: widget.account), //login: widget.login),
      CreateAnnouncementScreen(account: widget.account),
      //AnnouncementsScreen(),
      AccountScreen(account: widget.account)
    ];
  }

  @override
  Widget build(BuildContext context) {
    final itemsNavicationBar = <Widget>[
      const Icon(Icons.home, size: 30),
      const Icon(Icons.add, size: 30),
      //const Icon(Icons.favorite, size: 30),
      const Icon(Icons.person, size: 30)
    ];

    return Scaffold(
      extendBody: true,
      body: screens[index],
      backgroundColor: Colors.blue,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: IconThemeData(color: Colors.white),
        ),
        child: CurvedNavigationBar(
          items: itemsNavicationBar,
          height: 55,
          color: Colors.black,
          index: index,
          backgroundColor: Colors.transparent,
          onTap: (index) => setState(() => this.index = index),
          animationDuration: Duration(milliseconds: 300),
        ),
      ),
    );
  }
}
