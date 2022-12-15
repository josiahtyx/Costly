// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:costlynew/pages/calculatorCPD.dart';
import 'package:costlynew/pages/newExpenses.dart';
import 'package:costlynew/pages/deviceLayout.dart';
import 'package:costlynew/widgets/expensesWidget.dart';
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

class TransactionsArea extends StatefulWidget {
  const TransactionsArea({Key? key}) : super(key: key);

  @override
  State<TransactionsArea> createState() => _TransactionsAreaState();
}

class _TransactionsAreaState extends State<TransactionsArea> {
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

  @override
  Future<void> showDetails(
    BuildContext context,
    String category,
    String costPerDay,
    String duration,
    String endDate,
    String purchaseDate,
    String itemName,
    String price,
  ) async {
    return showDialog(
        context: context,
        builder: (context) {
          final device = MediaQuery.of(context).size;
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            content: SizedBox(
                height: device.height * 0.8,
                width: device.width * 0.3,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          child: Text(
                              style: GoogleFonts.nunito(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: device.width * 0.03,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              "Purchase Details"),
                        ),
                      ),
                      SizedBox(height: device.height * 0.03),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                    style: GoogleFonts.nunito(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: device.height * 0.03,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    "Purchase Name:"),
                                Spacer(),
                                Text(
                                    style: GoogleFonts.nunito(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: device.height * 0.03,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    itemName),
                              ],
                            ),
                            SizedBox(
                              height: device.height * 0.01,
                            ),
                            Row(
                              children: [
                                Text(
                                    style: GoogleFonts.nunito(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: device.height * 0.03,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    "Category:"),
                                Spacer(),
                                categoryButton(category),
                              ],
                            ),
                            SizedBox(
                              height: device.height * 0.01,
                            ),
                            Row(
                              children: [
                                Text(
                                    style: GoogleFonts.nunito(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: device.height * 0.03,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    "Price:"),
                                Spacer(),
                                Text(
                                    style: GoogleFonts.nunito(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: device.height * 0.03,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    price + '€'),
                              ],
                            ),
                            SizedBox(
                              height: device.height * 0.01,
                            ),
                            Row(
                              children: [
                                Text(
                                    style: GoogleFonts.nunito(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: device.height * 0.03,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    "Purchased Date:"),
                                Spacer(),
                                Text(
                                    style: GoogleFonts.nunito(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: device.height * 0.03,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    purchaseDate),
                              ],
                            ),
                            SizedBox(
                              height: device.height * 0.01,
                            ),
                            Row(
                              children: [
                                Text(
                                    style: GoogleFonts.nunito(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: device.height * 0.03,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    "End Date:"),
                                Spacer(),
                                Text(
                                    style: GoogleFonts.nunito(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: device.height * 0.03,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    endDate),
                              ],
                            ),
                            SizedBox(
                              height: device.height * 0.01,
                            ),
                            Row(
                              children: [
                                Text(
                                    style: GoogleFonts.nunito(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: device.height * 0.03,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    "Duration:"),
                                Spacer(),
                                Text(
                                    style: GoogleFonts.nunito(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: device.height * 0.03,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    duration + " days"),
                              ],
                            ),
                            SizedBox(
                              height: device.height * 0.01,
                            ),
                            Row(
                              children: [
                                Text(
                                    style: GoogleFonts.nunito(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: device.height * 0.03,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    "CPD Amount:"),
                                Spacer(),
                                Text(
                                  style: GoogleFonts.nunito(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: device.height * 0.03,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  ((calculateCPD((purchaseDate), (price)))
                                          .toString()
                                          .replaceAll(RegExp(r'\.'), ',') +
                                      "€" +
                                      "/" +
                                      daysBetween.toString() +
                                      "d"),
                                ),
                              ],
                            )
                          ]),
                    ],
                  ),
                )),
          );
        });
  }

  Widget categoryButton(String index) {
    if (index == 'Food') {
      return Container(
        width: 130,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 124, 214, 154),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: Text(
            textAlign: TextAlign.center,
            "Food",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }
    if (index == 'Subscriptions') {
      return Container(
        width: 130,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 68, 68),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: Text(
            textAlign: TextAlign.center,
            "Subscriptions",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }
    if (index == 'Travel') {
      return Container(
        width: 130,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 68, 165, 255),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: Text(
            textAlign: TextAlign.center,
            "Travel",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }
    if (index == 'Tech') {
      return Container(
        width: 130,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 0, 88, 160),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: Text(
            textAlign: TextAlign.center,
            "Tech",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }
    if (index == 'Utilities') {
      return Container(
        width: 130,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 203, 68),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: Text(
            textAlign: TextAlign.center,
            "Utilities",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    } else {
      return Container(
        width: 130,
        decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: Text(
            textAlign: TextAlign.center,
            'No Category',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }
  }

  double calculateCPD(date, price) {
    DateTime receivedDate = DateTime.parse(date);
    int dateDifference = ((DateTime.now().difference(receivedDate).inDays) + 1);
    // print(dateDifference);
    daysBetween =
        dateDifference; //so first we get the difference from the transaction date and today.

    double receivedPrice =
        double.parse(price); //then we take the price and turn it into a double
    String cpdAmount = (receivedPrice / daysBetween).toStringAsFixed(2);
    double newcpdAmount = double.parse(cpdAmount);
    return newcpdAmount;
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
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      child: Stack(children: [
        Positioned(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
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

                        Container(
                          width: 100,
                          child: Text(
                            textAlign: TextAlign.center,
                            'Category',
                            style: GoogleFonts.nunito(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
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
                        Padding(
                          padding: const EdgeInsets.only(left: 55.0),
                          child: Container(
                            width: 100,
                            child: Text(
                              textAlign: TextAlign.center,
                              'Amount',
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
          top: 90,
          left: 15,
          child: ExpensesWidget(),
        )
      ]),
    );
  }
}
