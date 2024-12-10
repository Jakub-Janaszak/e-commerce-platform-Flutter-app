import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_shop/services/account_firestore.dart';

class Announcement {
  final String id;
  final String title;
  final double prize;
  final String location;
  final String description;
  final String imageUrl;
  final Timestamp timestamp;
  final String owner;
  final int views;
  final String category;

  Announcement({
    required this.id,
    required this.title,
    required this.prize,
    required this.location,
    required this.description,
    required this.imageUrl,
    required this.timestamp,
    required this.owner,
    required this.views,
    required this.category,
  });

  // Factory method - mapowanie z Firestore do obiektu Announcement
  factory Announcement.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Announcement(
      id: doc.id,
      title: data['title'] ?? '',
      prize: data['prize']?.toDouble() ?? 0.0,
      location: data['location'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['image'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      owner: data['owner'] ?? '',
      views: data['views'] ?? 0,
      category: data['category'] ?? 'Uncategorized',
    );
  }

  // ToMap - konwertowanie obiektu Announcement na Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'prize': prize,
      'location': location,
      'image': imageUrl,
      'description': description,
      'owner': owner,
      'timestamp': timestamp,
      'views': views,
      'category': category,
    };
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
      String description, String category, Account account) async {
    if (title.isEmpty ||
        prize == null ||
        location.isEmpty ||
        description.isEmpty) {
      return 'Enter all data.';
    }

    // Tworzymy obiekt Announcement i mapujemy go na Map
    Announcement newAnnouncement = Announcement(
      id: '',
      title: title,
      prize: prize,
      location: location,
      description: description,
      imageUrl: imageUrl,
      timestamp: Timestamp.now(),
      owner: account.id,
      views: 0,
      category: category,
    );

    // Zapisujemy do Firestore używając mapy z metody toMap
    await announcements.add(newAnnouncement.toMap());
    return null;
  }

  // Update an existing announcement
  Future<String?> updateAnnouncement(
    String announcementId, {
    String? title,
    double? prize,
    String? location,
    String? description,
    String? category,
  }) async {
    try {
      Map<String, dynamic> updates = {};

      // Dodajemy do mapy tylko te pola, które mają nowe wartości
      if (title != null && title.isNotEmpty) updates['title'] = title;
      if (prize != null) updates['prize'] = prize;
      if (location != null && location.isNotEmpty)
        updates['location'] = location;
      if (description != null && description.isNotEmpty)
        updates['description'] = description;
      if (!imageUrl.isEmpty) updates['image'] = imageUrl;

      if (updates.isEmpty) {
        return 'No updates provided';
      }
      if (category != null && category.isNotEmpty)
        updates['category'] = category;

      // Aktualizacja ogłoszenia w Firestore
      await announcements.doc(announcementId).update(updates);

      return null; //sukces
    } catch (e) {
      print("Error updating announcement: $e");
      return 'Error updating announcement';
    }
  }

  // Get all announcements
  Future<List<Announcement>> getAllAnnouncements() async {
    QuerySnapshot querySnapshot = await announcements.get();
    return querySnapshot.docs
        .map((doc) => Announcement.fromFirestore(doc))
        .toList();
  }

  // Get all announcements of passed owner
  Future<List<Announcement>> getAllAnnouncementsByOwnerId(
      String ownerId) async {
    try {
      QuerySnapshot querySnapshot = await announcements
          .where('owner', isEqualTo: ownerId) // Filtrowanie ogłoszeń po ownerId
          .get();

      return querySnapshot.docs
          .map((doc) => Announcement.fromFirestore(doc))
          .toList();
    } catch (e) {
      print("Error fetching announcements by owner ID: $e");
      return [];
    }
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

  // Zwiększenie liczby oglądających
  Future<void> incrementViews(String announcementId) async {
    try {
      // Pobranie dokumentu ogłoszenia
      DocumentReference announcementRef = announcements.doc(announcementId);

      // Zwiększenie pola 'views' o 1
      await announcementRef.update({
        'views': FieldValue.increment(1),
      });
    } catch (e) {
      print("Error incrementing views: $e");
    }
  }

  // Delete an announcement
  Future<String?> deleteAnnouncement(String announcementId) async {
    try {
      // Pobieramy dokument ogłoszenia
      DocumentReference announcementRef = announcements.doc(announcementId);

      // Pobranie danych ogłoszenia, aby usunąć obraz ze Storage, jeśli istnieje
      DocumentSnapshot documentSnapshot = await announcementRef.get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        // Usuwanie obrazu z Firebase Storage
        if (data.containsKey('image') &&
            data['image'] != null &&
            data['image'].isNotEmpty) {
          String imageUrl = data['image'];

          // Referencja do pliku w Storage
          try {
            final Reference storageRef =
                FirebaseStorage.instance.refFromURL(imageUrl);
            await storageRef.delete();
          } catch (e) {
            print("Error deleting image from storage: $e");
          }
        }

        // Usuwanie dokumentu ogłoszenia z Firestore
        await announcementRef.delete();
        return null; // Sukces
      } else {
        return 'Announcement not found';
      }
    } catch (e) {
      print("Error deleting announcement: $e");
      return 'Error deleting announcement';
    }
  }

  //Filtrowanie po kaategorii
  Future<List<Announcement>> getAnnouncementsByCategory(String category) async {
    try {
      QuerySnapshot querySnapshot =
          await announcements.where('category', isEqualTo: category).get();

      return querySnapshot.docs
          .map((doc) => Announcement.fromFirestore(doc))
          .toList();
    } catch (e) {
      print("Error fetching announcements by category: $e");
      return [];
    }
  }
}
