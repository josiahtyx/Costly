import 'package:costlynew/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:costlynew/data/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

var funcCPD = GetCPDTotal();
var funcSpent = GetTotalSpent();

class CPDArea extends StatefulWidget {
  const CPDArea({Key? key}) : super(key: key);

  @override
  State<CPDArea> createState() => _CPDAreaState();
}

class _CPDAreaState extends State<CPDArea> {
  late Future<double> totalCPD;
  late Future<double> totalSpent;
  DateTime dateNow = DateTime.now();
  DateTime firstDay = DateTime(DateTime.now().year, DateTime.now().month, 1);
  late int daysBetween;
  final userID = FirebaseAuth.instance.currentUser?.uid;
  final db = FirebaseFirestore.instance;
  late Future<String> profileURL;
  late Future<String> themeColor;
  int GetDaysDifference() {
    int dateDifference = ((DateTime.now().difference(firstDay).inDays) + 1);
    // print(dateDifference);
    daysBetween = dateDifference;
    return dateDifference;
  }

  // String calculateCPD(data) {
  //   double receivedData = data;
  //   String cpdAmount = (receivedData / daysBetween).toStringAsFixed(2);
  //   return cpdAmount;
  // }

  String calculateCPD(data) {
    double receivedData = data;
    //CPD (amount/days in the month)
    int days = daysInMonth();
    String cpdAmount = (receivedData / days).toStringAsFixed(2);
    return cpdAmount;
  }

  Future<void> _handleRefresh() async {
    await totalSpent;
    await totalCPD;
  }

  late bool _isLoading;
  void wait() async {
    _isLoading = true;
    GetDaysDifference();
    //This part needs to be updated to be manual or something
    funcCPD.getCPDtotal();
    totalCPD = funcCPD.getCPDtotal();
    funcSpent.getTotalSpent();
    totalSpent = funcSpent.getTotalSpent();
    // getCPDtotal();
    // totalCPD = getCPDtotal();
    // Future.delayed(const Duration(seconds: 0), () {
    //   setState(() {
    //     _isLoading = false;
    //   }); // Prints after 1 second.
    // });
  }

  Future<String> getProfilePicUrl() async {
    DocumentSnapshot snapshot =
        await db.collection('userData').doc(userID).get();
    String newURL = snapshot.get('profilePicture');
    //print('URL is ' + newURL);
    // url = newURL;
    return newURL;
  }

  Future<String> getProfileColor() async {
    DocumentSnapshot snapshot =
        await db.collection('userData').doc(userID).get();
    String theme = snapshot.get('themeColor');
    //print('URL is ' + newURL);
    // url = newURL;
    return theme;
  }

  @override
  void initState() {
    super.initState();
    wait();
    profileURL = getProfilePicUrl();
    themeColor = getProfileColor();
  }

  Widget buildHeroAreaMobile() => FutureBuilder(
        future: themeColor,
        builder: (context, snapshot) {
          final device = MediaQuery.of(context).size;
          if (snapshot.hasData) {
            return Container(
              decoration: BoxDecoration(
                color: Color(int.parse(snapshot.data.toString())),
                image: DecorationImage(
                  image: AssetImage('assets/images/waves.png'),
                  //colorFilter: ColorFilter.mode(Colors.white, BlendMode.screen),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 20, 40, 40),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      // FutureBuilder(
                      //   future: totalSpent,
                      //   builder: (context, snapshot) {
                      //     if (snapshot.hasData) {
                      //       return Text(
                      //         'Total expenses: ${snapshot.data}€',
                      //         textAlign: TextAlign.center,
                      //         style: TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 30,
                      //           fontWeight: FontWeight.w400,
                      //         ),
                      //       );
                      //     } else {
                      //       return Text(
                      //         '0,00€',
                      //         style: TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 30,
                      //           fontWeight: FontWeight.w400,
                      //         ),
                      //       );
                      //     }
                      //   },
                      // ),
                      FutureBuilder(
                        future: totalSpent,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: [
                                Text(
                                  'Your CPD in $month:',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  ('${calculateCPD(snapshot.data).replaceAll(RegExp(r'\.'), ',')}€'),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            );
                          } else {
                            //put loading here
                            return Text(
                              'Your CPD in $month: \n0,00€',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w400,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Container(
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: AssetImage('assets/images/waves.png'),
                  //colorFilter: ColorFilter.mode(Colors.white, BlendMode.screen),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 20, 40, 40),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      // FutureBuilder(
                      //   future: totalSpent,
                      //   builder: (context, snapshot) {
                      //     if (snapshot.hasData) {
                      //       return Text(
                      //         'Total expenses: ${snapshot.data}€',
                      //         textAlign: TextAlign.center,
                      //         style: TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 30,
                      //           fontWeight: FontWeight.w400,
                      //         ),
                      //       );
                      //     } else {
                      //       return Text(
                      //         '0,00€',
                      //         style: TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 30,
                      //           fontWeight: FontWeight.w400,
                      //         ),
                      //       );
                      //     }
                      //   },
                      // ),
                      FutureBuilder(
                        future: totalSpent,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: [
                                Text(
                                  'Your CPD in $month:',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  ('${calculateCPD(snapshot.data).replaceAll(RegExp(r'\.'), ',')}€'),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            );
                          } else {
                            //put loading here
                            return Text(
                              'Your CPD in $month: \n0,00€',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w400,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      );

  @override
  Widget build(BuildContext context) {
    return buildHeroAreaMobile();
  }
}
