import 'package:costlynew/data/data.dart';
import 'package:costlynew/data/tempFields.dart';
import 'package:costlynew/pages/plannedPurchases.dart';
import 'package:flutter/material.dart';
import 'package:costlynew/pages/deviceLayout.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:costlynew/data/data.dart';
import 'package:costlynew/pages/editExpenses.dart';

var funcGetPlans = new GetPlans();

class PlansWidget extends StatefulWidget {
  const PlansWidget({super.key});

  @override
  State<PlansWidget> createState() => _PlansWidgetState();
}

class _PlansWidgetState extends State<PlansWidget> {
  late Future<List<dynamic>> plans;
  final user = FirebaseAuth.instance.currentUser!;
  final db = FirebaseFirestore.instance;
  final year = (DateFormat('y').format(DateTime.now())).toString();
  final monthYear = (DateFormat('MMMM y').format(DateTime.now())).toString();
  final userID = FirebaseAuth.instance.currentUser?.uid;
  final _transactionName = TextEditingController();
  int listLength = 1;
  late Future<String> themeColor;
  late bool _isLoading;
  // Future<void> _handleRefresh() async {
  //   await plannedPurchases;
  // }

  void wait() async {
    _isLoading = true;
    funcGetPlans.getPlans();
    plans = funcGetPlans.getPlans();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      }); // Prints after 1 second.
    });
  }

  @override
  void initState() {
    super.initState();
    wait();
    //This part needs to be updated to be manual or something

    // getCPDtotal();
    // totalCPD = getCPDtotal();
  }

  double calculateCPD(duration, price) {
    double durationTime = double.parse(duration);
    double receivedPrice =
        double.parse(price); //then we take the price and turn it into a double
    String cpdAmount = (receivedPrice / durationTime).toStringAsFixed(2);
    double newcpdAmount = double.parse(cpdAmount);
    return newcpdAmount;
  }

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    return Expanded(
      child: Container(
        child: _isLoading
            ? ListView.separated(
                itemBuilder: ((context, index) => const AsyncBarRow()),
                separatorBuilder: ((context, index) => SizedBox(
                      height: 0,
                    )),
                itemCount: 10)
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: FutureBuilder(
                          future: plans,
                          builder: (context, snapshot) {
                            return ListView.builder(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: plannedPurchases.length,
                              itemBuilder: ((context, index) {
                                final item = plannedPurchases[index].toString();

                                return GestureDetector(
                                  child: Dismissible(
                                    key: Key(item),
                                    background: Container(
                                      color: Colors.red,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                    secondaryBackground: Container(
                                        color: Colors.red,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        alignment:
                                            AlignmentDirectional.centerEnd,
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        )),
                                    // Provide a function that tells the app
                                    // what to do after an item has been swiped away.
                                    onDismissed: (direction) async {
                                      {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    '${plannedPurchases[index]['itemName']} has been deleted.')));
                                        delPlans(
                                          (plannedPurchases[index]['duration'])
                                              .toString(),
                                          (plannedPurchases[index]['itemName'])
                                              .toString(),
                                          (plannedPurchases[index]['itemPrice'])
                                              .toString(),
                                          0,
                                        );
                                        //Remove the item from the data source.
                                        setState(() {
                                          plannedPurchases.removeAt(index);
                                        });

                                        await Future.delayed(
                                            Duration(seconds: 1));
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const PlannedPurchases()),
                                        );
                                      }

                                      // Then show a snackbar.
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 5, 15, 5),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: ListTile(
                                          title: Text(
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              (plannedPurchases[index]
                                                      ['itemName'])
                                                  .toString()),
                                          subtitle: Text(('Item Price: ' +
                                                  plannedPurchases[index]
                                                          ['itemPrice']
                                                      .replaceAll(
                                                          RegExp(r'\.'), ',') +
                                                  '€' +
                                                  '\nDuration: ' +
                                                  plannedPurchases[index]
                                                      ['duration'] +
                                                  '')
                                              .toString()),
                                          trailing: Wrap(
                                            spacing:
                                                0, // space between two icons
                                            children: <Widget>[
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 80.0),
                                                  child: SizedBox(
                                                    child: Text(
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                        (calculateCPD(
                                                                plannedPurchases[
                                                                        index][
                                                                    "duration"],
                                                                plannedPurchases[
                                                                        index][
                                                                    "itemPrice"]))
                                                            .toString()),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            );
                          }),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

class AsyncBarRow extends StatelessWidget {
  const AsyncBarRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(35, 35, 35, 20),
      child: Container(
        child: Row(
          children: [
            Expanded(child: AsyncBar()),
            Padding(
              padding: const EdgeInsets.fromLTRB(38, 0, 5, 0),
              child: AsyncBar(
                width: 110,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AsyncBar extends StatelessWidget {
  const AsyncBar({
    Key? key,
    this.height,
    this.width,
  }) : super(key: key);

  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: const BorderRadius.all(Radius.circular(16))),
    );
  }
}
