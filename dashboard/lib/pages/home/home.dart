// ignore_for_file: use_key_in_widget_constructors, non_constant_identifier_names
import 'dart:math';
// import 'package:dashboard/pages/eva/reports.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/pages/account/login.dart';
import 'package:dashboard/pages/config.dart';
import 'package:dashboard/pages/users/users.dart';
import '../realtys/realtys.dart';
import '../categories/categories.dart';
import '../reports/reports.dart';
import '../users/users.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  showAlertDialog(BuildContext context) {
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

  void logout(context) {
    prefs!.remove(G_user_id);
    prefs!.remove(G_user_name);
    prefs!.remove(G_user_email);
    prefs!.clear();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          backgroundColor: pcWhite,
          //////////////////////////////
          ///
          ///
          bottomNavigationBar: Directionality(
            textDirection: TextDirection.rtl,
            child: BottomNavigationBar(
              // backgroundColor: pcPink,

              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'الصفحة الرئيسية',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'الإعدادات',
                ),
              ],
              currentIndex: 0,
              selectedItemColor: pcPink,
              unselectedItemColor: Colors.grey,
              // selectedItemColor: Colors.amber,
              // unselectedItemColor: pcGrey,

              selectedLabelStyle:
                  const TextStyle(fontFamily: "Cairo", fontSize: 16),
              unselectedLabelStyle:
                  const TextStyle(fontFamily: "Cairo", fontSize: 15),
            ),
          ),

          ///
          ///
          //////////////////////////////
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text("إدارة التطبيق"),
            actions: [
              Container(
                padding: const EdgeInsets.all(10),
                child: InkWell(
                  onTap: () {
                    showAlertDialog(context);
                    // logout(context);
                  },
                  child: Icon(Icons.outbond, size: 35),
                ),
              )
            ],
          ),
          body: GridView(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 320,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
              ),
              padding: const EdgeInsets.fromLTRB(15, 85, 15, 85),
              children: List.generate(choices.length, (index) {
                return Center(
                  child: SelectCard(choice: choices[index]),
                );
              }))),
    );
  }
}

class Choice {
  final String title;
  final IconData icon;
  final Widget? page;
  void ChoicePage(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page!));
  }

  const Choice({
    // chontap
    required this.title,
    required this.icon,
    this.page,
  });
}

List<Choice> choices = <Choice>[
  const Choice(title: 'المستخدمين', icon: Icons.contacts, page: Users()),
  Choice(title: 'العقارات', icon: Icons.house, page: Realtys()),
  const Choice(
      title: 'أنواع العقارات', icon: Icons.category, page: Categories()),
  const Choice(title: 'الملاحظات', icon: Icons.report, page: Reports()),
];
void choiceontap(context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
}

class SelectCard extends StatelessWidget {
  const SelectCard({required this.choice});
  final Choice choice;
  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: pcPink, width: 4),
          borderRadius: BorderRadius.circular(24),
        ),
        // color: pcWhite,
        child: InkWell(
          onTap: () {
            choice.ChoicePage(context);
          },
          child: Center(
            child: FittedBox(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      choice.icon,
                      size: 60,
                      color: Colors
                          .primaries[Random().nextInt(Colors.primaries.length)],
                    ),
                    Text(
                      choice.title,
                      style: const TextStyle(
                          fontFamily: "Cairo",
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
            ),
          ),
        ));
  }
}
