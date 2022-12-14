// ignore_for_file: prefer_const_constructors, unused_field, use_build_context_synchronously, avoid_print, prefer_interpolation_to_compose_strings, unnecessary_string_interpolations, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:costlynew/auth/main_page.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _emailController = TextEditingController();
  final piggybank = Image(image: AssetImage('assets/images/piggybank.png'));
  final costlyLogo = Image(
    image: AssetImage('assets/icons/costlylogo.png'),
    width: 250,
  );

  Future forgotPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Password reset email sent! Don\'t forget to check the spam folder!'),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);

      if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wrong password entered.'),
          ),
        );
      }
      if (e.code == 'too-many-requests') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You have tried too often, try again later.'),
          ),
        );
      }
      if (e.code == 'missing-email') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No Email Address entered'),
          ),
        );
      }
      if (e.code == 'unknown') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wrong email or password entered, please try again.'),
          ),
        );
      }
      if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The email you entered is not valid.'),
          ),
        );
      }

      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('This user does not exist.'),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  final bool _isObscure = true;

  Widget mobileForget(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text('Reset Password'),
        //   backgroundColor: Colors.black,
        //   automaticallyImplyLeading: false,
        // ),
        body: Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
              child: SizedBox(
                height: 70,
                child: Image(image: AssetImage('assets/icons/costlylogo.png')),
              ),
            ),
            //Login Module
            Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter account email',
                          ),
                        ),
                      ),
                    ),
                  ),

                  //Password down here
                  SizedBox(
                    height: 10,
                  ),

                  SizedBox(height: 50),
                  //Login Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap: forgotPassword,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.orange[800],
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                          child: Text(
                            'Reset Password',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  Text(
                    'Check spam folder for reset email!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget desktopForget(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(100, 50, 100, 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: piggybank,
            ),
            SizedBox(
              width: 150,
            ),
            Container(
              width: 620,
              height: 872,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 10,
                    blurRadius: 30,
                    offset: Offset(0, 0), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(75, 75, 75, 75),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      costlyLogo,
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Text(
                          'Reset Password',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w800, fontSize: 36),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Text(
                          'Email Address',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w600, fontSize: 24),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Email',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: forgotPassword,
                          child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: Colors.orange[800],
                                  borderRadius: BorderRadius.circular(12)),
                              child: Center(
                                  child: Text('Reset Password',
                                      style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600)))),
                        ),
                      ),
                    ]),
              ),
            )
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
          return desktopForget(context);
        } else {
          return mobileForget(context);
        }
      },
    );
  }
}
