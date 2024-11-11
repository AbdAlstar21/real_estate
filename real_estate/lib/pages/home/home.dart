// ignore_for_file: non_constant_identifier_names, use_key_in_widget_constructors, duplicate_ignore

import 'dart:developer';

import 'package:real_estate/pages/realty_details/realty_details.dart';

import 'package:real_estate/pages/drawer/drawer.dart';
import 'package:real_estate/pages/function.dart';
import 'package:flutter/material.dart';
import 'package:real_estate/pages/config.dart';
import 'package:provider/provider.dart';

import '../realtys/realyts_data.dart';
import '../realtys/realtys_all.dart';
import '../realtys/realty_cat.dart';
import '../realtys/Realty_fav_num.dart';
import '../realtys/realtys_new.dart';
import '../realtys/realtys_old.dart';
import '../realtys/realtys_rent.dart';
import '../realtys/realtys_pay.dart';
import '../categories/categories.dart';
import '../provider/loading.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // List<RealtyData>? realtyListall;

  final GlobalKey<ScaffoldState> _keyDrawer = GlobalKey<ScaffoldState>();
  // ignore: non_constant_identifier_names
  ///
  ///
  void getrepname(int count, String strSearch) async {
    setState(() {});
    List arr = await getData(count, "reports/readrep.php", strSearch, "");
    for (int i = 0; i < arr.length; i++) {
      repList!.add(Rep(rep_id: arr[i]["rep_id"], rep_note: arr[i]["rep_note"]));
    }
    setState(() {});
  }

  ScrollController? myScroll;
  GlobalKey<RefreshIndicatorState>? refreshKey;
  int i = 0;
  bool loadingList = false;
  bool loadingListCatNI = false;
  void getDataCatNI(int count, String strSearch) async {
    loadingListCatNI = true;
    setState(() {});
    List arr = await getData(count, "categories/readcat.php", strSearch, "");
    for (int i = 0; i < arr.length; i++) {
      catNIListAll!.add(CatNI(
        cat_id: arr[i]["cat_id"],
        cat_name: arr[i]["cat_name"],
      ));
    }
    loadingListCatNI = false;
    setState(() {});
  }

  void getDataRealty(int count, String strSearch) async {
    loadingList = true;
    setState(() {});
    List arr = await getData(count, "realtys/readrealty_user.php", strSearch,
        "user_id=${G_user_id_val}&");
    for (int i = 0; i < arr.length; i++) {
      realtyListall!.add(RealtyData(
        rep_id: arr[i]["rep_id"],
        realty_id: arr[i]["realty_id"], //
        cat_id: arr[i]["cat_id"],
        fav_id: arr[i]["fav_id"],
        realty_short_title: arr[i]["realty_short_title"], //
        number_phone: arr[i]["number_phone"],
        realty_type: arr[i]["realty_type"], //
        realty_block: arr[i]["realty_block"] == "1" ? true : false,
        realty_date: arr[i]["realty_date"],
        realty_summary: arr[i]["realty_summary"],
        realty_thumbnail: arr[i]["realty_thumbnail"],
        realty_fav_number: (arr[i]["realty_fav_number"]).toString(),
       
        realty_price: arr[i]["realty_price"], //
      ));
    }
    loadingList = false;
    setState(() {});
  }

  // @override
  // void dispose() {
  //   // ignore: todo
  //   // TODO: implement dispose
  //   super.dispose();
  //   myScroll!.dispose();
  //   realtyListall!.clear();
  // }
  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    myScroll!.dispose();
    realtyListall!.clear();
    catNIListAll!.clear();
    repList!.clear();
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    // realtyListall = <RealtyData>[];
    // catNIListAll = <CatNI>[];
    // myScroll = ScrollController();
    // refreshKey = GlobalKey<RefreshIndicatorState>();
    // repList = <Rep>[];

    // getDataCatNI(0, "");
    // getrepname(0, "");
    // getDataRealty(0, "");
    

    myScroll?.addListener(() {
      if (myScroll!.position.pixels == myScroll?.position.maxScrollExtent) {
        i += 10;
        getDataRealty(i, "");
        getDataCatNI(i, "");
        getrepname(i, "");

        // ignore: avoid_print
        print("scroll");
      }
    });
  }

  // @override
  // void initState() {

  //   // ignore: todo
  //   // TODO: implement initState
  //   super.initState();
  //    repList = <Rep>[];
  //   realtyListall = <RealtyData>[];
  //   myScroll = ScrollController();
  //   refreshKey = GlobalKey<RefreshIndicatorState>();

  //   getrepname(0, "");

  //       // getDataRealty(0, "");

  //   myScroll?.addListener(() {
  //     if (myScroll!.position.pixels == myScroll?.position.maxScrollExtent) {
  //       i += 10;
  //       getDataRealty(i, "");
  //       // ignore: avoid_print
  //       print("scroll");
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var myProv = Provider.of<LoadingControl>(context);
    return DefaultTabController(
      length: 7,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          // backgroundColor: Colors.white,
          key: _keyDrawer,
          // endDrawer: const myDrawer(),
          drawer: const myDrawer(),
          drawerScrimColor: pcWhite,
          body: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                floating: true,
                snap: true,
                leading: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: const Icon(
                        Icons.menu,
                        size: 35.0,
                        // color: pcBlue,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      tooltip: MaterialLocalizations.of(context)
                          .openAppDrawerTooltip,
                    );
                  },
                ),
                // backgroundColor: Colors.white,
                title: Container(
                  height: 45,
                  alignment: Alignment.bottomRight,
                  margin: const EdgeInsets.only(top: 50.0, bottom: 50),
                  // padding: const EdgeInsets.only(top:3),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Container(
                        margin: const EdgeInsets.only(left: 20),
                        padding: const EdgeInsets.only(right: 20, left: 5),
                        decoration: BoxDecoration(
                            color: pcGrey,
                            borderRadius: BorderRadius.circular(40.0)),
                        child: TextField(
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "بحث",
                              suffixIcon: const Icon(
                                Icons.search,
                                color: pcPinkLight,
                              )),
                          onChanged: (text) {
                            // log(text);

                           
  realtyListall!.clear();
                    catNIListAll!.clear();
                            i = 0;

                        getDataCatNI(0, text);
                            getDataRealty(0, text);
                       

                            // getDataRealty(0, text);

                            myProv.add_loading();
                          },
                        ),
                        // TextFormField(
                        //   decoration: const InputDecoration(
                        //     hintText: " بحث",
                        //     suffixIcon: Icon(
                        //       Icons.search,
                        //       color: pcGrey,
                        //     ),

                        //     // border: InputBorder.none,
                        //   ),
                        // ),
                      )),
                      // Container(
                      //   margin: const EdgeInsets.all(5.0),
                      //   padding: const EdgeInsets.all(5.0),
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(5.0),
                      //   ),
                      //   child: const Icon(
                      //     Icons.mic,
                      //     color: Colors.blue,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                //end title//

                bottom: TabBar(
                  isScrollable: true,
                  unselectedLabelColor: pcBlack,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: pcGrey,
                  ),
                  tabs: [
                    Tab(
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                            // color: pcGrey,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: pcGrey, width: 2)),
                        child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'جميع العقارات',
                              style:
                                  TextStyle(fontFamily: "Cairo", fontSize: 17),
                            )),
                      ),
                    ),
                    Tab(
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            // border: Border.all(color: Colors.blue, width: 1)),
                            border: Border.all(color: pcGrey, width: 2)),
                        child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'الأكثر تفضيل',
                              style:
                                  TextStyle(fontFamily: "Cairo", fontSize: 17),
                            )),
                      ),
                    ),
                    Tab(
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            // border: Border.all(color: Colors.blue, width: 1)),
                            border: Border.all(color: pcGrey, width: 2)),
                        child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'الآجار',
                              style:
                                  TextStyle(fontFamily: "Cairo", fontSize: 17),
                            )),
                      ),
                    ),
                    Tab(
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            // border: Border.all(color: Colors.blue, width: 1)),
                            border: Border.all(color: pcGrey, width: 2)),
                        child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'البيع',
                              style:
                                  TextStyle(fontFamily: "Cairo", fontSize: 17),
                            )),
                      ),
                    ),
                    Tab(
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            // border: Border.all(color: Colors.blue, width: 1)),
                            border: Border.all(color: pcGrey, width: 2)),
                        child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'الأحدث',
                              style:
                                  TextStyle(fontFamily: "Cairo", fontSize: 17),
                            )),
                      ),
                    ),
                    Tab(
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            // border: Border.all(color: Colors.blue, width: 1)),
                            border: Border.all(color: pcGrey, width: 2)),
                        child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'الأقدم',
                              style:
                                  TextStyle(fontFamily: "Cairo", fontSize: 17),
                            )),
                      ),
                    ),
                    Tab(
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            // border: Border.all(color: Colors.blue, width: 1)),
                            border: Border.all(color: pcGrey, width: 2)),
                        child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'الأنواع',
                              style:
                                  TextStyle(fontFamily: "Cairo", fontSize: 17),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            body: TabBarView(
              children: <Widget>[
                RealtyAll(),
////start
                RealtyFavNum(),
//end
                ///
                RealtyPay(),
                RealtyRent(),

                RealtysNew(),
                //Text('Four'),
// old
                RealtyOld(),
                //end  old

                // Text('Six'),

                const Categories(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
