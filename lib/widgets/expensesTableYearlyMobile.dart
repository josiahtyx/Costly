import 'package:costlynew/data/data.dart';
import 'package:flutter/material.dart';
import 'package:costlynew/pages/deviceLayout.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:costlynew/data/data.dart';

var funcGetYear = new GetTransactionsYearly();

class ExpensesWidgetMobileAllTime extends StatefulWidget {
  const ExpensesWidgetMobileAllTime({super.key});

  @override
  State<ExpensesWidgetMobileAllTime> createState() =>
      _ExpensesWidgetMobileAllTimeState();
}

class _ExpensesWidgetMobileAllTimeState
    extends State<ExpensesWidgetMobileAllTime> {
  late Future<List<dynamic>> transactionsDataYear;
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
  //   await userTransactions;
  // }

  void wait() async {
    _isLoading = true;
    funcGetYear.getTransactions();
    transactionsDataYear = funcGetYear.getTransactions();
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

  _loadData() async {
    await funcGetYear.getTransactions();
    transactionsDataYear = funcGetYear.getTransactions();
    //print(transactionsDataMonth.toString());
  }

  Widget categoryButton(String index) {
    if (index == 'Entertainment') {
      return Container(
        width: 130,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 29, 206, 197),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: Text(
            textAlign: TextAlign.center,
            "Entertainment",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }
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
    if (index == 'Personal') {
      return Container(
        width: 130,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 128, 16),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: Text(
            textAlign: TextAlign.center,
            "Personal",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }
    if (index == 'Shopping') {
      return Container(
        width: 130,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 227, 196, 0),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: Text(
            textAlign: TextAlign.center,
            "Shopping",
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

    if (index == 'Utilities') {
      return Container(
        width: 130,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 193, 100, 50),
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

  Widget CPDday(String duration, String itemDate, String price) {
    if (duration == "0")
      return Text(
        textAlign: TextAlign.right,
        style: GoogleFonts.nunito(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        ((calculateCPDnow((itemDate), (price)))
                .toString()
                .replaceAll(RegExp(r'\.'), ',') +
            "€" +
            "/" +
            getDaysBetweenNow(itemDate).toString() +
            "d"),
      );
    else
      return Text(
        textAlign: TextAlign.right,
        style: GoogleFonts.nunito(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        (((calculateCPDfixed((duration), (price))).toString())
                .replaceAll(RegExp(r'\.'), ',') +
            "€" +
            "/" +
            duration.toString() +
            "d"),
      );
  }

  @override
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
                width: device.width * 0.8,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
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
                            if (duration == "0")
                              Text(
                                  style: GoogleFonts.nunito(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: device.height * 0.027,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  getDaysBetweenNow(purchaseDate).toString() +
                                      " days")
                            else
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
                            if (duration == "0")
                              Text(
                                style: GoogleFonts.nunito(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: device.height * 0.027,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                ((calculateCPDnow((purchaseDate), (price)))
                                        .toString()
                                        .replaceAll(RegExp(r'\.'), ',') +
                                    "€" +
                                    "/" +
                                    getDaysBetweenNow(purchaseDate).toString() +
                                    "d"),
                              )
                            else
                              Text(
                                style: GoogleFonts.nunito(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: device.height * 0.027,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                ((calculateCPDfixed((duration), (price)))
                                        .toString()
                                        .replaceAll(RegExp(r'\.'), ',') +
                                    "€" +
                                    "/" +
                                    duration +
                                    "d"),
                              )
                          ]),
                    ],
                  ),
                )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    return Container(
      width: device.width * 0.99,
      height: device.height * 0.626,
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
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: FutureBuilder(
                        future: transactionsDataYear,
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
                                  showDetailsMobile(
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
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
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
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

                                      await Future.delayed(
                                          Duration(seconds: 1));
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomePage()),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
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

                                      await Future.delayed(
                                          Duration(seconds: 1));
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
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: ListTile(
                                        title: Text(
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            (userTransactions[index]
                                                    ['itemName'])
                                                .toString()),
                                        // subtitle: Text(('Item Price: ' +
                                        //         userTransactions[index]['itemPrice']
                                        //             .replaceAll(RegExp(r'\.'), ',') +
                                        //         '€' +
                                        //         '\nPurchase Date: ' +
                                        //         userTransactions[index]['itemDate'] +
                                        //         '')
                                        //     .toString()),
                                        trailing: Wrap(
                                          spacing: 0, // space between two icons
                                          children: <Widget>[
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 80.0),
                                                child: SizedBox(
                                                  width: 150,
                                                  child: CPDday(
                                                      userTransactions[index]
                                                          ['duration'],
                                                      userTransactions[index]
                                                          ['itemDate'],
                                                      userTransactions[index]
                                                          ['itemPrice']),
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
