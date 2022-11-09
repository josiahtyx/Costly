// ignore_for_file: prefer_const_constructors, unused_field, use_build_context_synchronously, avoid_print, prefer_interpolation_to_compose_strings, unnecessary_string_interpolations, deprecated_member_use

import 'package:flutter/material.dart';
import '../data/passerFunctions.dart';

var funcCPD = GetCPDTotal();
var funcSpent = GetTotalSpent();

class CPDArea extends StatefulWidget {
  const CPDArea({Key? key}) : super(key: key);

  @override
  State<CPDArea> createState() => _CPDAreaState();
}

class _CPDAreaState extends State<CPDArea> {
  late Future<double> totalCPD;
  late Future<double> totalSpent;
  DateTime dateNow = DateTime.now();
  DateTime firstDay = DateTime(DateTime.now().year, DateTime.now().month, 1);
  late int daysBetween;

  int GetDaysDifference() {
    int dateDifference = ((DateTime.now().difference(firstDay).inDays) + 1);
    // print(dateDifference);
    daysBetween = dateDifference;
    return dateDifference;
  }

  String calculateCPD(data) {
    double receivedData = data;
    String cpdAmount = (receivedData / daysBetween).toStringAsFixed(2);
    return cpdAmount;
  }

  Future<void> _handleRefresh() async {
    await totalSpent;
    await totalCPD;
  }

  @override
  void initState() {
    super.initState();
    GetDaysDifference();
    //This part needs to be updated to be manual or something
    funcCPD.getCPDtotal();
    totalCPD = funcCPD.getCPDtotal();
    funcSpent.getTotalSpent();
    totalSpent = funcSpent.getTotalSpent();
    setState(() {});
    // getCPDtotal();
    // totalCPD = getCPDtotal();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.black),
      child: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: totalSpent,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Your total CPD in ' + month + ':',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          (calculateCPD(snapshot.data) + '€'),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 64,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  //put loading here
                  return Text(
                    '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
