// ignore_for_file: prefer_const_constructors, unused_field, use_build_context_synchronously, avoid_print, prefer_interpolation_to_compose_strings, unnecessary_string_interpolations, deprecated_member_use

import 'package:costlynew/auth/main_page.dart';
import 'package:costlynew/data/data.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'deviceLayout.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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
  late Future<String> themeColor;
  Color pickerColor = Color.fromARGB(255, 239, 108, 0);
  Color currentColor = Color.fromARGB(255, 239, 108, 0);

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  Future changeProfilePic(String url) async {
    await db.collection('userData').doc(userID).update({'profilePicture': url});
  }

  Future changeProfileColor(String color) async {
    await db
        .collection('userData')
        .doc(userID)
        .update({'themeColor': '0x' + color});
  }

  Future forgotPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: user.email!,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Password reset email sent! Don\'t forget to check the spam folder!'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);

      if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wrong password entered.'),
          ),
        );
      }
      if (e.code == 'too-many-requests') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You have tried too often, try again later.'),
          ),
        );
      }
      if (e.code == 'missing-email') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No Email Address entered'),
          ),
        );
      }
      if (e.code == 'unknown') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wrong email or password entered, please try again.'),
          ),
        );
      }
      if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The email you entered is not valid.'),
          ),
        );
      }

      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('This user does not exist.'),
          ),
        );
      }
    }
  }

  Future<String> getProfilePicUrl() async {
    DocumentSnapshot snapshot =
        await db.collection('userData').doc(userID).get();
    String newURL = snapshot.get('profilePicture');
    // print('URL is ' + newURL);
    // url = newURL;
    return newURL;
  }

  @override
  void initState() {
    super.initState();
    profileURL = getProfilePicUrl();
    themeColor = getProfileColor();
  }

  @override
  void dispose() {
    _profilePicController.dispose();
    super.dispose();
  }

  Future changeUserName(String newUserName) async {
    await db.collection('userData').doc(userID).update(
      {'username': newUserName},
    );
  }

  Future<void> showColorPicker(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Pick a color!'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: pickerColor,
                onColorChanged: changeColor,
              ),
              // Use Material color picker:
              //
              // child: MaterialPicker(
              //   pickerColor: pickerColor,
              //   onColorChanged: changeColor,
              //   showLabel: true, // only on portrait mode
              // ),
              //
              // Use Block color picker:
              //
              // child: BlockPicker(
              //   pickerColor: currentColor,
              //   onColorChanged: changeColor,
              // ),
              //
              // child: MultipleChoiceBlockPicker(
              //   pickerColors: currentColors,
              //   onColorsChanged: changeColors,
              // ),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange[800], // background
                  onPrimary: Colors.white, // foreground
                ),
                child: Text('Reset'),
                onPressed: () async {
                  setState(() {
                    delColor(userID.toString());

                    // changeProfilePic(url);
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AccountPage()),
                  );
                  await Future.delayed(Duration(seconds: 1));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Color theme has been resetted.'),
                    ),
                  );
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey[600], // background
                  onPrimary: Colors.white, // foreground
                ),
                child: const Text('OK'),
                onPressed: () async {
                  setState(() => currentColor = pickerColor);
                  changeProfileColor(pickerColor.value.toRadixString(16));
                  await Future.delayed(Duration(seconds: 1));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AccountPage()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Theme color has been changed'),
                    ),
                  );
                },
              ),
            ],
          );
        });
  }

  Future<void> confirmDeleteTransactions(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
                style: TextStyle(fontWeight: FontWeight.w800),
                'DELETE ALL DATA'),
            content: Text(
                "Are you sure you want to delete all your account data and transactions? This action is irreversible"),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // background
                  onPrimary: Colors.white, // foreground
                ),
                child: Text('OK'),
                onPressed: () {
                  setState(() async {
                    await delAllData(userID.toString());
                    await Future.delayed(Duration(seconds: 1));
                    FirebaseAuth.instance.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MainPage()),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('All your data has been deleted.'),
                      ),
                    );

                    // changeProfilePic(url);
                  });
                },
              ),
            ],
          );
        });
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
              decoration: InputDecoration(hintText: "Insert image or .gif URL"),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.orange[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ) // Background color
                    ),
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

  Widget themeColorButton(String text) => FutureBuilder(
        future: themeColor,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ElevatedButton(
                style: ElevatedButton.styleFrom(
                    // shadowColor: Colors.white,
                    primary: Color(int.parse(snapshot.data.toString())),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ) // Background color
                    ),
                onPressed: () {
                  setState(() {
                    showColorPicker(context);
                  });
                },
                child: Text(text));
          } else {
            return ElevatedButton(
                style: ElevatedButton.styleFrom(
                    //shadowColor: Colors.white,
                    primary: currentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ) // Background color
                    ),
                onPressed: () {
                  setState(() {
                    showColorPicker(context);
                  });
                },
                child: Text(text));
          }
        },
      );

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
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1480) {
          return profileDesktop(context);
        } else {
          return profileMobile(context);
        }
      },
    );
  }

  @override
  Widget profileDesktop(BuildContext context) {
    final device = MediaQuery.of(context).size;
    return FutureBuilder(
      future: themeColor,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            backgroundColor: Color(int.parse(snapshot.data.toString())),
            // appBar: AppBar(
            //   title: Text('Profile Page'),
            //   backgroundColor: Colors.black,
            //   automaticallyImplyLeading: false,
            // ),
            body: Center(
              child: SingleChildScrollView(
                child: Container(
                  height: device.height * 0.85,
                  width: device.width * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 30,
                        offset: Offset(0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon:
                                  const Icon(Icons.arrow_back_ios_new_rounded),
                              tooltip: 'Back',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()),
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
                          ],
                        ),
                        SizedBox(
                          height: 150,
                        ),
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
                            '${user.email!}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        themeColorButton("Change Color Theme"),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.orange[800],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ) // Background color
                                ),
                            onPressed: (() {
                              forgotPassword();
                            }),
                            child: Text('Change Password')),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.orange[800],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ) // Background color
                                ),
                            onPressed: (() {
                              confirmDeleteTransactions(context);
                            }),
                            child: Text('Delete All Data')),
                        SizedBox(
                          height: 10,
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
                            child: Text('Log Out')),

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
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            // appBar: AppBar(
            //   title: Text('Profile Page'),
            //   backgroundColor: Colors.black,
            //   automaticallyImplyLeading: false,
            // ),
            body: Center(
              child: SingleChildScrollView(
                child: Container(
                  height: device.height * 0.85,
                  width: device.width * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 30,
                        offset: Offset(0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon:
                                  const Icon(Icons.arrow_back_ios_new_rounded),
                              tooltip: 'Back',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()),
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
                          ],
                        ),
                        SizedBox(
                          height: 150,
                        ),
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
                            '${user.email!}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        themeColorButton("Change Color Theme"),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.orange[800],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ) // Background color
                                ),
                            onPressed: (() {
                              forgotPassword();
                            }),
                            child: Text('Change Password')),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.orange[800],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ) // Background color
                                ),
                            onPressed: (() {
                              confirmDeleteTransactions(context);
                            }),
                            child: Text('Delete All Data')),
                        SizedBox(
                          height: 10,
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
                            child: Text('Log Out')),

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
                ),
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget profileMobile(BuildContext context) {
    final device = MediaQuery.of(context).size;
    return FutureBuilder(
      future: themeColor,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
              backgroundColor: Color(int.parse(snapshot.data.toString())),
              // appBar: AppBar(
              //   title: Text('Profile Page'),
              //   backgroundColor: Colors.black,
              //   automaticallyImplyLeading: false,
              // ),
              body: Center(
                child: SingleChildScrollView(
                  child: Container(
                    height: device.height * 0.85,
                    width: device.width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 30,
                          offset: Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: device.width * 0.05,
                                  child: IconButton(
                                    icon: const Icon(
                                        Icons.arrow_back_ios_new_rounded),
                                    tooltip: 'Back',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomePage()),
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 45),
                                  child: Text(
                                    'Profile Page',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: device.width * 0.06,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: device.height * 0.06,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
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
                                      '${user.email!}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: device.width * 0.05,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  themeColorButton("Change Color Theme"),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.orange[800],
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ) // Background color
                                          ),
                                      onPressed: (() {
                                        forgotPassword();
                                      }),
                                      child: Text('Change Password')),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.orange[800],
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ) // Background color
                                          ),
                                      onPressed: (() {
                                        confirmDeleteTransactions(context);
                                      }),
                                      child: Text('Delete All Data')),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.orange[800],
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ) // Background color
                                          ),
                                      onPressed: (() async {
                                        FirebaseAuth.instance.signOut();
                                        await DefaultCacheManager()
                                            .emptyCache();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MainPage()),
                                        );
                                      }),
                                      child: Text('Log Out')),

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
                                  // ),],)
                                ],
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
              ));
        } else {
          return Scaffold(
              //backgroundColor: Color(int.parse(snapshot.data.toString())),
              // appBar: AppBar(
              //   title: Text('Profile Page'),
              //   backgroundColor: Colors.black,
              //   automaticallyImplyLeading: false,
              // ),
              body: Center(
            child: SingleChildScrollView(
              child: Container(
                height: device.height * 0.85,
                width: device.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 30,
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: device.width * 0.05,
                              child: IconButton(
                                icon: const Icon(
                                    Icons.arrow_back_ios_new_rounded),
                                tooltip: 'Back',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const HomePage()),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 45),
                              child: Text(
                                'Profile Page',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: device.width * 0.06,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: device.height * 0.06,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
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
                                  '${user.email!}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: device.width * 0.05,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              themeColorButton("Change Color Theme"),
                              SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.orange[800],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ) // Background color
                                      ),
                                  onPressed: (() {
                                    forgotPassword();
                                  }),
                                  child: Text('Change Password')),
                              SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.orange[800],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ) // Background color
                                      ),
                                  onPressed: (() {
                                    confirmDeleteTransactions(context);
                                  }),
                                  child: Text('Delete All Data')),
                              SizedBox(
                                height: 10,
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
                                          builder: (context) =>
                                              const MainPage()),
                                    );
                                  }),
                                  child: Text('Log Out')),

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
                              // ),],)
                            ],
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          ));
        }
      },
    );
  }
}
