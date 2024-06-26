import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class Announcement {
  final String id; // Dodaj pole ID
  final String title;
  final double prize;
  final String location;
  final String description;
  final String imageUrl;
  final Timestamp timestamp;

  Announcement({
    required this.id,
    required this.title,
    required this.prize,
    required this.location,
    required this.description,
    required this.imageUrl,
    required this.timestamp,
  });

  factory Announcement.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Announcement(
      id: doc.id, // Przypisz ID dokumentu
      title: data['title'] ?? '',
      prize: data['prize']?.toDouble() ?? 0.0,
      location: data['location'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['image'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }
}

class AnnouncementService {
  String imageUrl = '';

  void addImage(XFile? file) async {
    if (file == null) return;

    //Import dart:core
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    //Get the reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);
    
    try {
      //store the file
      await referenceImageToUpload.putFile(File(file!.path));

      imageUrl = await referenceImageToUpload.getDownloadURL();
      
    } catch (error) {
      print(error);
    }
    
  }

  //get collection
  final CollectionReference announcements =
      FirebaseFirestore.instance.collection('announcements');

  //Create
  Future<String?> addAnnouncement(String title, double prize, String location,
      String description, String login) async {
    if (title.isEmpty ||
        prize == null ||
        location.isEmpty ||
        description.isEmpty) {
      return 'Enter all data.';
    }

    // Dodanie nowego konta
    await announcements.doc().set({
      'title': title,
      'prize': prize,
      'location': location,
      'image': imageUrl,
      'description': description,
      'owner': login,
      'timestamp': Timestamp.now()
    });
    return null;
  }

  // Get all announcements
  Future<List<Announcement>> getAllAnnouncements() async {
    QuerySnapshot querySnapshot = await announcements.get();
    return querySnapshot.docs
        .map((doc) => Announcement.fromFirestore(doc))
        .toList();
  }

  Future<Announcement?> getAnnouncementByID(String announcementId) async {
    try {
      DocumentReference announcementRef = announcements.doc(announcementId);
      DocumentSnapshot documentSnapshot = await announcementRef.get();

      if (documentSnapshot.exists) {
        Announcement announcement =
            Announcement.fromFirestore(documentSnapshot);
        return announcement;
      } else {
        print("Document does not exist");
        return null;
      }
    } catch (e) {
      print("Error getting document: $e");
      return null;
    }
  }
}
