import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_shop/firebase_options.dart';
import 'package:project_shop/screens/login_screen.dart';
import 'package:project_shop/screens/register_screen.dart';
import 'package:project_shop/screens/announcements_screen.dart';
import 'package:project_shop/main_page.dart';
import 'package:project_shop/UI_elements/announcement_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MaterialApp(
      home: LoginScreen(),
    ),
  );
}
