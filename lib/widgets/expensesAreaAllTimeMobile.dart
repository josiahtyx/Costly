// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:costlynew/pages/calculatorCPD.dart';
import 'package:costlynew/pages/newExpenses.dart';
import 'package:costlynew/pages/deviceLayout.dart';
import 'package:costlynew/widgets/expensesTable.dart';
import 'package:costlynew/widgets/expensesTableMobile.dart';
import 'package:costlynew/widgets/expensesTableYearlyMobile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:costlynew/data/data.dart';
import 'package:loading_indicator/loading_indicator.dart';

var funcGetYear = new GetTransactionsYearly();

class TransactionsAreaYearlyMobile extends StatefulWidget {
  const TransactionsAreaYearlyMobile({Key? key}) : super(key: key);

  @override
  State<TransactionsAreaYearlyMobile> createState() =>
      _TransactionsAreaYearlyMobileState();
}

class _TransactionsAreaYearlyMobileState
    extends State<TransactionsAreaYearlyMobile> {
  final user = FirebaseAuth.instance.currentUser!;
  final db = FirebaseFirestore.instance;
  final year = (DateFormat('y').format(DateTime.now())).toString();
  final monthYear = (DateFormat('MMMM y').format(DateTime.now())).toString();
  final userID = FirebaseAuth.instance.currentUser?.uid;
  final _transactionName = TextEditingController();
  int listLength = 1;
  late Future<String> themeColor;

  late String transactionMY;
  callBackMY(String transactionMY) {
    this.transactionMY = transactionMY;
  }

  Future<String> getProfileColor() async {
    DocumentSnapshot snapshot =
        await db.collection('userData').doc(userID).get();
    String color = snapshot.get('themeColor');
    //print('URL is ' + newURL);
    // url = newURL;
    return color;
  }

  late Future<List<dynamic>> transactionsDataYear;

  // Future<void> _handleRefresh() async {
  //   await userTransactions;
  // }

  @override
  void initState() {
    super.initState();
    themeColor = getProfileColor();
  }

  _loadData() async {
    await funcGetYear.getTransactions();
    transactionsDataYear = funcGetYear.getTransactions();
  }

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    return Container(
      width: device.width * 0.99,
      height: device.height * 0.725,
      child: Stack(children: [
        //Header of Expenses Table Widget
        Positioned(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 0), // changes position of shadow
                  ),
                ],
              ),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Expenses',
                          style: GoogleFonts.nunito(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        FutureBuilder(
                          future: themeColor,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AddExpensesPage()),
                                    );
                                  },
                                  child: Text(
                                    'Add',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      primary: Color(
                                          int.parse(snapshot.data.toString())),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ) // Background color
                                      ),
                                ),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AddExpensesPage()),
                                    );
                                  },
                                  child: Text(
                                    'Add',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.orange[800],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ) // Background color
                                      ),
                                ),
                              );
                            }
                          },
                        ),

                        Spacer(),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) => const HomePage()),
                        //     );
                        //   },
                        //   child: Text(
                        //     'Reload',
                        //     style: TextStyle(
                        //       color: Colors.white,
                        //       fontSize: 15,
                        //       fontWeight: FontWeight.w500,
                        //     ),
                        //   ),
                        //   style: ElevatedButton.styleFrom(
                        //       primary: Colors.orange[800],
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(15),
                        //       ) // Background color
                        //       ),
                        // ),

                        SizedBox(
                          width: 10,
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 95.0),
                          child: Container(
                            width: 100,
                            child: Text(
                              textAlign: TextAlign.center,
                              'CPD',
                              style: GoogleFonts.nunito(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 0.5,
                ),
              ]),
            ),
          ),
        ),
        Positioned(
          top: 70,
          left: 0,
          child: ExpensesWidgetMobileAllTime(),
        )
      ]),
    );
  }
}
