// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:costlynew/pages/newExpenses.dart';
import 'package:costlynew/pages/deviceLayout.dart';
import 'package:costlynew/pages/allTimeExpenses.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:costlynew/data/data.dart';

var funcGetYear = new GetTransactionsYearly();

class TransactionsAreaYearly extends StatefulWidget {
  const TransactionsAreaYearly({Key? key}) : super(key: key);

  @override
  State<TransactionsAreaYearly> createState() => _TransactionsAreaYearlyState();
}

class _TransactionsAreaYearlyState extends State<TransactionsAreaYearly> {
  final user = FirebaseAuth.instance.currentUser!;
  final db = FirebaseFirestore.instance;
  final year = (DateFormat('y').format(DateTime.now())).toString();
  final monthYear = (DateFormat('MMMM y').format(DateTime.now())).toString();
  final userID = FirebaseAuth.instance.currentUser?.uid;
  int listLength = 1;
  late int daysBetween;

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

  Future<void> showDetailsMobile(
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

  Widget subtitleText(index) {
    if (index['duration'] != "0") {
      return Text(('Item Price: ' +
              index['itemPrice'].replaceAll(RegExp(r'\.'), ',') +
              '€' +
              '\nPurchase Date: ' +
              index['itemDate'] +
              '   ' +
              'End Date: ' +
              index['endDate'])
          .toString());
    } else {
      return Text(('Item Price: ' +
              index['itemPrice'].replaceAll(RegExp(r'\.'), ',') +
              '€' +
              '\nPurchase Date: ' +
              index['itemDate'] +
              '')
          .toString());
    }
  }

//(index['costPerDay'] + "€" + "/" + index['duration'] + "d")

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
  //   await userTransactionsYearly;
  // }

  @override
  void initState() {
    super.initState();

    //This part needs to be updated to be manual or something
    funcGetYear.getTransactions();
    transactionsDataYear = funcGetYear.getTransactions();
    // getCPDtotal();
    // totalCPD = getCPDtotal();
  }

  _loadData() async {
    await funcGetYear.getTransactions();
    transactionsDataYear = funcGetYear.getTransactions();
  }

  Widget desktopAllTime(BuildContext context) {
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
                    future: transactionsDataYear,
                    builder: (context, snapshot) {
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: userTransactionsYearly.length,
                        itemBuilder: ((context, index) {
                          final item = userTransactionsYearly[index].toString();
                          return GestureDetector(
                              onTap: () {
                                showDetails(
                                  context,
                                  (userTransactionsYearly[index]['category'])
                                      .toString(),
                                  (userTransactionsYearly[index]['costPerDay'])
                                      .toString(),
                                  (userTransactionsYearly[index]['duration'])
                                      .toString(),
                                  (userTransactionsYearly[index]['endDate'])
                                      .toString(),
                                  (userTransactionsYearly[index]['itemDate'])
                                      .toString(),
                                  (userTransactionsYearly[index]['itemName'])
                                      .toString(),
                                  (userTransactionsYearly[index]['itemPrice'])
                                      .toString(),
                                );
                              },
                              child: Dismissible(
                                key: Key(item),
                                // Provide a function that tells the app
                                // what to do after an item has been swiped away.
                                onDismissed: (direction) async {
                                  delTransaction(
                                    (userTransactionsYearly[index]['category'])
                                        .toString(),
                                    // (userTransactionsYearly[index]
                                    //         ['costPerDay'])
                                    //     .toString(),
                                    (userTransactionsYearly[index]['duration'])
                                        .toString(),
                                    (userTransactionsYearly[index]['endDate'])
                                        .toString(),
                                    (userTransactionsYearly[index]['itemDate'])
                                        .toString(),
                                    (userTransactionsYearly[index]['itemName'])
                                        .toString(),
                                    (userTransactionsYearly[index]['itemPrice'])
                                        .toString(),
                                  );
                                  // Remove the item from the data source.
                                  setState(() {
                                    userTransactionsYearly.removeAt(index);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Transaction has been deleted! Please refresh the page!')));
                                  await Future.delayed(Duration(seconds: 1));
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const TotalExpensesPage()),
                                  );
                                },
                                background: Container(color: Colors.orange[50]),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: ListTile(
                                    title: Text(
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        (userTransactionsYearly[index]
                                                ['itemName'])
                                            .toString()),
                                    subtitle: subtitleText(
                                        userTransactionsYearly[index]),
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
                                                        (userTransactionsYearly[
                                                            index]['itemDate']),
                                                        (userTransactionsYearly[
                                                                index]
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

  Widget mobileAllTime(BuildContext context) {
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
                    future: transactionsDataYear,
                    builder: (context, snapshot) {
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: userTransactionsYearly.length,
                        itemBuilder: ((context, index) {
                          final item = userTransactionsYearly[index].toString();
                          return GestureDetector(
                              onTap: () {
                                showDetailsMobile(
                                  context,
                                  (userTransactionsYearly[index]['category'])
                                      .toString(),
                                  (userTransactionsYearly[index]['costPerDay'])
                                      .toString(),
                                  (userTransactionsYearly[index]['duration'])
                                      .toString(),
                                  (userTransactionsYearly[index]['endDate'])
                                      .toString(),
                                  (userTransactionsYearly[index]['itemDate'])
                                      .toString(),
                                  (userTransactionsYearly[index]['itemName'])
                                      .toString(),
                                  (userTransactionsYearly[index]['itemPrice'])
                                      .toString(),
                                );
                              },
                              child: Dismissible(
                                key: Key(item),
                                // Provide a function that tells the app
                                // what to do after an item has been swiped away.
                                onDismissed: (direction) async {
                                  delTransaction(
                                    (userTransactionsYearly[index]['category'])
                                        .toString(),
                                    // (userTransactionsYearly[index]
                                    //         ['costPerDay'])
                                    //     .toString(),
                                    (userTransactionsYearly[index]['duration'])
                                        .toString(),
                                    (userTransactionsYearly[index]['endDate'])
                                        .toString(),
                                    (userTransactionsYearly[index]['itemDate'])
                                        .toString(),
                                    (userTransactionsYearly[index]['itemName'])
                                        .toString(),
                                    (userTransactionsYearly[index]['itemPrice'])
                                        .toString(),
                                  );
                                  // Remove the item from the data source.
                                  setState(() {
                                    userTransactionsYearly.removeAt(index);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Transaction has been deleted! Please refresh the page!')));
                                  await Future.delayed(Duration(seconds: 1));
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const TotalExpensesPage()),
                                  );
                                },
                                background: Container(color: Colors.orange[50]),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: ListTile(
                                    title: Text(
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        (userTransactionsYearly[index]
                                                ['itemName'])
                                            .toString()),
                                    subtitle: subtitleText(
                                        userTransactionsYearly[index]),
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
                                                        (userTransactionsYearly[
                                                            index]['itemDate']),
                                                        (userTransactionsYearly[
                                                                index]
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

  @override
  Widget build(BuildContext context) {
    _loadData();
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1480) {
          return desktopAllTime(context);
        } else {
          return mobileAllTime(context);
        }
      },
    );
  }
}
