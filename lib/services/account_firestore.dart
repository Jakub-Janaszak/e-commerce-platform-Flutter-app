import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LoginResult {
  final String message;
  final bool success;

  LoginResult(this.message, this.success);
}

class AccountService {
  //get collection
  final CollectionReference accounts =
      FirebaseFirestore.instance.collection('accounts');

  //Create
  Future<String?> addAccount(
      String login, String email, String password) async {
    if (login.isEmpty || email.isEmpty || password.isEmpty) {
      return 'Enter all data.';
    }

    // Sprawdzenie istnienia loginu
    DocumentSnapshot loginSnapshot = await accounts.doc(login).get();
    if (loginSnapshot.exists) {
      return 'Login already exists';
    }

    // Sprawdzenie istnienia e-maila
    QuerySnapshot emailSnapshot =
        await accounts.where('email', isEqualTo: email).get();
    if (emailSnapshot.docs.isNotEmpty) {
      return 'Email already exists';
    }

    // Dodanie nowego konta
    await accounts.doc(login).set({
      'login': login,
      'email': email,
      'password': password,
      'timestamp': Timestamp.now()
    });
    return null;
  }

  Future<LoginResult> login(String login, String password) async {
    if (login.isEmpty || password.isEmpty) {
      return LoginResult('Enter all data.', false);
    }

    var loginUser = await accounts
        .where('login', isEqualTo: login)
        .where('password', isEqualTo: password)
        .get();

    if (loginUser.docs.isNotEmpty) {
      return LoginResult('Login successful', true);
    } else {
      return LoginResult('Invalid login or password', false);
    }
  }
}
