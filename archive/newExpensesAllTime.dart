// ignore_for_file: prefer_const_constructors, unused_field, use_build_context_synchronously, avoid_print, prefer_interpolation_to_compose_strings, unnecessary_string_interpolations, deprecated_member_use, file_names, unused_import, unnecessary_new, non_constant_identifier_names

import 'package:costlynew/auth/main_page.dart';
import 'package:costlynew/pages/deviceLayout.dart';
import 'package:costlynew/pages/allTimeExpenses.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddExpensesPage extends StatefulWidget {
  const AddExpensesPage({Key? key}) : super(key: key);

  @override
  State<AddExpensesPage> createState() => _AddExpensesPageState();
}

class _AddExpensesPageState extends State<AddExpensesPage> {
  FocusNode myFocusNode = new FocusNode();
  final db = FirebaseFirestore.instance;
  TextEditingController dateinput = TextEditingController();
  final _itemNameController = TextEditingController();
  final _priceController = TextEditingController();
  final monthYear = DateFormat('MMMM y').format(DateTime.now());
  final year = DateFormat('y').format(DateTime.now());
  final userID = FirebaseAuth.instance.currentUser?.uid;

  late String daysBetween;
  callBackDaysBetween(String daysBetween) {
    this.daysBetween = daysBetween;
  }

  late String transactionMY;
  callBackMY(String transactionMY) {
    this.transactionMY = transactionMY;
  }

  String CPDCalculator() {
    double price = double.parse(_priceController.text.replaceAll(',', '.'));
    int theNumberofDaysBetween = int.parse(daysBetween);
    String tempCPD = (price / (theNumberofDaysBetween + 1)).toStringAsFixed(2);
    double totalCPD = double.parse(tempCPD);
    String totalCPDstring = totalCPD.toString();
    // double finalCPD = double.parse(totalCPDstring.replaceAll('.', ','));
    return totalCPDstring;
  }

  Future addTransaction(String itemName, String price, String purchaseDate,
      String daysBetween, String costPerDay) async {
    await db
        .collection('userData')
        .doc(userID)
        .collection('transactions')
        .doc(transactionMY)
        .set({
      'transactions': FieldValue.arrayUnion(
        [
          {
            'itemName': itemName,
            'itemPrice': price,
            'itemDate': purchaseDate,
            'daysBetween': daysBetween,
            'costPerDay': costPerDay,
          },
        ],
      ),
    }, SetOptions(merge: true));
    db
        .collection('userData')
        .doc(userID)
        .collection('transactions')
        .doc(year)
        .set({
      'transactions': FieldValue.arrayUnion(
        [
          {
            'itemName': itemName,
            'itemPrice': price,
            'itemDate': purchaseDate,
            'daysBetween': daysBetween,
            'costPerDay': costPerDay,
          },
        ],
      ),
    }, SetOptions(merge: true));
    db
        .collection('userData')
        .doc(userID)
        .collection('transactions')
        .doc('All')
        .set({
      'transactions': FieldValue.arrayUnion(
        [
          {
            'itemName': itemName,
            'itemPrice': price,
            'itemDate': purchaseDate,
            'daysBetween': daysBetween,
            'costPerDay': costPerDay,
          },
        ],
      ),
    }, SetOptions(merge: true));
  }

  @override
  void initState() {
    dateinput.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _priceController.dispose();
    dateinput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text('Add Expenses'),
        //   backgroundColor: Colors.black,
        //   automaticallyImplyLeading: false,
        // ),
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      tooltip: 'Back',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        );
                      },
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 35.0),
                      child: Text(
                        'New Transaction',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    // Text(
                    //   'View All',
                    //   style: GoogleFonts.nunito(
                    //     textStyle: TextStyle(
                    //       color: Colors.black,
                    //       fontSize: 10.95,
                    //       fontWeight: FontWeight.w600,
                    //     ),
                    //   ),
                    // ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => const AddExpensesPage()),
                    //     );
                    //   },
                    //   child: Text('Add'),
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
              SizedBox(
                height: 10,
              ),
              // What did you buy?
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'What did you buy?',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextField(
                            controller: _itemNameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Item Name',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
              SizedBox(
                height: 10,
              ),

              //How much did you spend?
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'How much did you spend?',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextFormField(
                            controller: _priceController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '0,00 €', /*prefixText: '€'*/
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\,?\d{0,2}')),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
              SizedBox(
                height: 10,
              ),

              //when did you buy it
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'When did you buy it?',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextField(
                            controller: dateinput,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                icon: Icon(Icons.calendar_today,
                                    color: myFocusNode.hasFocus
                                        ? Colors.orange
                                        : Colors.black), //icon of text field
                                labelText: "Enter Date",
                                labelStyle: TextStyle(
                                    color: myFocusNode.hasFocus
                                        ? Colors.orange
                                        : Colors.black) //label text of field
                                ),
                            readOnly:
                                true, //set it true, so that user will not able to edit text
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.light(
                                          primary: Colors
                                              .orange, // header background color
                                          onPrimary:
                                              Colors.white, // header text color
                                          onSurface:
                                              Colors.black, // body text color
                                        ),
                                        textButtonTheme: TextButtonThemeData(
                                          style: TextButton.styleFrom(
                                            primary: Colors
                                                .black, // button text color
                                          ),
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(
                                      2000), //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime.now());

                              if (pickedDate != null) {
                                // print(pickedDate);

                                final transactionMY =
                                    DateFormat('MMMM y').format(pickedDate);

                                final difference = (DateTime.now()
                                        .difference(pickedDate)
                                        .inDays)
                                    .toString();
                                // print(difference);
                                // print(transactionMY);
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                // print(
                                //     formattedDate); //formatted date output using intl package =>  2021-03-16
                                //you can implement different kind of Date Format here according to your requirement

                                setState(() {
                                  dateinput.text = formattedDate;
                                  callBackDaysBetween(difference);
                                  callBackMY(
                                      transactionMY); //set output date to TextField value.
                                });
                              } else {
                                print("Date is not selected");
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
              SizedBox(
                height: 20,
              ),

              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    addTransaction(
                        _itemNameController.text.trim(),
                        _priceController.text.trim(),
                        dateinput.text.trim(),
                        daysBetween.trim(),
                        CPDCalculator());
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Transaction has been added!')));
                  await Future.delayed(Duration(seconds: 1));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TotalExpensesPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.orange[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ) // Background color
                    ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                  child: Text('Add'),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
