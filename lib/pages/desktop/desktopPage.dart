// ignore_for_file: file_names, prefer_const_constructors, duplicate_ignore, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:costlynew/pages/homepage.dart';
import 'package:costlynew/widgets/assets.dart';
import 'package:costlynew/widgets/monthlyexpenses.dart';
import 'package:costlynew/widgets/hero.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:costlynew/widgets/sidebar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DesktopPage extends StatefulWidget {
  const DesktopPage({Key? key}) : super(key: key);

  @override
  State<DesktopPage> createState() => _DesktopPageState();
}

class _DesktopPageState extends State<DesktopPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: [
        //Sidebar
        // ignore: prefer_const_constructors
        Expanded(
          flex: 1,
          child: SideBar(),
        ),
        //Right Side From Here//
        Expanded(
          flex: 6,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //Hero, TopBar
                Container(
                  child: Expanded(
                    flex: 2,
                    child: HeroArea(),
                  ),
                ),

                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      //Expenses Area
                      Expanded(
                        flex: 3,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: TransactionsArea(),
                          ),
                        ),
                      ),
                      //Assets, Save Goal Area
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AssetsArea(),
                                //GoalArea(),
                              ]),
                          color: Colors.orange[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
