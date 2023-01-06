// ignore_for_file: use_build_context_synchronously

import 'package:costlynew/auth/main_page.dart';
import 'package:costlynew/data/data.dart';
import 'package:costlynew/pages/dateExpenses.dart';
import 'package:costlynew/pages/plannedPurchases.dart';
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
final costlyLogoBlack =
    Image(image: AssetImage('assets/icons/costlylogoblack.png'));
final piggybankGrey =
    Image(image: AssetImage('assets/images/piggybankgrey.png'));
final userID = FirebaseAuth.instance.currentUser?.uid;

final db = FirebaseFirestore.instance;
final calendarLogo = Image(image: AssetImage('assets/icons/calendar.png'));
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

  Widget showLogo() => FutureBuilder(
      future: themeColor,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data.toString());
          return ColorFiltered(
              colorFilter: ColorFilter.mode(
                  Color(int.parse(snapshot.data.toString())),
                  BlendMode.srcATop),
              child: costlyLogoBlack);
        } else {
          return costlyLogo;
        }
      }));

  Widget showPig() => FutureBuilder(
      future: themeColor,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data.toString());
          return piggybankGrey;
        } else {
          return piggybank;
        }
      }));

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
            child: showLogo(),
          ),
          colorButton(),

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
                            child: calendarLogo,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Calendar'),
                      SizedBox(
                        width: 55,
                      ),
                    ],
                  ),
                ),
                onPressed: () async {
                  pickedDate = await showDatePicker(
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: Colors.orange, // header background color
                              onPrimary: Colors.white, // header text color
                              onSurface: Colors.black, // body text color
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                primary: Colors.black, // button text color
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate:
                          DateTime(2000), //Not to allow to choose before today.
                      lastDate: DateTime(2200));
                  if (pickedDate != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DateExpenses()),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  }
                }),
          ),
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
                    Text('Plans'),
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
                      builder: (context) => const PlannedPurchases()),
                );
              },
            ),
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
              child: showPig(),
            ),
          ),
        ]),
      ),
    );
  }
}
