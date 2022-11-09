// ignore_for_file: use_build_context_synchronously

import 'package:costlynew/auth/mainpage.dart';
import 'package:costlynew/pages/accountpage.dart';
import 'package:costlynew/pages/cpdcalculatorpage.dart';
import 'package:costlynew/pages/homepage.dart';
import 'package:costlynew/pages/totalexpensespage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

final costlyLogo = Image(image: AssetImage('assets/icons/costlylogo.png'));

final homeLogoActive = Image(
  image: AssetImage('assets/icons/home.png'),
  color: Color.fromARGB(255, 235, 118, 60),
);

final calculatorLogo = Image(image: AssetImage('assets/icons/calculator.png'));
final expensesLogo = Image(image: AssetImage('assets/icons/folder.png'));
final settingsLogo = Image(image: AssetImage('assets/icons/settings.png'));
final logoutLogo = Image(image: AssetImage('assets/icons/logout.png'));

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 255, 255, 255),
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 65, 45, 65),
            child: costlyLogo,
          ),
          Padding(
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
                          child: homeLogoActive,
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
          SizedBox(
            height: 200,
          ),
        ]),
      ),
    );
  }
}
