// ignore_for_file: use_key_in_widget_constructors

import 'package:real_estate/pages/account/login.dart';
import 'package:real_estate/pages/account/register.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_indicator/page_indicator.dart';
import '../config.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Tips extends StatefulWidget {
  const Tips({Key? key}) : super(key: key);

  @override
  _TipsState createState() => _TipsState();
}

class _TipsState extends State<Tips> {
  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height / 6;
    return Scaffold(
      backgroundColor: pcWhite,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.only(top: 30.0, right: 30.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Login()));
                },
                child: const Text(
                  "دخول",
                  style: TextStyle(
                    fontFamily: "Cairo",
                    color: pcPink,
                    fontSize: 24.0,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 315.0,
              child: DefaultTextStyle(
                style: const TextStyle(
                    fontSize: 30.0,
                    fontFamily: 'Agne',
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText('Real'),
                    TypewriterAnimatedText('Real estate'),
                    TypewriterAnimatedText('Real estate fair'),
                  ],
                  onTap: () {},
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                  height: myHeight * 1, child: Lottie.asset("lotties/9.json")),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                  height: myHeight * 1.8,
                  child: Lottie.asset("lotties/7.json")),
            ),
            Expanded(
              child: Container(
                height: myHeight,
                padding: const EdgeInsets.all(20.0),
                child: ListView(
                  children: <Widget>[
                    Column(
                      textDirection: TextDirection.rtl,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        MaterialButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Register(),
                                ));
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: pcPink,
                            ),
                            child: const Text(
                              "إنشاء حساب",
                              style: TextStyle(
                                  fontFamily: "Cairo",
                                  color: Colors.black,
                                  fontSize: 25.0),
                            ),
                          ),
                        ),
                        // Container(
                        //   padding: const EdgeInsets.all(5),
                        // ),
                        // MaterialButton(
                        //   onPressed: () {},
                        //   child: Container(
                        //     alignment: Alignment.center,
                        //     width: MediaQuery.of(context).size.width,
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(20.0),
                        //       color: const Color.fromARGB(255, 110, 120, 255),
                        //     ),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: const <Widget>[
                        //         Text(
                        //           "متابعة باستخدام الفيس بوك   ",
                        //           style: TextStyle(
                        //               fontFamily: "Cairo",
                        //               color: Colors.black,
                        //               fontSize: 25.0),
                        //         ),
                        //         FaIcon(
                        //           FontAwesomeIcons.facebookF,
                        //           size: 27.0,
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // Container(
                        //   padding: const EdgeInsets.all(5),
                        // ),
                        // MaterialButton(
                        //   onPressed: () {},
                        //   child: Container(
                        //     alignment: Alignment.center,
                        //     width: MediaQuery.of(context).size.width,
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(20.0),
                        //       color: Colors.redAccent,
                        //     ),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: const <Widget>[
                        //         Text(
                        //           "متابعة باستخدام جوجل             ",
                        //           style: TextStyle(
                        //               fontFamily: "Cairo",
                        //               color: Colors.black,
                        //               fontSize: 25.0),
                        //         ),
                        //         Text( "G",
                        //           style: TextStyle(
                        //               fontFamily: "Cairo",
                        //               color: Color.fromARGB(255, 82, 2, 2),
                        //                fontWeight: FontWeight.bold,
                        //               fontSize: 26.0),)
                        //       ],
                        //     ),
                        //   ),
                        // )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
