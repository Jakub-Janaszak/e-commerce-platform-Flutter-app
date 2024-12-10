import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_shop/services/encryption_service';

class AdminDeletedAnnouncement {
  final String id;
  final String removerId;
  final String ownerId;
  final String announcementTitle;
  final String reason;
  final Timestamp timestamp;

  AdminDeletedAnnouncement({
    required this.id,
    required this.removerId,
    required this.ownerId,
    required this.announcementTitle,
    required this.reason,
    required this.timestamp,
  });

  // Tworzenie obiektu z mapy (np. z Firestore)
  factory AdminDeletedAnnouncement.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = (doc.data() as Map<String, dynamic>? ?? {});
    return AdminDeletedAnnouncement(
      id: doc.id, // Pobranie ID z dokumentu
      removerId: data['removerId'] ?? '',
      ownerId: data['ownerId'] ?? '',
      announcementTitle: data['announcementTitle'] ?? '',
      reason: data['reason'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  // Zamiana obiektu na mapę (np. przy dodawaniu do Firestore)
  Map<String, dynamic> toMap() {
    return {
      'removerId': removerId,
      'ownerId': ownerId,
      'announcementTitle': announcementTitle,
      'reason': reason,
      'timestamp': timestamp,
    };
  }
}

class LoginResult {
  final String message;
  final bool success;

  LoginResult(this.message, this.success);
}

class AdminDeletedAnnouncementsService {
  // Kolekcja
  final CollectionReference deletedAnnouncements =
      FirebaseFirestore.instance.collection('admin_removed_announcements');

  // Dodawanie usunięte ogłoszenie
  Future<String?> addAdminDeletedAnnouncement(String removerId, String ownerId,
      String announcementTitle, String reason) async {
    // Generowanie unikalnego ID
    String id = deletedAnnouncements.doc().id;

    // Dodanie nowe ogłoszenie
    AdminDeletedAnnouncement newRemovedAnnouncement = AdminDeletedAnnouncement(
      id: id,
      removerId: removerId,
      ownerId: ownerId,
      announcementTitle: announcementTitle,
      reason: reason,
      timestamp: Timestamp.now(),
    );

    await deletedAnnouncements.doc(id).set(newRemovedAnnouncement.toMap());
    return null;
  }

  //Pobierz wszystkie usuniete ogłoszenia dla użytkownika o danym id
  Future<List<AdminDeletedAnnouncement>> getAllAnnouncementsByOwnerId(
      String ownerId) async {
    try {
      QuerySnapshot querySnapshot = await deletedAnnouncements
          .where('ownerId', isEqualTo: ownerId)
          .orderBy('timestamp',
              descending:
                  true) //firebase musiało zrobić indekksy, żeby szybciej działało to zapytanie z sortowaniem i filtrowaniem
          .get();

      return querySnapshot.docs
          .map((doc) => AdminDeletedAnnouncement.fromFirestore(doc))
          .toList();
    } catch (e) {
      print("Error fetching deleted announcements by owner ID: $e");
      return [];
    }
  }
}
