// ignore_for_file: prefer_const_constructors, unused_field, use_build_context_synchronously, avoid_print, prefer_interpolation_to_compose_strings, unnecessary_string_interpolations, deprecated_member_use, non_constant_identifier_names, avoid_unnecessary_containers

import 'package:costlynew/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class CPDCalculator extends StatefulWidget {
  const CPDCalculator({super.key});

  @override
  State<CPDCalculator> createState() => _CPDCalculatorState();
}

class _CPDCalculatorState extends State<CPDCalculator> {
  final _daysController = TextEditingController();
  final _priceController = TextEditingController();
  String finalCPD = '0';

  @override
  void dispose() {
    _priceController.dispose();
    _daysController.dispose();
    super.dispose();
  }

  void calculateCPD() {
    double price = double.parse(_priceController.text.replaceAll(',', '.'));
    int days = int.parse(_daysController.text);
    String CPD = (price / days).toStringAsFixed(2);
    finalCPD = CPD;
    print(finalCPD);
  }

  Widget mobileCalculator(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      width: size.width,
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
                          fontSize: size.width * 0.06),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
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
                              width: size.width * 0.3,
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
                            width: size.width * 0.2,
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
                            finalCPD + "€",
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w600,
                                fontSize: size.width * 0.06),
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
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 235, 123, 60),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
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
            SizedBox(
              height: 35,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Colors.white),
                height: 775,
                width: 600,
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
                                    fontWeight: FontWeight.w800, fontSize: 36),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 50.0),
                              child: Container(
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
                                      fontWeight: FontWeight.w600,
                                      fontSize: 24),
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
                                    fontWeight: FontWeight.w800, fontSize: 36),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 50.0),
                              child: Container(
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
                                      fontWeight: FontWeight.w600,
                                      fontSize: 24),
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
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(50, 50, 50, 50),
                        child: Container(
                          child: Column(children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Cost Per Day',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w800, fontSize: 36),
                              ),
                            ),
                            Text(
                              finalCPD + "€",
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600, fontSize: 64),
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
