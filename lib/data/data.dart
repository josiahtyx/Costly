// ignore_for_file: file_names, unnecessary_new, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

int appThemeColor = (int.parse("0xffef6c00"));
final user = FirebaseAuth.instance.currentUser!;
final db = FirebaseFirestore.instance;
final monthYearPath = db
    .collection('userData')
    .doc(userID)
    .collection('transactions')
    .doc(monthYear);
final year = (DateFormat('y').format(DateTime.now())).toString();
final month = (DateFormat('MMMM').format(DateTime.now())).toString();
final monthYear = (DateFormat('MMMM y').format(DateTime.now())).toString();
final userID = FirebaseAuth.instance.currentUser?.uid;
DateTime? pickedDate;
int listLength = 1;

List<dynamic> userTransactions = [];
List<dynamic> userTransactionsYearly = [];
List<dynamic> userTransactionsDaily = [];
List<dynamic> plannedPurchases = [];
int getDaysBetweenNow(date) {
  DateTime receivedDate = DateTime.parse(date);
  int duration = ((DateTime.now().difference(receivedDate).inDays) + 1);
  return duration;
}

Future addPlans(
    String itemName, String price, String duration, int savedAmount) async {
  await db
      .collection('userData')
      .doc(userID)
      .collection('plans')
      .doc('plannedPurchases')
      .set({
    'plannedPurchases': FieldValue.arrayUnion(
      [
        {
          'itemName': itemName,
          'itemPrice': price,
          'duration': duration,
          'savedAmount': savedAmount,
        },
      ],
    ),
  }, SetOptions(merge: true));
}

double calculateCPDnow(date, price) {
  DateTime receivedDate = DateTime.parse(date);
  int dateDifference = ((DateTime.now().difference(receivedDate).inDays) + 1);
  // print(dateDifference
  double receivedPrice =
      double.parse(price); //then we take the price and turn it into a double
  String cpdAmount = (receivedPrice / dateDifference).toStringAsFixed(2);
  double newcpdAmount = double.parse(cpdAmount);
  return newcpdAmount;
}

double calculateCPDfixed(duration, price) {
  int durationD = int.parse(duration);
  double receivedPrice =
      double.parse(price); //then we take the price and turn it into a double
  String cpdAmount = (receivedPrice / durationD).toStringAsFixed(2);
  double newcpdAmount = double.parse(cpdAmount);
  return newcpdAmount;
}

// class GetYearlyTransactions {
//   Future<List<dynamic>> getYearlyTransactions() async {
//     final transactionsRef = db
//         .collection('userData')
//         .doc(userID)
//         .collection('transactions');

//     DocumentSnapshot snapshot = await transactionsRef.get();

//     final data = snapshot.data() as Map<String, dynamic>;
//     // print(data['transactions']);
//     List transactionList = (data['transactions']);
//     listLength = transactionList.length;
//     userTransactions = transactionList;
//     return transactionList;
//     // callBack(listLength);
//     // print(listLength);
//   }
// }

// class GetCPDTotalYearly {
//   Future<double> getCPDTotalYearly() async {
//     userTransactions = await funcGet.getTransactions();

//     double CPDsum = 0;
//     for (var i = 0; i < userTransactions.length; i++) {
//       CPDsum = CPDsum + double.parse(userTransactions[i]['costPerDay']);
//     }
//     // print(CPDsum);
//     String temp = CPDsum.toStringAsFixed(2);
//     // print(temp);
//     double finalCPDsum = double.parse(temp);
//     return finalCPDsum;
//   }
// }

//TODO: YearPicker class
// YearPicker(
//                           firstDate: DateTime(DateTime.now().year - 100, 1),
//                           lastDate: DateTime(DateTime.now().year + 100, 1),
//                           initialDate: DateTime.now(),
//                           // save the selected date to _selectedDate DateTime variable.
//                           // It's used to set the previous selected date when
//                           // re-showing the dialog.
//                           selectedDate: _selectedDate,
//                           onChanged: (DateTime dateTime) {
//                             // close the dialog when year is selected.
//                             Navigator.pop(context);
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => const HomePageYearly()),
//                             );
int daysInMonth() {
  DateTime now = new DateTime.now();
  DateTime lastDayOfMonth = new DateTime(now.year, now.month + 1, 0);
  //print("N days: ${lastDayOfMonth.day}");
  return lastDayOfMonth.day;
}

class GetPlans {
  Future<List<dynamic>> getPlans() async {
    final plansRef = db
        .collection('userData')
        .doc(userID)
        .collection('plans')
        .doc('plannedPurchases');

    DocumentSnapshot snapshot = await plansRef.get();
    final data = snapshot.data() as Map<String, dynamic>;
    // print(data['transactions']);
    List list = (data['plannedPurchases']);
    listLength = list.length;
    plannedPurchases = list;
    plannedPurchases..sort((a, b) => a['itemPrice'].compareTo(b['itemPrice']));
    return plannedPurchases;
    // callBack(listLength);
    // print(listLength);
  }
}

Future newTransactionFolder() async {
  monthYearPath.get().then(((value) => {
        if (value.exists)
          {
            //do nothing
          }
        else
          {
            print("Transaction Folder Made!"),
            monthYearPath.set({
              'transactions': FieldValue.arrayUnion(
                [],
              ),
            }, SetOptions(merge: true)),
          }
      }));
}

class GetTransactions {
  Future<List<dynamic>> getTransactions() async {
    final transactionsRef = db
        .collection('userData')
        .doc(userID)
        .collection('transactions')
        .doc(monthYear);

    DocumentSnapshot snapshot = await transactionsRef.get();
    final data = snapshot.data() as Map<String, dynamic>;
    // print(data['transactions']);
    List transactionList = (data['transactions']);
    listLength = transactionList.length;
    userTransactions = transactionList;
    userTransactions..sort((a, b) => a['itemDate'].compareTo(b['itemDate']));
    return userTransactions;
    // callBack(listLength);
    // print(listLength);
  }
}

class GetTransactionsYearly {
  Future<List<dynamic>> getTransactions() async {
    final transactionsRef = db
        .collection('userData')
        .doc(userID)
        .collection('transactions')
        .doc(
            'All'); //Change here between 'All' and (year) for present year. // TODO: Add year picker

    DocumentSnapshot snapshot = await transactionsRef.get();
    final data = snapshot.data() as Map<String, dynamic>;
    // print(data['transactions']);
    List transactionList = (data['transactions']);
    listLength = transactionList.length;
    userTransactions = transactionList;
    userTransactions..sort((a, b) => a['itemDate'].compareTo(b['itemDate']));
    return userTransactions;
    // callBack(listLength);
  }
}

Future updateTransaction(
  String category,
  String costPerDay,
  String duration,
  String endDate,
  String purchaseDate,
  String itemName,
  String price,
  //String daysBetween,
) async {
  await db
      .collection('userData')
      .doc(userID)
      .collection('transactions')
      .doc(monthYear)
      .set({
    'transactions': FieldValue.arrayUnion(
      [
        {
          'category': category,
          'costPerDay': costPerDay,
          'duration': duration,
          'endDate': endDate,
          'itemDate': purchaseDate,
          'itemName': itemName,
          'itemPrice': price,
          //'daysBetween': daysBetween,
        },
      ],
    ),
  }, SetOptions(merge: false));
  await db
      .collection('userData')
      .doc(userID)
      .collection('transactions')
      .doc(year)
      .set({
    'transactions': FieldValue.arrayUnion(
      [
        {
          'category': category,
          'costPerDay': costPerDay,
          'duration': duration,
          'endDate': endDate,
          'itemDate': purchaseDate,
          'itemName': itemName,
          'itemPrice': price,
          //'daysBetween': daysBetween,
        },
      ],
    ),
  }, SetOptions(merge: false));
  db
      .collection('userData')
      .doc(userID)
      .collection('transactions')
      .doc('All')
      .set({
    'transactions': FieldValue.arrayUnion(
      [
        {
          'category': category,
          'costPerDay': costPerDay,
          'duration': duration,
          'endDate': endDate,
          'itemDate': purchaseDate,
          'itemName': itemName,
          'itemPrice': price,
          //'daysBetween': daysBetween,
        },
      ],
    ),
  }, SetOptions(merge: false));
}

Future archiveTransaction(
  String category,
  //String costPerDay,
  String duration,
  String endDate,
  String purchaseDate,
  String itemName,
  String price,
  //String daysBetween,
) async {
  await db
      .collection('userData')
      .doc(userID)
      .collection('transactions')
      .doc(monthYear)
      .set({
    'transactions': FieldValue.arrayRemove(
      [
        {
          'category': category,
          // 'costPerDay': costPerDay,
          'duration': duration,
          'endDate': endDate,
          'itemDate': purchaseDate,
          'itemName': itemName,
          'itemPrice': price,
          //'daysBetween': daysBetween,
        },
      ],
    ),
  }, SetOptions(merge: true));
  await db
      .collection('userData')
      .doc(userID)
      .collection('transactions')
      .doc(year)
      .set({
    'transactions': FieldValue.arrayRemove(
      [
        {
          'category': category,
          // 'costPerDay': costPerDay,
          'duration': duration,
          'endDate': endDate,
          'itemDate': purchaseDate,
          'itemName': itemName,
          'itemPrice': price,
          //'daysBetween': daysBetween,
        },
      ],
    ),
  }, SetOptions(merge: true));
}

Future delPlans(
  String duration,
  String itemName,
  String price,
  int savedAmount,
  //String daysBetween,
) async {
  await db
      .collection('userData')
      .doc(userID)
      .collection('plans')
      .doc("plannedPurchases")
      .set({
    'plannedPurchases': FieldValue.arrayRemove(
      [
        {
          'duration': duration,
          'itemName': itemName,
          'itemPrice': price,
          'savedAmount': savedAmount,
        },
      ],
    ),
  }, SetOptions(merge: true));
}

Future<String> getProfileColor() async {
  DocumentSnapshot snapshot = await db.collection('userData').doc(userID).get();
  String color = snapshot.get('themeColor');
  appThemeColor = int.parse(color);
  //print('URL is ' + newURL);
  // url = newURL;
  return color;
}

Future delTransaction(
  String category,
  //String costPerDay,
  String duration,
  String endDate,
  String purchaseDate,
  String itemName,
  String price,
  //String daysBetween,
) async {
  await db
      .collection('userData')
      .doc(userID)
      .collection('transactions')
      .doc(monthYear)
      .set({
    'transactions': FieldValue.arrayRemove(
      [
        {
          'category': category,
          // 'costPerDay': costPerDay,
          'duration': duration,
          'endDate': endDate,
          'itemDate': purchaseDate,
          'itemName': itemName,
          'itemPrice': price,
          //'daysBetween': daysBetween,
        },
      ],
    ),
  }, SetOptions(merge: true));
  await db
      .collection('userData')
      .doc(userID)
      .collection('transactions')
      .doc(year)
      .set({
    'transactions': FieldValue.arrayRemove(
      [
        {
          'category': category,
          // 'costPerDay': costPerDay,
          'duration': duration,
          'endDate': endDate,
          'itemDate': purchaseDate,
          'itemName': itemName,
          'itemPrice': price,
          //'daysBetween': daysBetween,
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
    'transactions': FieldValue.arrayRemove(
      [
        {
          'category': category,
          //    'costPerDay': costPerDay,
          'duration': duration,
          'endDate': endDate,
          'itemDate': purchaseDate,
          'itemName': itemName,
          'itemPrice': price,
          //'daysBetween': daysBetween,
        },
      ],
    ),
  }, SetOptions(merge: true));
}

class AddMonthField {
  Future addMonthField() async {
    await db
        .collection('userData')
        .doc(userID)
        .collection('transactions')
        .doc(monthYear)
        .set({
      'transactions': FieldValue.arrayUnion(
        [
          {},
        ],
      ),
    }, SetOptions(merge: true));
  }
}

var funcGet = new GetTransactions();
var funcGetYear = new GetTransactionsYearly();
var funcGetDaily = new GetTransactionsDaily();
// String CPDCalculator(String itemPrice, date) {
//   double price = double.parse(itemPrice.replaceAll(',', '.'));
//   int theNumberofDaysBetween = int.parse(daysBetween);
//   String tempCPD = (price / (theNumberofDaysBetween + 1)).toStringAsFixed(2);
//   double totalCPD = double.parse(tempCPD);
//   String totalCPDstring = totalCPD.toString();
//   // double finalCPD = double.parse(totalCPDstring.replaceAll('.', ','));
//   return totalCPDstring;
// }

class GetCPDTotal {
  Future<double> getCPDtotal() async {
    userTransactions = await funcGet.getTransactions();

    double CPDsum = 0;
    for (var i = 0; i < userTransactions.length; i++) {
      CPDsum = CPDsum + double.parse(userTransactions[i]['costPerDay']);
    }
    // print(CPDsum);
    String temp = CPDsum.toStringAsFixed(2);
    // print(temp);
    double finalCPDsum = double.parse(temp);
    return finalCPDsum;
  }
}

class GetCPDTotalYearly {
  Future<double> getCPDtotal() async {
    userTransactionsYearly = await funcGetYear.getTransactions();

    double CPDsum = 0;
    for (var i = 0; i < userTransactionsYearly.length; i++) {
      CPDsum = CPDsum + double.parse(userTransactionsYearly[i]['costPerDay']);
    }
    // print(CPDsum);
    String temp = CPDsum.toStringAsFixed(2);
    // print(temp);
    double finalCPDsum = double.parse(temp);
    return finalCPDsum;
  }
}

class GetTotalSpent {
  Future<double> getTotalSpent() async {
    userTransactionsYearly = await funcGet.getTransactions();

    double Spentsum = 0;
    for (var i = 0; i < userTransactions.length; i++) {
      Spentsum = Spentsum + double.parse(userTransactions[i]['itemPrice']);
    }
    // print(CPDsum);
    String temp = Spentsum.toStringAsFixed(2);
    // print(temp);
    double finalSpentsum = double.parse(temp);
    return finalSpentsum;
  }
}

class GetTotalSpentYearly {
  Future<double> getTotalSpent() async {
    userTransactionsYearly = await funcGetYear.getTransactions();

    double Spentsum = 0;
    for (var i = 0; i < userTransactionsYearly.length; i++) {
      Spentsum =
          Spentsum + double.parse(userTransactionsYearly[i]['itemPrice']);
    }
    // print(CPDsum);
    String temp = Spentsum.toStringAsFixed(2);
    // print(temp);
    double finalSpentsum = double.parse(temp);
    return finalSpentsum;
  }
}

class GetTotalSpentDaily {
  Future<double> getTotalSpentDaily() async {
    String currentDayStr = DateFormat('yyyy-MM-dd').format(pickedDate!);
    userTransactionsYearly = await funcGetYear.getTransactions();
    double totalDay = 0;

    for (var i = 0; i < userTransactionsYearly.length; i++) {
      if (userTransactionsYearly[i]['itemDate'] == currentDayStr) {
        totalDay =
            totalDay + double.parse(userTransactionsYearly[i]['itemPrice']);
      }
    }
    // print(CPDsum);
    String temp = totalDay.toStringAsFixed(2);
    // print(temp);
    totalDay = double.parse(temp);
    return totalDay;
  }
}

class GetTransactionsDaily {
  Future<List<dynamic>> getTransactions() async {
    String currentDayStr = DateFormat('yyyy-MM-dd').format(pickedDate!);
    //print(userTransactions);
    final transactionsRef = db
        .collection('userData')
        .doc(userID)
        .collection('transactions')
        .doc(
            'All'); //Change here between 'All' and (year) for present year. // TODO: Add year picker

    DocumentSnapshot snapshot = await transactionsRef.get();
    final data = snapshot.data() as Map<String, dynamic>;
    // print(data['transactions']);
    List transactionList = (data['transactions']);
    listLength = transactionList.length;
    userTransactionsDaily = transactionList;
    userTransactionsDaily
      ..sort((a, b) => a['itemDate'].compareTo(b['itemDate']));
    userTransactionsDaily
        .removeWhere((item) => item['itemDate'] != currentDayStr);
    //print(userTransactionsDaily.toString());
    return userTransactionsDaily;
    // callBack(listLength);
  }
}

// class GetDateDifference {
//   Future<double> getDateDifference() async {
//     userTransactions = await funcGet.getTransactions();

//     DateTime transactionDate = DateTime.parse(userTransactions[index])
//     return finalSpentsum;
//   }
// }

// void printList() {
//   print(userTransactions[0]);
// }
Future delAllData(String uid) async {
  await db.collection('userData').doc(uid).delete();
  await user.delete();
}

Future delColor(String userID) async {
  await db
      .collection('userData')
      .doc(userID)
      .update({'themeColor': FieldValue.delete()});
}
