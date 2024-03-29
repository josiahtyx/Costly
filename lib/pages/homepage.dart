// ignore_for_file: prefer_const_constructors, unused_field, use_build_context_synchronously, avoid_print, prefer_interpolation_to_compose_strings, unnecessary_string_interpolations, deprecated_member_use, unused_import

import 'package:costlynew/data/passerFunctions.dart';
import 'package:costlynew/pages/desktop/desktopPage.dart';
import 'package:costlynew/pages/homepage.dart';
import 'package:costlynew/pages/mobile/mobilePage.dart';
import 'package:costlynew/pages/totalexpensespage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // @override
  // void initState() {
  //   super.initState();

  //   GetTransactions();
  //   GetTransactionsYearly();
  //   GetCPDTotal();
  //   GetCPDTotalYearly();
  //   GetTotalSpent();
  //   GetTotalSpentYearly();
  // }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1480) {
          return DesktopPage();
        } else {
          return MobilePage();
        }
      },
    );
  }
}
