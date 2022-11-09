// ignore_for_file: prefer_const_constructors
import 'package:costlynew/pages/accountpage.dart';
import 'package:costlynew/pages/totalexpensespage.dart';
import 'package:costlynew/widgets/CPDAreaMonthlyDesktop.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HeroArea extends StatefulWidget {
  const HeroArea({super.key});

  @override
  State<HeroArea> createState() => _HeroAreaState();
}

class _HeroAreaState extends State<HeroArea> {
  final user = FirebaseAuth.instance.currentUser!;
  final userID = FirebaseAuth.instance.currentUser?.uid;
  final db = FirebaseFirestore.instance;
  final double profileHeight = 144;

  late Future<String> profileURL;

  Future<String> getProfilePicUrl() async {
    DocumentSnapshot snapshot =
        await db.collection('userData').doc(userID).get();
    String newURL = snapshot.get('profilePicture');
    //print('URL is ' + newURL);
    // url = newURL;
    return newURL;
  }

  Widget buildProfileImage() => FutureBuilder(
        future: profileURL,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //print(snapshot.data);
            return GestureDetector(
              child: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(snapshot.data.toString()),
              ),
            );
          } else {
            return GestureDetector(
              child: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(
                    'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__480.png'),
              ),
            );
          }
        },
      );
  @override
  void initState() {
    profileURL = getProfilePicUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 900,
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(35.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //TODO SEARCH FUNCTION

                // ClipRRect(
                //   borderRadius: BorderRadius.circular(600),
                //   child: Container(
                //     width: 500,
                //     height: 50,
                //     color: Colors.white,
                //     child: Row(
                //       children: const [
                //         SizedBox(
                //           width: 30,
                //         ),
                //         Align(
                //           alignment: Alignment.centerLeft,
                //           child: Text(
                //             'Search...',
                //             style: TextStyle(
                //               fontSize: 20,
                //               fontWeight: FontWeight.w500,
                //               color: Colors.grey,
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),

                Row(
                  children: [
                    // ClipRRect(
                    //   borderRadius: BorderRadius.circular(600),
                    //   child: Container(
                    //     width: 50,
                    //     height: 50,
                    //     color: Colors.white,
                    //     child: IconButton(
                    //         onPressed: () {},
                    //         icon: Icon(
                    //           Icons.notifications,
                    //           color: Color.fromARGB(255, 235, 118, 60),
                    //         )),
                    //   ),
                    // ),
                    SizedBox(
                      width: 25,
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: (() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AccountPage()),
                          );
                        }),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(600),
                          child: Container(
                              height: 50,
                              color: Colors.white,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    buildProfileImage(),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      user.email!,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 40,
                                    ),
                                    // IconButton(
                                    //     onPressed: () {},
                                    //     icon: Icon(
                                    //       Icons.arrow_drop_down_sharp,
                                    //       color:
                                    //           Color.fromARGB(255, 235, 118, 60),
                                    //     )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ])),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50, top: 60),
              child: Flex(
                direction: Axis.vertical,
                children: [
                  CPDArea(),
                  SizedBox(
                    height: 15,
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
