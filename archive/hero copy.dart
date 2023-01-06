// ignore_for_file: prefer_const_constructors, file_names, unnecessary_import, unused_import, depend_on_referenced_packages, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:costlynew/widgets/sidebar.dart';

class HeroArea extends StatefulWidget {
  const HeroArea({super.key});

  @override
  State<HeroArea> createState() => _HeroAreaState();
}

class _HeroAreaState extends State<HeroArea> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(35.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(600),
                  child: Container(
                    width: 500,
                    height: 50,
                    color: Colors.white,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 30,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Search...",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(600),
                      child: Container(
                        width: 50,
                        height: 50,
                        color: Colors.white,
                        child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.notifications,
                              color: Color.fromARGB(255, 235, 118, 60),
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(600),
                      child: Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      'https://th.bing.com/th/id/R.a09e659b47c5d158d0fa329630f562e7?rik=83m7gjCjlfgEjQ&riu=http%3a%2f%2f2.bp.blogspot.com%2f-Co-AB_JQ-Ww%2fUUioCgzoYeI%2fAAAAAAAADBc%2fbCV6zW-o8FM%2fs1600%2fCute-Dog-10.jpg&ehk=gUyjT5yMeJpd55cPvpymdkBKNOCECtJdaLEKqwrfCbc%3d&risl=&pid=ImgRaw&r=0'),
                                  backgroundColor:
                                      Color.fromARGB(255, 235, 118, 60),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "John Smith",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                                SizedBox(
                                  width: 40,
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.arrow_drop_down_sharp,
                                      color: Color.fromARGB(255, 235, 118, 60),
                                    )),
                              ]),
                          width: 250,
                          height: 50,
                          color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 75,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50),
              child: Flex(
                direction: Axis.vertical,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'YOUR CPD THIS MONTH SO FAR : ',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '50,00€',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 235, 118, 60),
                          foregroundColor: Colors.white,
                          shape: StadiumBorder(),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          elevation: 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                            child: Text(
                              'More',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
