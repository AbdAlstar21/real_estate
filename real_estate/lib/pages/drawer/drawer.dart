// ignore_for_file: camel_case_types

import 'package:real_estate/pages/account/change_password.dart';
import 'package:real_estate/pages/account/myprofile.dart';
import 'package:real_estate/pages/config.dart';
import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import '../account/login.dart';
import '../realtys/favorite.dart';

class myDrawer extends StatefulWidget {
  const myDrawer({Key? key}) : super(key: key);

  @override
  _myDrawerState createState() => _myDrawerState();
}

class _myDrawerState extends State<myDrawer> {
   showAlertDialog_logout(BuildContext context) async {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("إلغاء الأمر", style: TextStyle(color: pcPink)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("موافق" , style: TextStyle(color: pcPink)),
      onPressed: () {
        logout(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Directionality(
          textDirection: TextDirection.rtl, child: Text("تأكيد الخروج" , style: TextStyle(color: pcPink))),
      content: Text("هل متأكد أنك تريد تسجيل الخروج"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  logout(context) async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    sh.remove(G_user_id);
    sh.remove(G_user_name);
    sh.remove(G_user_thumbnail);
    sh.remove(G_user_email);
    sh.clear();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Login()));

  }

  ///start alertDialog
  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("موافق"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.info, color: pcPink),
          const Text("معلومة",
              style:
                  const TextStyle(color: pcPink, fontWeight: FontWeight.w500)),
        ],
      ),
      content: const Text("عقارات"),
      elevation: 10,
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(textDirection: TextDirection.rtl, child: alert);
      },
    );
  }

  ///end alertDialog
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Directionality(
            textDirection: TextDirection.ltr,
            child: Container(
              color: pcGrey,
              // padding: const EdgeInsets.only(right:50 , left: 40),
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  ProfilePicture(
                    name: G_user_name_val,
                    radius: 37,
                    fontsize: 21,
                    random: true,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 5)),
                  Text(
                    G_user_name_val,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: "Cairo",
                        fontWeight: FontWeight.bold),
                  ),
                  Text(G_user_email_val,
                      style: const TextStyle(
                        color: Colors.black87,
                      )),
                  const Padding(padding: EdgeInsets.only(bottom: 5)),
                
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Column(
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: const ListTile(
                    title: Text("الصفحة الرئيسية",
                        style: TextStyle(
                            fontFamily: "Cairo",
                            fontSize: 20,
                            color: Colors.black)),
                    leading: Icon(
                      Icons.home,
                      color: pcPink,
                    ),
                    trailing:
                        Icon(Icons.arrow_back_ios_new, color: Colors.black),
                  ),
                ),
                Divider(
                  color: Colors.grey[500],
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyFavorite()));
                  },
                  child: const ListTile(
                    title: Text("المفضلة",
                        style: TextStyle(
                            fontFamily: "Cairo",
                            fontSize: 20,
                            color: Colors.black)),
                    leading: Icon(
                      Icons.favorite,
                      color: pcPink,
                    ),
                    trailing:
                        Icon(Icons.arrow_back_ios_new, color: Colors.black),
                  ),
                ),
                Divider(
                  color: Colors.grey[500],
                )
              ],
            ),
          ),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: const Text("حسابي",
                  style: TextStyle(
                      fontFamily: "Cairo", fontSize: 20, color: Colors.black)),
              children: [
                ///child star account
                Container(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyProfile()));
                        },
                        child: const ListTile(
                          title: Text("تغيير الإعدادات الشخصية",
                              style: TextStyle(
                                  fontFamily: "Cairo",
                                  fontSize: 17,
                                  color: Colors.black)),
                          leading: Icon(
                            Icons.person,
                            color: pcPink,
                          ),
                          // trailing: Icon(Icons.arrow_back_ios_new,
                          //     color: Colors.black),
                        ),
                      ),
                      Divider(
                        color: Colors.grey[500],
                      )
                    ],
                  ),
                ),

                ///child end account
                ///child star account
                Container(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ChangePassword()));
                        },
                        child: const ListTile(
                          title: Text("تغيير كلمة المرور",
                              style: TextStyle(
                                  fontFamily: "Cairo",
                                  fontSize: 17,
                                  color: Colors.black)),
                          leading: Icon(
                            Icons.lock_open,
                            color: pcPink,
                          ),
                          // trailing: Icon(Icons.arrow_back_ios_new,
                          //     color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),

                ///child end account
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Divider(
              color: Colors.grey[500],
            ),
          ),
          
          Container(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Column(
              children: [
                InkWell(
                  onTap: () {},
                  child: const ListTile(
                    title: Text("الإعدادات",
                        style: TextStyle(
                            fontFamily: "Cairo",
                            fontSize: 20,
                            color: Colors.black)),
                    leading: Icon(
                      Icons.settings,
                      color: pcPink,
                    ),
                    trailing:
                        Icon(Icons.arrow_back_ios_new, color: Colors.black),
                  ),
                ),
                Divider(
                  color: Colors.grey[500],
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    showAlertDialog(context);
                  },
                  child: const ListTile(
                    title: Text("حول التطبيق",
                        style: TextStyle(
                            fontFamily: "Cairo",
                            fontSize: 20,
                            color: Colors.black)),
                    leading: Icon(
                      Icons.help,
                      color: pcPink,
                    ),
                    trailing:
                        Icon(Icons.arrow_back_ios_new, color: Colors.black),
                  ),
                ),
                Divider(
                  color: Colors.grey[500],
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Column(
              children: [
                InkWell(
                  onTap: () {},
                  child: const ListTile(
                    title: Text("مشاركة التطبيق",
                        style: TextStyle(
                            fontFamily: "Cairo",
                            fontSize: 20,
                            color: Colors.black)),
                    leading: Icon(
                      Icons.share,
                      color: pcPink,
                    ),
                    trailing:
                        Icon(Icons.arrow_back_ios_new, color: Colors.black),
                  ),
                ),
                Divider(
                  color: Colors.grey[500],
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    showAlertDialog_logout(context);

                  },
                  child: const ListTile(
                    title: Text("تسجيل الخروج",
                        style: TextStyle(
                            fontFamily: "Cairo",
                            fontSize: 20,
                            color: Colors.black)),
                    leading: Icon(
                      Icons.logout,
                      color: pcPink,
                    ),
                    trailing:
                        Icon(Icons.arrow_back_ios_new, color: Colors.black),
                  ),
                ),
                Divider(
                  color: Colors.grey[500],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
