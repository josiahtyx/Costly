import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:costly/widgets/transactions_area.dart';
import '../data/passerFunctions.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:intl/intl.dart';

var funcCPD = new GetCPDTotalYearly();
var funcSpent = new GetTotalSpentYearly();

class CPDAreaYearly extends StatefulWidget {
  const CPDAreaYearly({Key? key}) : super(key: key);

  @override
  State<CPDAreaYearly> createState() => _CPDAreaYearlyState();
}

class _CPDAreaYearlyState extends State<CPDAreaYearly> {
  late Future<double> totalCPD;
  late Future<double> totalSpent;
  DateTime dateNow = new DateTime.now();
  DateTime firstDay = DateTime(DateTime.now().year, 1, 1);
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
    // getCPDtotal();
    // totalCPD = getCPDtotal();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.black),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 20, 40, 40),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: totalSpent,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      'Total expenses: ' + (snapshot.data.toString() + '€'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  } else {
                    return Text(
                      '',
                      style:  TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                        
                      ),
                    );
                  }
                },
              ),

              //TODO: Sum of all transaction's CPD
              // FutureBuilder(
              //   future: totalSpent,
              //   builder: (context, snapshot) {
              //     if (snapshot.hasData) {
              //       return Column(
              //         children: [
              //           Text(
              //             'Your total CPD this year:',
              //             textAlign: TextAlign.center,
              //             style: GoogleFonts.nunito(
              //               textStyle: TextStyle(
              //                 color: Colors.white,
              //                 fontSize: 30,
              //                 fontWeight: FontWeight.w400,
              //               ),
              //             ),
              //           ),
              //           Text(
              //             (calculateCPD(snapshot.data) + '€'),
              //             style: GoogleFonts.nunito(
              //               textStyle: TextStyle(
              //                 color: Colors.white,
              //                 fontSize: 30,
              //                 fontWeight: FontWeight.w400,
              //               ),
              //             ),
              //           ),
              //         ],
              //       );
              //     } else {
              //       //put loading here
              //       return Text(
              //         '',
              //         style: GoogleFonts.nunito(
              //           textStyle: TextStyle(
              //             color: Colors.white,
              //             fontSize: 30,
              //             fontWeight: FontWeight.w400,
              //           ),
              //         ),
              //       );
              //     }
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
