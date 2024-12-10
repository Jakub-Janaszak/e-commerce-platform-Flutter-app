import 'package:flutter/material.dart';
import 'package:project_shop/services/account_firestore.dart';

class DeletedAnnouncementsScreen extends StatefulWidget {
  final Account account;

  DeletedAnnouncementsScreen({required this.account});

  @override
  _DeletedAnnouncementsScreenState createState() =>
      _DeletedAnnouncementsScreenState();
}

class _DeletedAnnouncementsScreenState
    extends State<DeletedAnnouncementsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Listings deleted by admin"),
      ),
      body: 
      Column(children: [
        
      ],)
    );
  }
}
