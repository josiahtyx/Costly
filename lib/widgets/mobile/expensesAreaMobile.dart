// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:costlynew/pages/calculatorCPD.dart';
import 'package:costlynew/pages/newExpenses.dart';
import 'package:costlynew/pages/deviceLayout.dart';
import 'package:costlynew/widgets/expensesTableMonthly.dart';
import 'package:costlynew/widgets/mobile/expensesTableMobile.dart';
import 'package:costlynew/widgets/mobile/expensesTableMobile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:costlynew/data/data.dart';
import 'package:loading_indicator/loading_indicator.dart';

var funcGet = new GetTransactions();
var funcGetYear = new GetTransactionsYearly();

class TransactionsAreaMobile extends StatefulWidget {
  const TransactionsAreaMobile({Key? key}) : super(key: key);

  @override
  State<TransactionsAreaMobile> createState() => _TransactionsAreaMobileState();
}

class _TransactionsAreaMobileState extends State<TransactionsAreaMobile> {
  final user = FirebaseAuth.instance.currentUser!;
  final db = FirebaseFirestore.instance;
  final year = (DateFormat('y').format(DateTime.now())).toString();
  final monthYear = (DateFormat('MMMM y').format(DateTime.now())).toString();
  final userID = FirebaseAuth.instance.currentUser?.uid;
  final _transactionName = TextEditingController();
  int listLength = 1;
  late int daysBetween;
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

  late Future<List<dynamic>> transactionsDataMonth;
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
    await funcGet.getTransactions();
    transactionsDataMonth = funcGet.getTransactions();
  }

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          clipBehavior: Clip.antiAlias,
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
          child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.hardEdge,
              children: [
                //Header of Expenses Table Widget
                Positioned(
                  child: Container(
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                                            primary: Color(int.parse(
                                                snapshot.data.toString())),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
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
                                              borderRadius:
                                                  BorderRadius.circular(15),
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

                              Container(
                                child: Text(
                                  textAlign: TextAlign.end,
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
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 2,
                        decoration:
                            BoxDecoration(color: Colors.black.withOpacity(0.1)),
                      ),
                      ExpensesWidgetMobile(),
                    ]),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
