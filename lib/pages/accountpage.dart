// ignore_for_file: prefer_const_constructors

import 'package:costly/auth/main_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final db = FirebaseFirestore.instance;
  final userID = FirebaseAuth.instance.currentUser?.uid;
  final _userNameController = TextEditingController();
  final _profilePicController = TextEditingController();
  final double profileHeight = 144;
// String url = 'https://c.tenor.com/a9CamLQyQg0AAAAM/music-bussin.gif';
  String url =
      'https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg';
  late String urlText;
  late Future<String> profileURL;

  Future changeProfilePic(String url) async {
    await db.collection('userData').doc(userID).update({'profilePicture': url});
  }

  Future<String> getProfilePicUrl() async {
    DocumentSnapshot snapshot =
        await db.collection('userData').doc(userID).get();
    String newURL = snapshot.get('profilePicture');
    print('URL is ' + newURL);
    // url = newURL;
    return newURL;
  }

  @override
  void initState() {
    profileURL = getProfilePicUrl();
    super.initState();
  }

  @override
  void dispose() {
    _profilePicController.dispose();
    super.dispose();
  }

  Future<void> delUser() async {
    user;
    db.collection("userData").doc(userID).delete();
    user.delete();
  }

  Future changeUserName(String newUserName) async {
    await db.collection('userData').doc(userID).update(
      {'username': newUserName},
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Change Profile Picture'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  urlText = value;
                });
              },
              controller: _profilePicController,
              decoration: InputDecoration(hintText: "Insert image or gif URL"),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.orange,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    url = urlText;
                    changeProfilePic(url);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AccountPage()),
                    );
                    // changeProfilePic(url);
                  });
                },
              ),
            ],
          );
        });
  }

  Widget buildProfileImage(urlNew) => FutureBuilder(
        future: profileURL,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            return GestureDetector(
              child: CircleAvatar(
                radius: profileHeight / 2,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(snapshot.data.toString()),
              ),
            );
          } else {
            return GestureDetector(
              child: CircleAvatar(
                radius: profileHeight / 2,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(url),
              ),
            );
          }
        },
      );

  // Widget buildProfileImage(urlNew) => GestureDetector(
  //       child: CircleAvatar(
  //         radius: profileHeight / 2,
  //         backgroundColor: Colors.white,
  //         backgroundImage: NetworkImage(urlNew),
  //       ),
  //     );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Profile Page'),
      //   backgroundColor: Colors.black,
      //   automaticallyImplyLeading: false,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  tooltip: 'Back',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 35.0),
                  child: Text(
                    'Profile Page',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                // Text(
                //   'View All',
                //   style: GoogleFonts.nunito(
                //     textStyle: TextStyle(
                //       color: Colors.black,
                //       fontSize: 10.95,
                //       fontWeight: FontWeight.w600,
                //     ),
                //   ),
                // ),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => const AddExpensesPage()),
                //     );
                //   },
                //   child: Text('Add'),
                //   style: ElevatedButton.styleFrom(
                //       primary: Colors.orange[800],
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(15),
                //       ) // Background color
                //       ),
                // )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 150.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      _displayTextInputDialog(context);
                    },
                    child: buildProfileImage(url),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      'Signed in as: ${user.email!}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.orange[800],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ) // Background color
                          ),
                      onPressed: (() async {
                        FirebaseAuth.instance.signOut();
                        await DefaultCacheManager().emptyCache();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainPage()),
                        );
                      }),
                      child: Text('Sign Out')),

                  //delete account
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 10),
                  //   child: ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //           primary: Colors.red[800],
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(15),
                  //           ) // Background color
                  //           ),
                  //       onPressed: (() async {
                  //         delUser();
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(builder: (context) => const MainPage()),
                  //         );
                  //       }),
                  //       child: Text('Delete Account')),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
