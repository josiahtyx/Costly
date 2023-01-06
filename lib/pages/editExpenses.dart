// ignore_for_file: prefer_const_constructors, unused_field, use_build_context_synchronously, avoid_print, prefer_interpolation_to_compose_strings, unnecessary_string_interpolations, deprecated_member_use, file_names, unused_import, unnecessary_new, non_constant_identifier_names

import 'package:costlynew/auth/main_page.dart';
import 'package:costlynew/data/data.dart';
import 'package:costlynew/pages/deviceLayout.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:costlynew/data/tempFields.dart';

class EditExpensesPage extends StatefulWidget {
  const EditExpensesPage({Key? key}) : super(key: key);

  @override
  State<EditExpensesPage> createState() => _EditExpensesPageState();
}

class _EditExpensesPageState extends State<EditExpensesPage> {
  FocusNode myFocusNode = new FocusNode();
  final db = FirebaseFirestore.instance;
  TextEditingController dateinput = TextEditingController();
  TextEditingController endDateInput = TextEditingController();
  DateTime? pickedStartDate;
  DateTime? pickedEndDate;

  final _itemNameController = TextEditingController();
  final _itemCategoryController = TextEditingController();
  final _priceController = TextEditingController();
  final monthYear = DateFormat('MMMM y').format(DateTime.now());
  final year = DateFormat('y').format(DateTime.now());
  final userID = FirebaseAuth.instance.currentUser?.uid;
  String dropdownCategory = "No Category";
  String duration = "0";

  var categories = [
    'No Category',
    'Entertainment',
    'Food',
    'Personal',
    'Shopping',
    'Subscriptions',
    'Tech',
    'Travel',
    'Utilities',
  ];

  // durationDays(String duration) {
  //   this.duration = duration;
  // }

  late String daysBetween;
  callBackDaysBetween(String daysBetween) {
    this.daysBetween = daysBetween;
  }

  late String transactionMY;
  callBackMY(String transactionMY) {
    this.transactionMY = transactionMY;
  }

  Future<void> modifyTextFields() async {
    _itemNameController.value = TextEditingValue(text: itemNamex);
    _itemNameController.text = itemNamex;
    _priceController.value = TextEditingValue(text: pricex);
    _priceController.text = pricex;
    pickedStartDate = DateTime.parse(purchaseDatex);
    if (endDatex == "") {
    } else {
      pickedEndDate = DateTime.parse(endDatex);
    }
    _itemCategoryController.value = TextEditingValue(text: itemCategoryx);
    _itemCategoryController.text = itemCategoryx;
    dateinput.text = purchaseDatex;
    endDateInput.text = endDatex;
    dropdownCategory = itemCategoryx;
    transactionMY = DateFormat('MMMM y').format(DateTime.parse(purchaseDatex));
  }

  String durationCal() {
    if (pickedEndDate == null) {
      return "0";
    } else {
      final difference =
          (pickedEndDate?.difference(pickedStartDate!).inDays).toString();
      duration = (int.parse(difference) + 1).toString();
      //print(duration);
      return duration;
    }
  }

  String CPDCalculator() {
    double price = double.parse(_priceController.text.replaceAll(',', '.'));
    int days = int.parse(duration.toString());
    String tempCPD = (price / days).toStringAsFixed(2);
    double totalCPD = double.parse(tempCPD);
    String totalCPDstring = totalCPD.toString();

    // double finalCPD = double.parse(totalCPDstring.replaceAll('.', ','));
    return totalCPDstring;
  }

  Future addTransaction(
      String itemName,
      String price,
      String purchaseDate,
      String endDate,
      String duration,
      // String costPerDay,
      String itemCategory) async {
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
            'endDate': endDate,
            'duration': duration,
            //'costPerDay': costPerDay,
            'category': itemCategory,
          },
        ],
      ),
    }, SetOptions(merge: true));
    // Make a new IF YEAR = year.now then add to year collection
    // db
    //     .collection('userData')
    //     .doc(userID)
    //     .collection('transactions')
    //     .doc(year)
    //     .set({
    //   'transactions': FieldValue.arrayUnion(
    //     [
    //       {
    //         'itemName': itemName,
    //         'itemPrice': price,
    //         'itemDate': purchaseDate,
    //         'daysBetween': daysBetween,
    //         'costPerDay': costPerDay,
    //       },
    //     ],
    //   ),
    // }, SetOptions(merge: true));
    //
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
            //'daysBetween': daysBetween, //this is kinda useless since calculation is done later
            'endDate': endDate,
            'duration': duration,
            //'costPerDay': costPerDay,
            'category': itemCategory,
          },
        ],
      ),
    }, SetOptions(merge: true));
  }

  @override
  void initState() {
    super.initState();

    //set the initial value of text field

    modifyTextFields();
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
                    //           builder: (context) => const EditExpensesPage()),
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
                          'Purchase Name',
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
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[a-zA-Z0-9_ ]")),
                              ]),
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
                          'Amount of purchase',
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
                          'Purchase Date',
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
                              pickedStartDate = await showDatePicker(
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
                                  initialDate: DateTime.parse(purchaseDatex),
                                  firstDate: DateTime(
                                      2000), //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(2100));

                              if (pickedStartDate != null) {
                                // print(pickedStartDate);

                                final transactionMY = DateFormat('MMMM y')
                                    .format(pickedStartDate!);

                                final difference = (DateTime.now()
                                        .difference(pickedStartDate!)
                                        .inDays)
                                    .toString();
                                // print(difference);
                                // print(transactionMY);
                                String formattedDate = DateFormat('yyyy-MM-dd')
                                    .format(pickedStartDate!);
                                // print(
                                //     formattedDate); //formatted date output using intl package =>  2021-03-16
                                //you can implement different kind of Date Format here according to your requirement

                                setState(() {
                                  //print(pickedStartDate);
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
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'End Date (Optional)',
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
                            controller: endDateInput,
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
                              pickedEndDate = await showDatePicker(
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
                                  firstDate: DateTime.parse(pickedStartDate
                                      .toString()), //Not to allow to choose before initial date.
                                  lastDate: DateTime(2200));

                              if (pickedEndDate != null) {
                                //print(pickedEndDate);

                                // print(transactionMY);
                                String formattedDate = DateFormat('yyyy-MM-dd')
                                    .format(pickedEndDate!);

                                //print(duration);
                                // print(
                                //     formattedDate); //formatted date output using intl package =>  2021-03-16
                                //you can implement different kind of Date Format here according to your requirement
                                setState(() {
                                  endDateInput.text =
                                      formattedDate; //to change textfield section
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
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Category',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: DropdownButton(
                              // Initial Value
                              value: dropdownCategory,

                              // Down Arrow Icon
                              icon: const Icon(Icons.keyboard_arrow_down),

                              // Array list of items
                              items: categories.map((String categories) {
                                return DropdownMenuItem(
                                  value: categories,
                                  child: Text(categories),
                                );
                              }).toList(),
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownCategory = newValue!;
                                });
                              },
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
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    //print(durationCal() + pickedEndDate.toString());
                    delTransaction(itemCategoryx, durationx, endDatex,
                        purchaseDatex, itemNamex, pricex);

                    addTransaction(
                        _itemNameController.text.trim(),
                        _priceController.text
                            .trim()
                            .replaceAll(RegExp(r','), '.'),
                        dateinput.text.trim(),
                        endDateInput.text.trim(),
                        durationCal().trim(),
                        // CPDCalculator(),
                        dropdownCategory);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Transaction edited!')));
                  await Future.delayed(Duration(seconds: 1));
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
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
                  child: Text('Edit'),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
