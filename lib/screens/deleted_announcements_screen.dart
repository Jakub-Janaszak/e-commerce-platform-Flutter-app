import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_shop/screens/admin_delete_announcement_screen.dart';
import 'package:project_shop/services/account_firestore.dart';
import 'package:project_shop/services/admin_deleted_announcement_firestore.dart';
import 'package:intl/intl.dart';

class DeletedAnnouncementsScreen extends StatefulWidget {
  final Account account;

  DeletedAnnouncementsScreen({required this.account});

  @override
  _DeletedAnnouncementsScreenState createState() =>
      _DeletedAnnouncementsScreenState();
}

class _DeletedAnnouncementsScreenState
    extends State<DeletedAnnouncementsScreen> {
  AdminDeletedAnnouncementsService adminDeletedAnnouncementsService =
      AdminDeletedAnnouncementsService();
  late List<AdminDeletedAnnouncement> deletedAnnouncements = [];

  bool isLoading = true;

  Future<void> _loadDeletedAnnouncements() async {
    deletedAnnouncements = await adminDeletedAnnouncementsService
        .getAllAnnouncementsByOwnerId(widget.account.id);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadDeletedAnnouncements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Listings deleted by admin"),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      for (AdminDeletedAnnouncement deletedAnnouncement
                          in deletedAnnouncements)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              DateFormat('yyyy-MM-dd HH:mm').format(
                                  deletedAnnouncement.timestamp.toDate()),
                              textAlign: TextAlign.right,
                            ),
                            Text(
                              '"${deletedAnnouncement.announcementTitle}" has been deleted',
                              textAlign: TextAlign.center,
                            ),
                            Text("reason: ${deletedAnnouncement.reason}",
                                textAlign: TextAlign.center),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        )
                    ],
                  ),
                ),
              ));
  }
}
