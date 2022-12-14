// ignore_for_file: prefer_const_constructors, unused_field, use_build_context_synchronously, avoid_print, prefer_interpolation_to_compose_strings, unnecessary_string_interpolations, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({
    Key? key,
    required this.showLoginPage,
  }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final piggybank = Image(image: AssetImage('assets/images/piggybank.png'));
  final costlyLogo = Image(
    image: AssetImage('assets/icons/costlylogo.png'),
    width: 250,
  );

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final bool _value = false;
  final db = FirebaseFirestore.instance;

  final _confirmPasswordController = TextEditingController();
  //final _usernameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    // _usernameController.dispose();
    super.dispose();
  }

  bool _isObscure = true;
  Future signUp() async {
    if (passwordConfirmed()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        //add user details
        addUserDetails(
          //      _usernameController.text.trim(),
          _emailController.text.trim(),
        );

        // newField.addMonthField();
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
        if (e.code == 'unknown') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fields have not been filled completely'),
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

        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password should be at least 6 characters.'),
            ),
          );
        }

        if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('This account already exists'),
            ),
          );
        }
      }
    }
  }

  Future addUserDetails(String email) async {
    await db
        .collection('userData')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set({
      // 'username': username,
      'email': email,
    });
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password is not the same'),
        ),
      );
      return false;
    }
  }

  Widget mobileRegister(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text('Register'),
        //   backgroundColor: Colors.black,
        //   automaticallyImplyLeading: false,
        // ),
        body: Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            //Login Module
            Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 0,
                    ),
                    Text(
                      'Register here!',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    //username
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       color: Colors.grey[200],
                    //       border: Border.all(color: Colors.white),
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //     child: Padding(
                    //       padding: const EdgeInsets.only(left: 20.0),
                    //       child: TextField(
                    //         controller: _usernameController,
                    //         decoration: InputDecoration(
                    //           border: InputBorder.none,
                    //           hintText: 'Username',
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 5,
                    ),
                    //email
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
                              hintText: 'Email',
                            ),
                          ),
                        ),
                      ),
                    ),

                    //Password down here
                    SizedBox(
                      height: 20,
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
                            controller: _passwordController,
                            obscureText: _isObscure,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Password',
                              suffixIcon: IconButton(
                                  icon: Icon(
                                    _isObscure
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  }),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 5),
                    //confirm password
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
                            controller: _confirmPasswordController,
                            obscureText: _isObscure,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Confirm Password',
                              suffixIcon: IconButton(
                                  icon: Icon(
                                    _isObscure
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  }),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Please ensure that password has more than 6 letters',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 50),
                    //Login Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: GestureDetector(
                        onTap: signUp,
                        child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.orange[800],
                                borderRadius: BorderRadius.circular(12)),
                            child: Center(
                                child: Text('Sign up',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    )))),
                      ),
                    ),
                    SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Text('Already a member?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        GestureDetector(
                          onTap: widget.showLoginPage,
                          child: Text(
                            ' Login Now',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget desktopRegister(BuildContext context) {
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
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
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
                          'Register',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w800, fontSize: 36),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'Already have an account?  ',
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w600, fontSize: 24),
                          ),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: widget.showLoginPage,
                              child: Text(
                                'Log In',
                                style: GoogleFonts.montserrat(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24,
                                    color: Colors.orange[800]),
                              ),
                            ),
                          )
                        ],
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
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Password',
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600, fontSize: 24),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '   Please ensure that password has more than 6 letters',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
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
                            controller: _passwordController,
                            obscureText: _isObscure,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Password',
                              suffixIcon: IconButton(
                                  icon: Icon(
                                    _isObscure
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  }),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextField(
                            controller: _confirmPasswordController,
                            obscureText: _isObscure,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Confirm Password',
                              suffixIcon: IconButton(
                                  icon: Icon(
                                    _isObscure
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  }),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: signUp,
                          child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: Colors.orange[800],
                                  borderRadius: BorderRadius.circular(12)),
                              child: Center(
                                  child: Text('Register',
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
          return desktopRegister(context);
        } else {
          return mobileRegister(context);
        }
      },
    );
  }
}
