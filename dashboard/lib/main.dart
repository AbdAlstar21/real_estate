// @dart=2.9
// flutter run --no-sound-null-safety أو جرب تعليق   image_network: ^2.5.1
import 'package:dashboard/pages/account/login.dart';
import 'package:dashboard/pages/home/home.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter/material.dart';
import 'pages/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dashboard/pages/provider/loading.dart';
import 'package:provider/provider.dart';

void main() async {
//for api
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  G_user_id_val = prefs.getString(G_user_id);
//
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIMode(
  //   SystemUiMode.leanBack,
  // );
  runApp(Splash());
}

class Splash extends StatefulWidget {
  const Splash({Key key}) : super(key: key);
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<LoadingControl>(
            create: (context) => LoadingControl(),
          )
        ],
        child: MaterialApp(
            // theme: ThemeData.dark(),
            theme: ThemeData(
                fontFamily: "Cairo",
                primaryColor: pcPink,
                backgroundColor: pcWhite,
                appBarTheme: const AppBarTheme(

                    // toolbarTextStyle: TextStyle(color: Colors.black),
                    backgroundColor: pcPink,
                    // This will be applied to the "back" icon
                    iconTheme: IconThemeData(
                        color: Color.fromARGB(255, 231, 219, 182), size: 30),

                    // This will be applied to the action icon buttons that locates on the right side
                    // actionsIconTheme: IconThemeData(color: Colors.amber),
                    centerTitle: false,
                    // elevation: 15,
                    titleTextStyle: TextStyle(
                      color: Color.fromARGB(255, 231, 219, 182),
                      fontSize: 30,
                      fontFamily: "Cairo",
                      fontWeight: FontWeight.w600,
                      // fontWeight: FontWeight.bold,
                    ))),
            // // theme: ThemeData(fontFamily: 'GE_ar'),
            debugShowCheckedModeBanner: false,
            home: SplashScreen(
              seconds: 3,
              navigateAfterSeconds: G_user_id_val == null ? Login() : Home(),

              title: const Text(
                'تطبيق الإدارة',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                    fontFamily: "Cairo",
                    color: pcPink),
              ),
            
              styleTextUnderTheLoader: const TextStyle(),
              photoSize: 150.0,
              loaderColor: pcPink,
            )));
  }
}
