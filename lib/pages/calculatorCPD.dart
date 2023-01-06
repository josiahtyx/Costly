// ignore_for_file: prefer_const_constructors, unused_field, use_build_context_synchronously, avoid_print, prefer_interpolation_to_compose_strings, unnecessary_string_interpolations, deprecated_member_use, non_constant_identifier_names, avoid_unnecessary_containers

import 'package:costlynew/data/data.dart';
import 'package:costlynew/pages/deviceLayout.dart';
import 'package:costlynew/pages/plannedPurchases.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

class CPDCalculator extends StatefulWidget {
  const CPDCalculator({super.key});

  @override
  State<CPDCalculator> createState() => _CPDCalculatorState();
}

class _CPDCalculatorState extends State<CPDCalculator> {
  late String nameText;
  late Future<String> itemName;
  final _daysController = TextEditingController();
  final _priceController = TextEditingController();
  final _itemNameController = TextEditingController();
  String finalCPD = '0';
  @override
  void initState() {
    super.initState();
    _priceController.text = "0";
    _daysController.text = "0";
  }

  @override
  void dispose() {
    _priceController.dispose();
    _daysController.dispose();
    super.dispose();
  }

  void subtractYear() {
    if (_daysController.text == "") {
      _daysController.value = TextEditingValue(text: (0).toString());
      int value = int.parse(_daysController.text.toString());
      //print(value);
      value = value - 365;
      // print(value);
      _daysController.text = value.toString();
      _daysController.value = TextEditingValue(text: value.toString());
      calculateCPD();
      setState(() {});
    } else {
      int value = int.parse(_daysController.text.toString());
      //print(value);
      value = value - 365;
      // print(value);
      _daysController.text = value.toString();
      _daysController.value = TextEditingValue(text: value.toString());
      calculateCPD();
      setState(() {});
    }
  }

  void addYear() {
    if (_daysController.text == "") {
      _daysController.value = TextEditingValue(text: (0).toString());
      int value = int.parse(_daysController.text.toString());
      //print(value);
      value = value + 365;
      // print(value);
      _daysController.text = value.toString();
      _daysController.value = TextEditingValue(text: value.toString());
      calculateCPD();
      setState(() {});
    } else {
      int value = int.parse(_daysController.text.toString());
      //print(value);
      value = value + 365;
      // print(value);
      _daysController.text = value.toString();
      _daysController.value = TextEditingValue(text: value.toString());
      calculateCPD();
      setState(() {});
    }
  }

  void calculateCPD() {
    double price = double.parse(_priceController.text.replaceAll(',', '.'));
    int days = int.parse(_daysController.text);
    String CPD = (price / days).toStringAsFixed(2);
    finalCPD = CPD;
    //print(finalCPD);
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Item Name'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  nameText = value;
                });
              },
              controller: _itemNameController,
              decoration: InputDecoration(hintText: "Item Name"),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.orange[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ) // Background color
                    ),
                child: Text('OK'),
                onPressed: () async {
                  setState(() {
                    addPlans(
                        nameText.toString(),
                        _priceController.text.toString(),
                        _daysController.text.toString(),
                        0);
                  });
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('New plan added!')));
                  await Future.delayed(Duration(seconds: 1));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PlannedPurchases()),
                  );
                },
              ),
            ],
          );
        });
  }

  Widget addPlansButton(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.orange[800],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ) // Background color
            ),
        onPressed: (() {
          _displayTextInputDialog(context);
        }),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
          child: Text("Add to Plans"),
        ));
  }

  Widget mobileCalculator(BuildContext context) {
    final device = MediaQuery.of(context).size;
    return SizedBox(
      height: device.height,
      width: device.width,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
            //Title section
            backgroundColor: Colors.black,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              tooltip: 'Back',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
            title: Text('CPD Calculator')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Padding(
                padding: EdgeInsets.fromLTRB(25, 50, 25, 50),
                child: Center(
                  child: Column(children: [
                    Text(
                      "CPD \nCalculator",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                          color: Colors.orange[800],
                          fontWeight: FontWeight.w800,
                          fontSize: device.width * 0.06),
                    ),
                    SizedBox(
                      height: device.height * 0.02,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Price',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w800, fontSize: 24),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 50.0),
                            child: Container(
                              width: device.width * 0.3,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(0, 255, 255, 255),
                                border: Border.all(
                                    width: 3,
                                    color: Color.fromARGB(128, 0, 0, 0)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TextFormField(
                                onChanged: (value) {
                                  calculateCPD();
                                  setState(() {});
                                },
                                textAlign: TextAlign.center,
                                controller: _priceController,
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w600, fontSize: 24),
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
                        ]),
                      ),
                    ),
                    Container(
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Days',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w800, fontSize: 24),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50.0),
                          child: Container(
                            width: device.width * 0.2,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(0, 255, 255, 255),
                              border: Border.all(
                                  width: 3,
                                  color: Color.fromARGB(128, 0, 0, 0)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextFormField(
                              onChanged: (value) {
                                calculateCPD();
                                setState(() {});
                              },
                              textAlign: TextAlign.center,
                              controller: _daysController,
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600, fontSize: 24),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '0', /*prefixText: '€'*/
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\,?\d{0,2}')),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Container(
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Cost Per Day',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w800, fontSize: 24),
                            ),
                          ),
                          Text(
                            finalCPD.replaceAll(RegExp(r'\.'), ',') + "€",
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w600,
                                fontSize: device.width * 0.06),
                          )
                        ]),
                      ),
                    ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     calculateCPD();
                    //     setState(() {});
                    //     //add Controllers here
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //       primary: Colors.orange[800],
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(30),
                    //       ) // Background color
                    //       ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                    //     child: Text('Calculate'),
                    //   ),
                    // )
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget desktopCalculator(BuildContext context) {
    final device = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 235, 123, 60),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/CPDCalculator.png'),
            //colorFilter: ColorFilter.mode(Colors.white, BlendMode.screen),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: device.width * 0.015,
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      color: Colors.white,
                      tooltip: 'Back',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                          )
                        ],
                        border: Border.all(
                            color: Colors.white.withOpacity(0.2), width: 1.0),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.3),
                            Colors.white.withOpacity(0.2)
                          ],
                          stops: [0.0, 1.0],
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    alignment: Alignment.center,
                    height: device.height * 0.85,
                    width: device.width * 0.5,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(25, 40, 25, 25),
                      child: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "CPD Calculator",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 64),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  child: Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Price',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 36),
                                      ),
                                    ),
                                    Container(
                                      width: 300,
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(0, 255, 255, 255),
                                        border: Border.all(
                                          width: 3,
                                          color: Colors.white,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: TextFormField(
                                        onTap: () {
                                          _priceController.clear();
                                        },
                                        onChanged: (value) {
                                          calculateCPD();
                                          setState(() {});
                                        },
                                        textAlign: TextAlign.center,
                                        controller: _priceController,
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 24),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: '0,00 €',
                                          /*prefixText: '€'*/
                                          hintStyle: GoogleFonts.montserrat(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 24),
                                        ),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^\d*\,?\d{0,2}')),
                                        ],
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
                                      child: Text(
                                        'Days',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 36),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                            height: 40,
                                            width: 50,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                subtractYear();
                                              },
                                              child: Text(
                                                "-Y",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.nunito(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 12),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.orange[800],
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    //border radius equal to or more than 50% of width
                                                  )),
                                            )),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: Container(
                                            width: 150,
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  0, 255, 255, 255),
                                              border: Border.all(
                                                width: 3,
                                                color: Colors.white,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: TextFormField(
                                              onChanged: (value) {
                                                calculateCPD();
                                                setState(() {});
                                              },
                                              textAlign: TextAlign.center,
                                              controller: _daysController,
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 24),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: '0',
                                                /*prefixText: '€'*/
                                                hintStyle:
                                                    GoogleFonts.montserrat(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 24),
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(
                                                        r'^\d*\,?\d{0,2}')),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            height: 40,
                                            width: 50,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                addYear();
                                              },
                                              child: Text(
                                                "+Y",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.nunito(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 12),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.orange[800],
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    //border radius equal to or more than 50% of width
                                                  )),
                                            )),
                                      ],
                                    ),
                                  ]),
                                ),
                              ),
                              SizedBox(
                                height: device.height * 0.04,
                              ),
                              Container(
                                child: Column(children: [
                                  Text(
                                    'Cost Per Day',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 36),
                                  ),
                                  Text(
                                    finalCPD.replaceAll(RegExp(r'\.'), ',') +
                                        "€",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 64),
                                  )
                                ]),
                              ),
                              if (_priceController.text != "0" &&
                                  _daysController.text != "0")
                                Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: addPlansButton(context),
                                ),
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    calculateCPD();
                                    setState(() {});
                                    //add Controllers here
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.orange[800],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ) // Background color
                                      ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        30, 10, 30, 10),
                                    child: Text('Calculate'),
                                  ),
                                ),
                              )
                            ]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1480) {
          return desktopCalculator(context);
        } else {
          return mobileCalculator(context);
        }
      },
    );
  }
}
