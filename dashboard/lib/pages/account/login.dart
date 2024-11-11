// ignore_for_file: non_constant_identifier_names

import 'package:dashboard/pages/account/login_data.dart';
import 'package:dashboard/pages/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:toast/toast.dart';
import '../components/progres.dart';
import '../provider/loading.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _formKey = GlobalKey<FormState>();
  bool isloading = false;
  TextEditingController txt_password = TextEditingController();
  TextEditingController txt_email = TextEditingController();
  void login(context, load) async {
    if (!await checkConnection()) {
      Toast.show("Not connected Internet", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
    if (txt_email.text.isNotEmpty &&
        txt_email.text.contains('.') &&
        txt_email.text.contains('@') &&
        txt_password.text.isNotEmpty &&
        txt_password.text.length >= 6) {
      isloading = true;
      load.add_loading();

      bool res = await loginUsers(txt_email.text, txt_password.text, context);

      isloading = res;
      load.add_loading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("واجهة تسجيل الدخول",
            style: TextStyle(
                
                )),
      
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          margin: const EdgeInsets.all(10.0),
          child: Column(children: <Widget>[
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(children: <Widget>[
                  
                  const Center(
                    child: Text(
                      "عقارات",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: "Cairo",
                        color: pcPink,
                        fontSize: 40.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      "واجهة تسجيل الدخول",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: "Cairo",
                        color: Color.fromARGB(255, 248, 225, 142),
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      "ادخل البريد الإلكتروني وكلمة المرور الخاصة بك\n                   للدخول إلى تطبيق الإدارة",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: "Cairo",
                        color: Color.fromARGB(255, 231, 219, 182),
                        // color: pcPink,
                        fontSize: 15.0,
                        // fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const Padding(padding: EdgeInsets.symmetric(vertical: 10)),

                  Container(
                    child: Icon(
                      Icons.account_circle,
                      size: 200,
                      color: pcPink,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    decoration: BoxDecoration(
                      color: pcGrey,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: TextFormField(
                      controller: txt_email,
                      decoration: const InputDecoration(
                          hintText: "البريد الإلكتروني",
                          border: InputBorder.none),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !value.contains('.') ||
                            !value.contains('@')) {
                          return 'الرجاء إدخال بريد إلكتروني صحيح';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    decoration: BoxDecoration(
                      color: pcGrey,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: TextFormField(
                      controller: txt_password,
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: "كلمة المرور", border: InputBorder.none),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال كلمة مرور';
                        }
                        if (value.length <= 8) {
                          return 'يجب أن تكون أكبر من 6 محارف';
                        }
                        return null;
                      },
                    ),
                  ),
                  Consumer<LoadingControl>(builder: (context, load, child) {
                    return isloading
                        ? circularProgress()
                        : MaterialButton(
                            onPressed: () {
                              login(context, load);
                              
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              child: const Text(
                                "دخول",
                                style: TextStyle(color: pcGrey, fontSize: 30.0),
                              ),
                              margin: const EdgeInsets.only(
                                  bottom: 10.0, top: 10.0),
                              // padding: const EdgeInsets.all(0.0),
                              decoration: BoxDecoration(
                                color: pcPink,
                                borderRadius: BorderRadius.circular(45.0),
                              ),
                            ));
                  }),
                  // Container(
                  //   margin: const EdgeInsets.only(top: 50.0),
                  //   alignment: Alignment.center,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: <Widget>[
                  //       const Text(
                  //         ' نسيت كلمة المرور...؟  ',
                  //         style: TextStyle(color: Colors.black, fontSize: 18.0),
                  //       ),
                  //       GestureDetector(
                  //         onTap: () {
                  //           // Navigator.push(
                  //           //     context,
                  //           //     MaterialPageRoute(
                  //           //         builder: (context) => const Forgot()));
                  //         },
                  //         child: const Text(
                  //           'أعد تعينها',
                  //           style: TextStyle(color: pcPink, fontSize: 19.0),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
