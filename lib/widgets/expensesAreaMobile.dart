// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:costlynew/pages/newExpenses.dart';
import 'package:costlynew/pages/deviceLayout.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:costlynew/data/data.dart';

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
                              textAlign: TextAlign.center,
                              style: GoogleFonts.nunito(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: device.width * 0.05,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              "Purchase Details"),
                        ),
                      ),
                      SizedBox(height: device.height * 0.03),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                style: GoogleFonts.nunito(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: device.height * 0.027,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                "Purchase Name:"),
                            Text(
                                style: GoogleFonts.nunito(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: device.height * 0.027,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                itemName),
                            SizedBox(
                              height: device.height * 0.01,
                            ),
                            Text(
                                style: GoogleFonts.nunito(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: device.height * 0.027,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                "Category:"),
                            categoryButton(category),
                            SizedBox(
                              height: device.height * 0.01,
                            ),
                            Text(
                                style: GoogleFonts.nunito(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: device.height * 0.027,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                "Price:"),
                            Text(
                                style: GoogleFonts.nunito(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: device.height * 0.027,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                price + '€'),
                            SizedBox(
                              height: device.height * 0.01,
                            ),
                            Text(
                                style: GoogleFonts.nunito(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: device.height * 0.027,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                "Purchased Date:"),
                            Text(
                                style: GoogleFonts.nunito(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: device.height * 0.027,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                purchaseDate),
                            SizedBox(
                              height: device.height * 0.01,
                            ),
                            Text(
                                style: GoogleFonts.nunito(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: device.height * 0.027,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                "End Date:"),
                            Text(
                                style: GoogleFonts.nunito(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: device.height * 0.027,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                endDate),
                            SizedBox(
                              height: device.height * 0.01,
                            ),
                            Text(
                                style: GoogleFonts.nunito(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: device.height * 0.027,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                "Duration:"),
                            Text(
                                style: GoogleFonts.nunito(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: device.height * 0.027,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                duration + " days"),
                            SizedBox(
                              height: device.height * 0.01,
                            ),
                            Text(
                                style: GoogleFonts.nunito(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: device.height * 0.027,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                "CPD Amount:"),
                            Text(
                              style: GoogleFonts.nunito(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: device.height * 0.027,
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
            color: Colors.orange,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: Text(
            textAlign: TextAlign.center,
            "Food",
            style: TextStyle(
              color: Colors.black,
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
            color: Colors.red[200],
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: Text(
            textAlign: TextAlign.center,
            "Subscriptions",
            style: TextStyle(
              color: Colors.black,
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
            color: Colors.blue[400],
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: Text(
            textAlign: TextAlign.center,
            "Travel",
            style: TextStyle(
              color: Colors.black,
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
              color: Colors.black,
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
  late bool _isLoading;
  // Future<void> _handleRefresh() async {
  //   await userTransactions;
  // }

  void wait() async {
    funcGet.getTransactions();
    transactionsDataMonth = funcGet.getTransactions();
    // Future.delayed(const Duration(seconds: 5), () {
    //   setState(() {
    //     _isLoading = false;
    //   }); // Prints after 1 second.
    // });
  }

  @override
  void initState() {
    super.initState();
    wait();
    //This part needs to be updated to be manual or something

    // getCPDtotal();
    // totalCPD = getCPDtotal();
  }

  _loadData() async {
    await funcGet.getTransactions();
    transactionsDataMonth = funcGet.getTransactions();
    //print(transactionsDataMonth.toString());
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
                        style: GoogleFonts.nunito(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Spacer(),
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

                      // Container(
                      //   width: 100,
                      //   child: Text(
                      //     textAlign: TextAlign.center,
                      //     'Category',
                      //     style: GoogleFonts.nunito(
                      //       textStyle: TextStyle(
                      //         color: Colors.black,
                      //         fontSize: 20,
                      //         fontWeight: FontWeight.w800,
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      // Padding(
                      //   padding: const EdgeInsets.only(left: 75.0),
                      //   child: Container(
                      //     width: 100,
                      //     child: Text(
                      //       textAlign: TextAlign.center,
                      //       'Amount',
                      //       style: GoogleFonts.nunito(
                      //         textStyle: TextStyle(
                      //           color: Colors.black,
                      //           fontSize: 20,
                      //           fontWeight: FontWeight.w800,
                      //         ),
                      //       ),
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
                          return GestureDetector(
                              onTap: () {
                                showDetails(
                                  context,
                                  (userTransactions[index]['category'])
                                      .toString(),
                                  (userTransactions[index]['costPerDay'])
                                      .toString(),
                                  (userTransactions[index]['duration'])
                                      .toString(),
                                  (userTransactions[index]['endDate'])
                                      .toString(),
                                  (userTransactions[index]['itemDate'])
                                      .toString(),
                                  (userTransactions[index]['itemName'])
                                      .toString(),
                                  (userTransactions[index]['itemPrice'])
                                      .toString(),
                                );
                              },
                              child: Dismissible(
                                key: Key(item),
                                background: Container(
                                  color: Colors.amber[700],
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Icon(
                                    Icons.archive,
                                    color: Colors.white,
                                  ),
                                ),
                                secondaryBackground: Container(
                                    color: Colors.red,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    alignment: AlignmentDirectional.centerEnd,
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    )),
                                // Provide a function that tells the app
                                // what to do after an item has been swiped away.
                                onDismissed: (direction) async {
                                  if (direction ==
                                      DismissDirection.startToEnd) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                '${userTransactions[index]['itemName']} has been archived.')));
                                    archiveTransaction(
                                      (userTransactions[index]['category'])
                                          .toString(),
                                      // (userTransactions[index]['costPerDay'])
                                      //     .toString(),
                                      (userTransactions[index]['duration'])
                                          .toString(),
                                      (userTransactions[index]['endDate'])
                                          .toString(),
                                      (userTransactions[index]['itemDate'])
                                          .toString(),
                                      (userTransactions[index]['itemName'])
                                          .toString(),
                                      (userTransactions[index]['itemPrice'])
                                          .toString(),
                                    );
                                    setState(() {
                                      userTransactions.removeAt(index);
                                    });

                                    await Future.delayed(Duration(seconds: 1));
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomePage()),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                '${userTransactions[index]['itemName']} has been deleted.')));
                                    delTransaction(
                                      (userTransactions[index]['category'])
                                          .toString(),
                                      // (userTransactions[index]['costPerDay'])
                                      //     .toString(),
                                      (userTransactions[index]['duration'])
                                          .toString(),
                                      (userTransactions[index]['endDate'])
                                          .toString(),
                                      (userTransactions[index]['itemDate'])
                                          .toString(),
                                      (userTransactions[index]['itemName'])
                                          .toString(),
                                      (userTransactions[index]['itemPrice'])
                                          .toString(),
                                    );
                                    // Remove the item from the data source.
                                    setState(() {
                                      userTransactions.removeAt(index);
                                    });

                                    await Future.delayed(Duration(seconds: 1));
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomePage()),
                                    );
                                  }
                                  // Then show a snackbar.
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: ListTile(
                                    title: Row(
                                      children: [
                                        Text(
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            (userTransactions[index]
                                                    ['itemName'])
                                                .toString()),
                                      ],
                                    ),
                                    // subtitle: Text(('Item Price: ' +
                                    //         userTransactions[index]['itemPrice']
                                    //             .replaceAll(
                                    //                 RegExp(r'\.'), ',') +
                                    //         '€' +
                                    //         '\nPurchase Date: ' +
                                    //         userTransactions[index]
                                    //             ['itemDate'] +
                                    //         '')
                                    //     .toString()),
                                    trailing: Wrap(
                                      spacing: 12, // space between two icons
                                      children: <Widget>[
                                        SizedBox(
                                          width: 150,
                                          child: Text(
                                            textAlign: TextAlign.right,
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
                                                    .toString()
                                                    .replaceAll(
                                                        RegExp(r'\.'), ',') +
                                                "€" +
                                                "/" +
                                                daysBetween.toString() +
                                                "d"), // icon-1
                                            // Icon(Icons.delete), // icon-2
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ));
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
