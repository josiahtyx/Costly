// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'package:costlynew/auth/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

final db = FirebaseFirestore.instance;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: 'AIzaSyBBmSRHvuzxSh-TpSj-Jg0odaA_hPUA67U',
        authDomain: 'costly-c6d95.firebaseapp.com',
        databaseURL:
            'https://costly-c6d95-default-rtdb.europe-west1.firebasedatabase.app',
        projectId: 'costly-c6d95',
        storageBucket: 'costly-c6d95.appspot.com',
        messagingSenderId: '1027381358955',
        appId: '1:1027381358955:web:58955fd46003b455811c2e',
        measurementId: 'G-1HEG1VXEC8'),
  );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  runApp(MaterialApp(
    title: 'Costly - Insights on expenses!',
    theme: _buildTheme(Brightness.light),
    debugShowCheckedModeBanner: false,
    home: MainPage(),
  ));
}

ThemeData _buildTheme(brightness) {
  var baseTheme = ThemeData(brightness: brightness);

  return baseTheme.copyWith(textTheme: GoogleFonts.robotoTextTheme());
}
