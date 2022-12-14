// ignore_for_file: use_build_context_synchronously

import 'package:costlynew/auth/main_page.dart';
import 'package:costlynew/pages/profile.dart';
import 'package:costlynew/pages/calculatorCPD.dart';
import 'package:costlynew/pages/deviceLayout.dart';
import 'package:costlynew/pages/allTimeExpenses.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final costlyLogo = Image(image: AssetImage('assets/icons/costlylogo.png'));
final piggybank = Image(image: AssetImage('assets/images/piggybank.png'));
final userID = FirebaseAuth.instance.currentUser?.uid;

final db = FirebaseFirestore.instance;
final calculatorLogo = Image(image: AssetImage('assets/icons/calculator.png'));
final expensesLogo = Image(image: AssetImage('assets/icons/folder.png'));
final settingsLogo = Image(image: AssetImage('assets/icons/settings.png'));
final logoutLogo = Image(image: AssetImage('assets/icons/logout.png'));
late Future<String> themeColor;

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  void initState() {
    super.initState();
    themeColor = getProfileColor();
  }

  Future<String> getProfileColor() async {
    DocumentSnapshot snapshot =
        await db.collection('userData').doc(userID).get();
    String color = snapshot.get('themeColor');
    //print('URL is ' + newURL);
    // url = newURL;
    return color;
  }

  Widget colorButton() => FutureBuilder(
        future: themeColor,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(int.parse(snapshot.data.toString())),
                  foregroundColor: Colors.white,
                  shape: StadiumBorder(),
                  padding: const EdgeInsets.all(0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(600),
                        child: Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image(
                              image: AssetImage('assets/icons/home.png'),
                              color: Color(int.parse(snapshot.data.toString())),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Home'),
                      SizedBox(
                        width: 80,
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 235, 118, 60),
                  foregroundColor: Colors.white,
                  shape: StadiumBorder(),
                  padding: const EdgeInsets.all(0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(600),
                        child: Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image(
                              image: AssetImage('assets/icons/home.png'),
                              color: Color.fromARGB(255, 235, 118, 60),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Home'),
                      SizedBox(
                        width: 80,
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
              ),
            );
          }
        },
      );

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    return Container(
      color: Color.fromARGB(255, 255, 255, 255),
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 65, 45, 65),
            child: costlyLogo,
          ),
          colorButton(),
          //Calculator Button
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  foregroundColor: Color.fromARGB(255, 171, 181, 186),
                  shape: StadiumBorder(),
                  padding: const EdgeInsets.all(0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  elevation: 0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(600),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: calculatorLogo,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Calculators'),
                    SizedBox(
                      width: 45,
                    ),
                  ],
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CPDCalculator()),
                );
              },
            ),
          ),
          //Expenses
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    foregroundColor: Color.fromARGB(255, 171, 181, 186),
                    shape: StadiumBorder(),
                    padding: const EdgeInsets.all(0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    elevation: 0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(600),
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: expensesLogo,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Expenses'),
                      SizedBox(
                        width: 55,
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TotalExpensesPage()),
                  );
                }),
          ),
          //Settings
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  foregroundColor: Color.fromARGB(255, 171, 181, 186),
                  shape: StadiumBorder(),
                  padding: const EdgeInsets.all(0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  elevation: 0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(600),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: settingsLogo,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Settings'),
                    SizedBox(
                      width: 65,
                    ),
                  ],
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AccountPage()),
                );
              },
            ),
          ),
          //Logout
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  foregroundColor: Color.fromARGB(255, 171, 181, 186),
                  shape: StadiumBorder(),
                  padding: const EdgeInsets.all(0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  elevation: 0),
              onPressed: (() async {
                FirebaseAuth.instance.signOut();
                await DefaultCacheManager().emptyCache();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage()),
                );
              }),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(600),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: logoutLogo,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Log Out'),
                    SizedBox(
                      width: 65,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Spacer(),
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20.0, 30),
              child: piggybank,
            ),
          ),
        ]),
      ),
    );
  }
}
