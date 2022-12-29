import 'package:flutter/material.dart';
import '../data/data.dart';

var funcCPD = GetCPDTotalYearly();
var funcSpent = GetTotalSpentDaily();

class DayTotal extends StatefulWidget {
  const DayTotal({Key? key}) : super(key: key);

  @override
  State<DayTotal> createState() => _DayTotalState();
}

class _DayTotalState extends State<DayTotal> {
  late Future<double> totalCPD;
  late Future<double> totalSpent;
  DateTime dateNow = DateTime.now();
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

  late bool _isLoading;
  void wait() async {
    GetDaysDifference();
    //This part needs to be updated to be manual or something
    funcCPD.getCPDtotal();
    totalCPD = funcCPD.getCPDtotal();
    funcSpent.getTotalSpentDaily();
    totalSpent = funcSpent.getTotalSpentDaily();
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
                    return Column(
                      children: [
                        Text(
                          'Total expenses: ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          ('${snapshot.data}€'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    );
                  } else {
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
