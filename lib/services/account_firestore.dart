import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_shop/services/encryption_service.dart';

class Account {
  final String id;
  final String login;
  final String email;
  final String password;
  final String phoneNumber;
  final Timestamp timestamp;

  Account({
    required this.id,
    required this.login,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.timestamp,
  });

  // Tworzenie obiektu z mapy (np. z Firestore)
  factory Account.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = (doc.data() as Map<String, dynamic>? ?? {});
    return Account(
      id: doc.id, // Pobranie ID z dokumentu
      login: data['login'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  // Zamiana obiektu na mapę (np. przy dodawaniu do Firestore)
  Map<String, dynamic> toMap() {
    return {
      'login': login,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'timestamp': timestamp,
    };
  }
}

class LoginResult {
  final String message;
  final bool success;

  LoginResult(this.message, this.success);
}

class AccountService {
  // Kolekcja
  final CollectionReference accounts =
      FirebaseFirestore.instance.collection('accounts');

  final String encryptionKey = "SecureEncryptionKey-happy-573410";
  final String iv = "IV-ok-7845172345";

  // Dodawanie konta
  Future<String?> addAccount(
      String login, String email, String password, String phoneNumber) async {
    if (login.isEmpty || email.isEmpty || password.isEmpty) {
      return 'Enter all data.';
    }

    // Sprawdzenie istnienia loginu
    QuerySnapshot loginSnapshot =
        await accounts.where('login', isEqualTo: login).get();
    if (loginSnapshot.docs.isNotEmpty) {
      return 'Login already exists';
    }

    // Sprawdzenie istnienia e-maila
    QuerySnapshot emailSnapshot =
        await accounts.where('email', isEqualTo: email).get();
    if (emailSnapshot.docs.isNotEmpty) {
      return 'Email already exists';
    }

    // Sprawdzenie istnienia numeru telefonu
    QuerySnapshot phoneSnapshot =
        await accounts.where('phoneNumber', isEqualTo: phoneNumber).get();
    if (phoneSnapshot.docs.isNotEmpty) {
      return 'Phone number already exists';
    }

    // Generowanie unikalnego ID
    String id = accounts.doc().id;

    // Szyfrowanie hasła przed zapisaniem
    EncryptionService encryptionService = EncryptionService(encryptionKey, iv);
    String encryptedPassword = encryptionService.encrypt(password);

    // Dodanie nowego konta
    Account newAccount = Account(
      id: id,
      login: login,
      email: email,
      password: encryptedPassword,
      phoneNumber: phoneNumber,
      timestamp: Timestamp.now(),
    );

    await accounts.doc(id).set(newAccount.toMap());
    return null;
  }

  // Logowanie
  Future<LoginResult> login(String login, String password) async {
    if (login.isEmpty || password.isEmpty) {
      return LoginResult('Enter all data.', false);
    }

    QuerySnapshot loginUser =
        await accounts.where('login', isEqualTo: login).get();

    if (loginUser.docs.isNotEmpty) {
      DocumentSnapshot userDoc = loginUser.docs.first;

      // Pobranie zaszyfrowanego hasła z Firestore
      String encryptedPassword = userDoc['password'];

      // Deszyfrowanie hasła przed porównaniem
      EncryptionService encryptionService =
          EncryptionService(encryptionKey, iv);
      String decryptedPassword = encryptionService.decrypt(encryptedPassword);

      // Porównanie hasła
      if (decryptedPassword == password) {
        return LoginResult('Login successful', true);
      } else {
        return LoginResult('Invalid login or password', false);
      }
    } else {
      return LoginResult('Invalid login or password', false);
    }
  }

  // Pobieranie konta po ID
  Future<Account?> getAccountById(String id) async {
    try {
      DocumentSnapshot doc = await accounts.doc(id).get();
      if (doc.exists) {
        return Account.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting account: $e');
      return null;
    }
  }

  // Pobieranie konta po loginie
  Future<Account?> getAccountByLogin(String login) async {
    try {
      // Wyszukiwanie konta po loginie
      QuerySnapshot querySnapshot =
          await accounts.where('login', isEqualTo: login).get();

      // Jeśli znaleziono dokumenty
      if (querySnapshot.docs.isNotEmpty) {
        // Zwrócenie pierwszego dokumentu (zakładając, że login jest unikalny)
        DocumentSnapshot doc = querySnapshot.docs.first;
        return Account.fromFirestore(doc); // Zwracamy obiekt Account
      }
      return null; // Jeśli nie znaleziono, zwróć null
    } catch (e) {
      print('Error getting account by login: $e');
      return null;
    }
  }

  // Usuwanie konta po ID
  Future<bool> deleteAccount(String accountId) async {
    try {
      // Usunięcie dokumentu konta z kolekcji
      await accounts.doc(accountId).delete();
      print('Account $accountId deleted successfully');
      return true;
    } catch (e) {
      print('Error deleting account: $e');
      return false;
    }
  }
}
