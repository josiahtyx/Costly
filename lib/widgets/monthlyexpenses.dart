// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:costlynew/pages/newExpenses.dart';
import 'package:costlynew/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:costlynew/data/passerFunctions.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

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
  int listLength = 1;
  late int daysBetween;

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

    //This part needs to be updated to be manual or something
    funcGet.getTransactions();
    transactionsDataMonth = funcGet.getTransactions();
    // getCPDtotal();
    // totalCPD = getCPDtotal();
  }

  _loadData() async {
    await funcGet.getTransactions();
    transactionsDataMonth = funcGet.getTransactions();
    print(transactionsDataMonth.toString());
  }

  @override
  Widget build(BuildContext context) {
    _loadData();
    return SingleChildScrollView(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(35, 0, 25, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text(
              //   'Expenses ',
              //   style: GoogleFonts.nunito(
              //     textStyle: TextStyle(
              //       color: Colors.black,
              //       fontSize: 25,
              //       fontWeight: FontWeight.w700,
              //     ),
              //   ),
              // ),

              // ElevatedButton(
              //   onPressed: getList,
              //   child: Text('Refresh'),
              //   style: ElevatedButton.styleFrom(
              //       primary: Colors.orange[800],
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(15),
              //       ) // Background color
              //       ),
              // )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
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
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
                          );
                        },
                        child: Text(
                          'Reload',
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
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddExpensesPage()),
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
                      // Text(
                      //   'Category',
                      //   style: GoogleFonts.nunito(
                      //     textStyle: TextStyle(
                      //       color: Colors.black,
                      //       fontSize: 15,
                      //       fontWeight: FontWeight.w700,
                      //     ),
                      //   ),
                      // ),
                      // Text(
                      //   'Amount',
                      //   style: GoogleFonts.nunito(
                      //     textStyle: TextStyle(
                      //       color: Colors.black,
                      //       fontSize: 15,
                      //       fontWeight: FontWeight.w700,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
              Divider(
                thickness: 0.5,
              ),
              // ElevatedButton(
              //   onPressed: getCPDtotal,
              //   child: Text('Add'),
              //   style: ElevatedButton.styleFrom(
              //       primary: Colors.orange[800],
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(15),
              //       ) // Background color
              //       ),
              // ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: FutureBuilder(
                    future: transactionsDataMonth,
                    builder: (context, snapshot) {
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: userTransactions.length,
                        itemBuilder: ((context, index) {
                          final item = userTransactions[index].toString();
                          return Dismissible(
                            key: Key(item),
                            // Provide a function that tells the app
                            // what to do after an item has been swiped away.
                            onDismissed: (direction) async {
                              delTransaction(
                                  (userTransactions[index]['itemName'])
                                      .toString(),
                                  (userTransactions[index]['itemPrice'])
                                      .toString(),
                                  (userTransactions[index]['itemDate'])
                                      .toString(),
                                  (userTransactions[index]['daysBetween'])
                                      .toString(),
                                  (userTransactions[index]['costPerDay'])
                                      .toString());
                              // Remove the item from the data source.
                              setState(() {
                                userTransactions.removeAt(index);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Transaction has been deleted! Please refresh the page!')));
                              await Future.delayed(Duration(seconds: 1));
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()),
                              );
                              // Then show a snackbar.
                            },
                            background: Container(color: Colors.orange),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ListTile(
                                title: Text(
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    (userTransactions[index]['itemName'])
                                        .toString()),
                                subtitle: Text(('Item Price: ' +
                                        userTransactions[index]['itemPrice'] +
                                        '€' +
                                        '\nPurchase Date: ' +
                                        userTransactions[index]['itemDate'] +
                                        '')
                                    .toString()),
                                trailing: Wrap(
                                  spacing: 12, // space between two icons
                                  children: <Widget>[
                                    Text(
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      ((calculateCPD(
                                                  (userTransactions[index]
                                                      ['itemDate']),
                                                  (userTransactions[index]
                                                      ['itemPrice'])))
                                              .toString() +
                                          "€" +
                                          "/" +
                                          daysBetween.toString() +
                                          "d"), // icon-1
                                      // Icon(Icons.delete), // icon-2
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    }),
              )
            ]),
          ),
        )
      ]),
    );
  }
}
