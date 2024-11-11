// ignore_for_file: non_constant_identifier_names, sized_box_for_whitespace, use_key_in_widget_constructors

import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:footer/footer.dart';
import 'package:http/http.dart' as http;
import 'package:image_network/image_network.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import 'package:real_estate/pages/config.dart';

import '../realtys/realyts_data.dart';
import '../realtys/single_fav.dart';
import '../components/progres.dart';
import '../function.dart';
import '../provider/loading.dart';

List<Rep>? repList;
// List<RealtyData>? realtyList;
List<RealtyData>? realtyListF;

class Rep {
  String rep_id;
  String rep_note;
  Rep({
    required this.rep_id,
    required this.rep_note,
  });
}

class RealtyDetails extends StatefulWidget {
  int? realty_index;
  RealtyData realtys;
  RealtyDetails({
    Key? key,
    this.realty_index,
    required this.realtys,
  }) : super(key: key);
  @override
  _RealtyDetailsState createState() => _RealtyDetailsState();
}

class _RealtyDetailsState extends State<RealtyDetails> {
  TextEditingController txtrep_note = TextEditingController();

  Color cl_g = Colors.grey;
  Color? cl;
  IconData? ic;
  Color cl_p = pcPink;
  IconData ic_b = Icons.favorite_border;
  IconData ic_f = Icons.favorite;

  var rep_note;

  var rep_id_list = repList!.map((e) {
    return e.rep_id;
  }).toList();

  var rep_note_list = repList!.map((e) {
    return e.rep_note;
  }).toList();
  void getNI() {
    for (int i = 0; i < repList!.length; i++) {
      if (rep_id_list[i] == widget.realtys.rep_id) {
        // print(rep_id_list[i]);
        rep_note = rep_note_list[i];
      }
    }
  }

  bool isloading = false;

  saveRep(context, LoadingControl load) async {
    if (!await checkConnection()) {
      Toast.show("Not connected Internet", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
    load.add_loading();
    if (txtrep_note.text.isNotEmpty) {
      isloading = true;
      load.add_loading();
      Map arr = {
        "user_id": G_user_id_val,
        "realty_id": widget.realtys.realty_id,
        "rep_note": txtrep_note.text,
        "realty_short_title": title,
      };
      Map res = await SaveDataListRepEva(
          arr,
          "reports/insert_rep.php",
          () => RealtyDetails(
              realtys: widget.realtys, realty_index: widget.realty_index),
          context,
          "insert");

      isloading = res != null ? true : false;
      if (isloading) {
        repList![widget.realty_index!].rep_id = res["rep_id"];
        widget.realtys.rep_id = res["rep_id"];
        load.add_loading();
      }

      load.add_loading();
    } else {
      Toast.show("لا يمكن أن يكون الحقل فارغا", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  editRep(context, LoadingControl load) async {
    if (!await checkConnection()) {
      Toast.show("Not connected Internet", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
    isloading = true;
    load.add_loading();
    Map arr = {
      "rep_id": widget.realtys.rep_id,
      "rep_note": txtrep_note.text,
    };
    Map res = await SaveDataListRepEva(
        arr,
        "reports/update_rep.php",
        () => RealtyDetails(
            realtys: widget.realtys, realty_index: widget.realty_index),
        context,
        "insert");

    isloading = res != null ? true : false;
    if (isloading) {
      repList![widget.realty_index!].rep_id = res["rep_id"];
      widget.realtys.rep_id = res["rep_id"];

      load.add_loading();
    }

    load.add_loading();
  }

  _displayDialog(BuildContext context, LoadingControl load) async {
    return showDialog(
        context: context,
        builder: (context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: Row(
                children: const [
                  Icon(Icons.info, color: pcPink),
                  Text("أكتب ملاحظتك عن العقار",
                      style: TextStyle(
                          color: pcPink, fontWeight: FontWeight.w500)),
                ],
              ),
              content: TextField(
                controller: txtrep_note,
                decoration: InputDecoration(hintText: "أدخل النص هنا"),
              ),
              actions: [
                MaterialButton(
                  child: Container(
                    child: widget.realtys.rep_id == null ||
                            widget.realtys.rep_id == "" ||
                            txtrep_note.text == null ||
                            txtrep_note.text == ""
                        ? const Text("ارسال الملاحظة",
                            style: TextStyle(
                              color: pcPink,
                              fontSize: 20,
                            ))
                        : Text("تعديل الملاحظة",
                            style: TextStyle(
                              color: pcPink,
                              fontSize: 20,
                            )),
                  ),
                  onPressed: () {
                    if (widget.realtys.rep_id == null ||
                        widget.realtys.rep_id == "") {
                      saveRep(context, load);
                      Navigator.of(context).pop();
                      RealtyDetails(
                          realtys: widget.realtys,
                          realty_index: widget.realty_index);
                    } else {
                      editRep(context, load);
                      RealtyDetails(
                          realtys: widget.realtys,
                          realty_index: widget.realty_index);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
          );
        });
  }

  void getrepname(int count, String strSearch) async {
    setState(() {});
    List arr = await getData(count, "reports/readrep.php", strSearch, "");
    for (int i = 0; i < arr.length; i++) {
      repList!.add(Rep(rep_id: arr[i]["rep_id"], rep_note: arr[i]["rep_note"]));
    }
    // setState(() {});
  }

//start updateFavorite
  updateFavP(context) async {
    Map arr = {
      "realty_id": widget.realtys.realty_id,
    };
    bool res =
        await updateFavorite(arr, "realtys/update_fav_num_p.php", context);
  }

  updateFavM(context) async {
    Map arr = {
      "realty_id": widget.realtys.realty_id,
    };
    bool res =
        await updateFavorite(arr, "realtys/update_fav_num_m.php", context);
  }

  // void getDataRealty(int count, String strSearch) async {
  //   setState(() {});
  //   List arr = await getData(count, "realtys/readrealty_user.php", strSearch,
  //       "cat_id=${widget.realtys.cat_id}&user_id=${G_user_id_val}&");
  //   for (int i = 0; i < arr.length; i++) {
  //     realtyList!.add(RealtyData(
  //       realty_id: arr[i]["realty_id"], //
  //       cat_id: arr[i]["cat_id"],
  //       fav_id: arr[i]["fav_id"],
  //       rep_id: arr[i]["rep_id"],

  //       realty_short_title: arr[i]["realty_short_title"], //
  //       number_phone: arr[i]["book_author_name"],
  //       realty_type: arr[i]["realty_type"], //
  //       realty_block: arr[i]["realty_block"] == "1" ? true : false,
  //       realty_date: arr[i]["realty_date"],
  //       realty_summary: arr[i]["realty_summary"],
  //       realty_thumbnail: arr[i]["realty_thumbnail"],
  //       realty_fav_number: (arr[i]["realty_fav_number"]).toString(),

  //       realty_price: arr[i]["realty_price"], //
  //     ));
  //   }
  //   setState(() {});
  // }

  bool isloadingFav = false;
  saveFavorite(String fav_id, String realty_id, int realty_index, context,
      LoadingControl load) async {
    if (widget.realtys.fav_id != null && widget.realtys.fav_id != "") {
      bool res = await deleteData("fav_id", fav_id, "favorite/delete_fav.php");
      // widget.realtys.fav_id = "";
      // realtyListF![realty_index].fav_id = "";
      isloadingFav = res;
      if (isloadingFav) {
        realtyListF![realty_index].fav_id = "";
        // widget.realtys.fav_id = "";
        load.add_loading();
      }
    } else {
      isloadingFav = true;
      
      Map arr = {"user_id": G_user_id_val, "realty_id": realty_id};
      Map resArray =
          await SaveDataList(arr, "favorite/insert_fav.php", context, "insert");
      // widget.realtys.fav_id = resArray["fav_id"];
      // widget.realtys.fav_id = resArray["fav_id"];
      isloadingFav = resArray != null ? true : false;
      if (isloadingFav) {
        realtyListF![realty_index].fav_id = resArray["fav_id"];
        // widget.realtys.fav_id = resArray["fav_id"];

        load.add_loading();
      }
      load.add_loading();
    }
  }

  ScrollController? myScroll;
  String? title;
  @override
  void initState() {
    setState(() {});
    if (widget.realtys.rep_id == null ||
        widget.realtys.rep_id == "" ||
        rep_note == "" ||
        rep_note == null) {
      deleteData("rep_id", widget.realtys.rep_id, "reports/delete_rep.php");
    }
    getNI();
    // getDataRealty(0, "");
    txtrep_note.text = rep_note;
    title = widget.realtys.realty_short_title;
    getrepname(0, "");
    if (widget.realtys.fav_id == null || widget.realtys.fav_id == "") {
      cl = Colors.grey;
      ic = Icons.favorite_border;
    } else {
      cl = pcPink;
      ic = Icons.favorite;
    }

    super.initState();
  }

  @override
  void dispose() {
    // realtyList = [];
     realtyListF = [];
    // IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  Widget RealtyImage() {
    return Container(
      alignment: Alignment.topCenter,
      decoration: const BoxDecoration(
        color: pcPinkLight,
        boxShadow: [
          BoxShadow(
            color: pcPink,
            spreadRadius: 5,
            blurRadius: 8,
            offset: Offset(0, 8),
          ),
        ],
        // borderRadius: BorderRadius.only(
        //   bottomLeft: Radius.circular(0),
        // )
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.only(top: 0, bottom: 0, left: 15, right: 5),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 35,
                    color: pcPink,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const Expanded(child: Text("")),
                // MyPopMenu(
                //     realtys: widget.realtys, realty_index: widget.realty_index),
                Consumer<LoadingControl>(builder: (context, load, child) {
                  return PopupMenuButton(
                      onSelected: ((value) {
                        if (value == 4) {
                          _displayDialog(context, load);
                        }
                      }),
                      color: Colors.white,
                      iconSize: 30,
                      itemBuilder: (context) => [
                            PopupMenuItem(
                                value: 4,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: const <Widget>[
                                    Text('ارسل ملاحظة'),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(16, 2, 2, 2),
                                      child: Icon(
                                        Icons.report,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ],
                                )),
                          ]);
                })
              ],
            ),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  // width: MediaQuery.of(context).size.width - 20,

                  child:
                      //////
                      Column(
                    children: <Widget>[
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5.0),
                            margin: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: pcPink,
                            ),
                            child: widget.realtys.realty_thumbnail == "" ||
                                    widget.realtys.realty_thumbnail == null
                                ? ImageNetwork(
                                    image: imageRealty + "def.png",

                                    width: (MediaQuery.of(context).size.width /
                                        1.25),
                                    height:
                                        (MediaQuery.of(context).size.height /
                                            2.5),
                                    // width: 110,
                                    // height: 140,
                                    onLoading: const CircularProgressIndicator(
                                      color: pcPinkLight,
                                    ),
                                    onError: const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    ),
                                  )
                                : ImageNetwork(
                                    image: imageRealty +
                                        widget.realtys.realty_thumbnail,
                                    // width: 110,
                                    // height: 140,
                                    onLoading: CircularProgressIndicator(
                                      color: pcPinkLight,
                                    ),
                                    onError: const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    ),

                                    width: (MediaQuery.of(context).size.width /
                                        1.25),
                                    height:
                                        (MediaQuery.of(context).size.height /
                                            2.5),
                                    // fit: BoxFit.fill,
                                  ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.favorite,
                            color: Colors.redAccent,
                          ),
                          Padding(padding: EdgeInsets.only(left: 3, right: 3)),
                          Text(
                            widget.realtys.realty_fav_number.toString(),
                            style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Cairo",
                                fontSize: 20),
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 10, right: 10)),
                          const Text(
                            " \$ ",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Cairo",
                                fontSize: 17),
                          ),
                          Text(
                            widget.realtys.realty_price.toString(),
                            style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Cairo",
                                fontSize: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<LoadingControl>(context);
    return Scaffold(
      // backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          //start header
          RealtyImage(),
//end header

          //start body
          Container(
              //color: Colors.amber,
              height: MediaQuery.of(context).size.height / 2.9,
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.only(top: 15, right: 15),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              widget.realtys.realty_short_title,
                              style: const TextStyle(
                                  fontFamily: "Cairo",
                                  fontSize: 25,
                                  color: Color.fromARGB(255, 180, 1, 159),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          // SingleChildScrollView(
                          //   scrollDirection: Axis.horizontal,
                          //   child: Row(
                          //     children: [
                          //       Container(
                          //         // color: Colors.amber,
                          //         width:
                          //             MediaQuery.of(context).size.width / 1.9,
                          //         child: SingleChildScrollView(
                          //           scrollDirection: Axis.horizontal,
                          //           child: Row(
                          //             children: [
                          //               const Text(
                          //                 "العنوان: ",
                          //                 style: TextStyle(
                          //                     fontFamily: "Cairo",
                          //                     fontSize: pfontt,
                          //                     color: Color.fromARGB(
                          //                         255, 0, 52, 94),
                          //                     fontWeight: FontWeight.bold),
                          //               ),
                          //               Text(
                          //                 widget.realtys.realty_publisher,
                          //                 style: const TextStyle(
                          //                     fontFamily: "Cairo",
                          //                     fontSize: pfontb,
                          //                     color: Colors.black,
                          //                     fontWeight: FontWeight.w600),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Container(
                                  // color: Colors.amber,
                                  width:
                                      MediaQuery.of(context).size.width / 1.75,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        const Text(
                                          "رقم الجوال: ",
                                          style: TextStyle(
                                            fontFamily: "Cairo",
                                            fontSize: pfontt,
                                            color:
                                                Color.fromARGB(255, 0, 52, 94),
                                            // fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        Text(
                                          widget.realtys.number_phone,
                                          style: const TextStyle(
                                              fontFamily: "Cairo",
                                              fontSize: pfontb,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const Padding(
                                    padding:
                                        EdgeInsets.only(right: 2, left: 20)),

                                //Padding(padding: EdgeInsets.only(right: 17, left: 17)),
                                const Text(
                                  "نوع العقار: ",
                                  style: TextStyle(
                                      fontFamily: "Cairo",
                                      fontSize: pfontt,
                                      color: Color.fromARGB(255, 0, 52, 94),
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.realtys.realty_type,
                                  style: const TextStyle(
                                      fontFamily: "Cairo",
                                      fontSize: pfontb,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            "تفاصيل العقار والعنوان:",
                            style: TextStyle(
                                fontFamily: "Cairo",
                                fontSize: pfontt,
                                color: Color.fromARGB(255, 0, 52, 94),
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.realtys.realty_summary,
                            style: const TextStyle(
                                fontFamily: "Cairo",
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      // ),
                    ],
                  ),
                ),
              )),
          //end body

          //start footer
          Footer(
            backgroundColor: Colors.white,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                decoration: BoxDecoration(
                    color: pcPinkLight,
                    border: Border.all(color: pcPink, width: 5),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(45),
                        topRight: Radius.circular(45))),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            // color: Colors.white,
                            // border: Border.all(color: Colors.purple, width: 3),
                            borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.all(3),
                        margin: const EdgeInsets.all(3),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width / 2,
                        child: Consumer<LoadingControl>(
                            builder: (context, load, child) {
                          return GestureDetector(
                            child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    const Text(
                                      "إضافة إلى المفضلة",
                                      style: TextStyle(
                                          color: pcPink,
                                          fontSize: 16,
                                          fontFamily: "Cairo",
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(left: 10)),
                                    Icon(
                                      ic,
                                      color: cl,
                                      size: 30,
                                    ),
                                  ],
                                )),
                            onTap: () async {
                              // setState(() {});

                              widget.realtys.fav_id == null ||
                                      widget.realtys.fav_id == ""
                                  ? updateFavP(context)
                                  : updateFavM(context);

                              widget.realtys.fav_id == null ||
                                      widget.realtys.fav_id == ""
                                  ? ic = ic_f
                                  : ic = ic_b;
                              widget.realtys.fav_id == null ||
                                      widget.realtys.fav_id == ""
                                  ? cl = cl_p
                                  : cl = cl_g;

                           isloadingFav?circularProgress(): saveFavorite(
                                  widget.realtys.fav_id,
                                  widget.realtys.realty_id,
                                  widget.realty_index!,
                                  context,
                                  myProvider);
                               setState(() {});
                            },
                          );
                        }),

                        //=========================end favorite
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )

          //end footer
        ],
      ),
    );
  }
}
