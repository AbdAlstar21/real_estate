//changed//

import 'dart:developer';
import 'dart:ui';

import 'package:real_estate/pages/realtys/single_realty_all.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_network/image_network.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/pages/realtys/realyts_data.dart';
import 'package:real_estate/pages/components/progres.dart';
import 'package:real_estate/pages/config.dart';
import 'package:real_estate/pages/function.dart';
import 'package:real_estate/pages/provider/loading.dart';
import 'package:real_estate/pages/realtys/widget_text.dart';

import '../realty_details/realty_details.dart';
import '../function.dart';
import '../home/home.dart';


List<CatNI>? catNIListAll;
// List<RealtyData>? realtyListall;

class RealtyAll extends StatefulWidget {
  @override
  _RealtyAllState createState() => _RealtyAllState();
}

class _RealtyAllState extends State<RealtyAll> {
  void getrepname(int count, String strSearch) async {
    setState(() {});
    List arr = await getData(count, "reports/readrep.php", strSearch, "");
    for (int i = 0; i < arr.length; i++) {
      repList!.add(Rep(rep_id: arr[i]["rep_id"], rep_note: arr[i]["rep_note"]));
    }
    setState(() {});
  }

//  List<RealtyData>? realtyListall;

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

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    myScroll!.dispose();
    realtyListall!.clear();
    catNIListAll!.clear();
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    realtyListall = <RealtyData>[];
    catNIListAll = <CatNI>[];
    myScroll = ScrollController();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    repList = <Rep>[];

    getDataCatNI(0, "");
    getDataRealty(0, "");
    getrepname(0, "");

    myScroll?.addListener(() {
      if (myScroll!.position.pixels == myScroll?.position.maxScrollExtent) {
        i += 10;
        getDataRealty(i, "");
        getDataCatNI(i, "");
        // ignore: avoid_print
        print("scroll");
      }
    });
  }

  bool isFabVisible = true;
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: pcWhite,
        body: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            if (notification.direction == ScrollDirection.forward) {
              setState(() {
                isFabVisible = true;
              });
            } else if (notification.direction == ScrollDirection.reverse) {
              setState(() {
                isFabVisible = false;
              });
            }
            return true;
          },
          child: loadingListCatNI || loadingList
              ? circularProgress()
              : RefreshIndicator(
                  onRefresh: () async {
                    i = 0;
                    realtyListall!.clear();
                    catNIListAll!.clear();
                    getDataCatNI(0, "");
                    getDataRealty(0, "");
                  },
                  key: refreshKey,
                  child: Container(
                      height: height * 0.9,
                      // color: Colors.green,
                      width: width,
                      child: Builder(builder: (context) {
                        List<int> indexs = [];
                        final item;
                        int counter = 0;

                        // print(catNIListAll!.length);
                        // print(realtyListall!.length);

                        for (var ci = 0; ci < catNIListAll!.length; ci++) {
                          counter = 0;
                          for (var bi = 0; bi < realtyListall!.length; bi++) {
                            if (realtyListall![bi].cat_id ==
                                catNIListAll![ci].cat_id) {
                              counter++;
                            }
                          }
                          if (counter == 0) {
                            indexs.add(ci);
                          }
                        }
                        int li = indexs.length;
                        for (var i = 0; i < li; i++) {
                          // log(catNIListAll![indexs[i]].cat_name);
                          catNIListAll!.removeAt(indexs[i]);
                          for (var j = i + 1; j < li; j++) {
                            indexs[j] = indexs[j] - 1;
                          }
                        }

                        // print(catNIListAll!.length);
                        // print(realtyListall!.length);

                        return ListView.builder(
                            itemCount: catNIListAll!.length,
                            itemBuilder: (cxt, j) {
                              return Column(
                                children: [
                                  Container(
                                    width: width,
                                    height: height * 0.048,
                                    // color: Colors.red,
                                    child: Text(
                                      catNIListAll![j].cat_name,
                                      style: TextStyle(
                                          fontFamily: "Cairo",
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                      width: width,
                                      height: height * 0.34,
                                      // color: Colors.amber,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: realtyListall!.length,
                                          // controller: myScroll,
                                          itemBuilder: (context, i) {
                                            if (realtyListall![i].cat_id ==
                                                catNIListAll![j].cat_id) {
                                              return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                RealtyDetails(
                                                                    realtys:
                                                                        realtyListall![
                                                                            i],
                                                                    realty_index:
                                                                        i)));
                                                  },
                                                  child: Container(
                                                      // color: Colors.amber,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 2,
                                                              right: 2),
                                                      // height: 250,
                                                      child:
                                                          SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.vertical,
                                                              child: Column(
                                                                children: [
                                                                  Stack(
                                                                    children: [
                                                                      Card(
                                                                          elevation:
                                                                              5.0,
                                                                          shadowColor:
                                                                              pcPinkLight,
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(15.0),
                                                                          ),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Container(
                                                                                width: width * 0.45,
                                                                                padding: const EdgeInsets.all(4.0),
                                                                                margin: const EdgeInsets.all(7.0),
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.circular(5.0),
                                                                                  color: pcPink,
                                                                                ),
                                                                                child: realtyListall![i].realty_thumbnail == "" || realtyListall![i].realty_thumbnail == null
                                                                                    ? ImageNetwork(
                                                                                        curve: Curves.easeInCubic,
                                                                                        onPointer: true,
                                                                                        debugPrint: true,
                                                                                        fullScreen: true,
                                                                                        fitAndroidIos: BoxFit.fill,
                                                                                        fitWeb: BoxFitWeb.fill,
                                                                                        image: imageRealty + "def.png",
                                                                                        width: 110,
                                                                                        height: 140,
                                                                                        onLoading: CircularProgressIndicator(
                                                                                          color: pcPinkLight,
                                                                                        ),
                                                                                        onError: const Icon(
                                                                                          Icons.error,
                                                                                          color: Colors.red,
                                                                                        ),
                                                                                      )
                                                                                    : ImageNetwork(
                                                                                        curve: Curves.easeInCubic,
                                                                                        onPointer: true,
                                                                                        debugPrint: true,
                                                                                        fullScreen: true,
                                                                                        fitAndroidIos: BoxFit.fill,
                                                                                        fitWeb: BoxFitWeb.fill,
                                                                                        image: imageRealty + realtyListall![i].realty_thumbnail,
                                                                                        width: 110,
                                                                                        height: 140,
                                                                                        onLoading: CircularProgressIndicator(
                                                                                          color: pcPinkLight,
                                                                                        ),
                                                                                        onError: const Icon(
                                                                                          Icons.error,
                                                                                          color: Colors.red,
                                                                                        ),
                                                                                      ),
                                                                              ),
                                                                              Container(
                                                                                height: height * 0.12,
                                                                                width: width * 0.38,
                                                                                // color: Colors.amber,
                                                                                child: SingleChildScrollView(
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      SingleChildScrollView(
                                                                                        scrollDirection: Axis.horizontal,
                                                                                        child: Row(
                                                                                          children: [
                                                                                            const Icon(
                                                                                              Icons.favorite,
                                                                                              color: Colors.red,
                                                                                            ),
                                                                                            Padding(padding: EdgeInsets.only(left: 5)),
                                                                                            Text(
                                                                                              realtyListall![i].realty_fav_number.toString(),
                                                                                              style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: "Cairo", fontSize: 17),
                                                                                            ),
                                                                                            Padding(padding: EdgeInsets.only(left: 30)),
                                                                                            const Text(
                                                                                              "\$",
                                                                                              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontFamily: "Cairo", fontSize: 17),
                                                                                            ),
                                                                                            Padding(padding: EdgeInsets.only(left: 5)),
                                                                                            Text(
                                                                                              realtyListall![i].realty_price,
                                                                                              style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: "Cairo", fontSize: 17),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      TextWidget(
                                                                                        text: realtyListall![i].realty_short_title,
                                                                                        fontSize: 15,
                                                                                        color: Color.fromARGB(255, 90, 68, 68),
                                                                                        isUnderLine: false,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          )),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ))));
                                            } else {
                                              return Container();
                                            }
                                          })),

                                  //     ],

                                  //           ),
                                  // ),
                                ],
                              );
                            });
                      })),
                ),
        ));
  }
}
