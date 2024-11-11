//changed//
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:dashboard/pages/realtys/realtys_data.dart';
import 'package:dashboard/pages/components/progres.dart';
import 'package:dashboard/pages/config.dart';
import 'package:dashboard/pages/function.dart';
import 'package:dashboard/pages/provider/loading.dart';

import '../function.dart';
import 'add_realty.dart';
import 'single_realty.dart';

List<CatNI>? catNIList;

class CatNI {
  String cat_id;
  String cat_name;
  CatNI({
    required this.cat_id,
    required this.cat_name,
  });
}

class Realtys extends StatefulWidget {
  @override
  _RealtysState createState() => _RealtysState();
}

class _RealtysState extends State<Realtys> {
  List<RealtysData>? realtyList;

  //////
  ///
  ///
  ///
  showAlertDialog(BuildContext context, LoadingControl load, final item) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("إلغاء الأمر", style: TextStyle(color: pcPink)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("موافق", style: TextStyle(color: pcPink)),
      onPressed: () {
        realtyList!.remove(item);
        deleteData("realty_id", item, "realtys/delete_realty.php");
        load.add_loading();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Directionality(
          textDirection: TextDirection.rtl,
          child: Text("تأكيد الحذف", style: TextStyle(color: pcPink))),
      content: Text("هل متأكد أنك تريد حذف هذا العنصر"),
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

///////////
////////
  ScrollController? myScroll;
  GlobalKey<RefreshIndicatorState>? refreshKey;
  int i = 0;
  bool loadingList = false;

  void getDataCatNI(int count, String strSearch) async {
    loadingList = true;
    setState(() {});
    List arr = await getData(count, "categories/readcat.php", strSearch, "");
    for (int i = 0; i < arr.length; i++) {
      catNIList!.add(CatNI(
        cat_id: arr[i]["cat_id"],
        cat_name: arr[i]["cat_name"],
      ));
    }
    loadingList = false;
    setState(() {});
  }

  void getDataRealty(int count, String strSearch) async {
    loadingList = true;
    setState(() {});
    List arr = await getData(count, "realtys/readrealty.php", strSearch, "");
    for (int i = 0; i < arr.length; i++) {
      realtyList!.add(RealtysData(
        realty_id: arr[i]["realty_id"], //
        cat_id: arr[i]["cat_id"],
        realty_short_title: arr[i]["realty_short_title"], //
        number_phone: arr[i]["number_phone"],
        realty_type: arr[i]["realty_type"], //
        realty_block: arr[i]["realty_block"] == "1" ? true : false,
        realty_date: arr[i]["realty_date"],
        realty_summary: arr[i]["realty_summary"],
        realty_thumbnail: arr[i]["realty_thumbnail"],
        realty_fav_number: int.parse(arr[i]["realty_fav_number"]),
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
    realtyList!.clear();
    catNIList!.clear();
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    realtyList = <RealtysData>[];
    catNIList = <CatNI>[];
    myScroll = ScrollController();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    getDataRealty(0, "");
    getDataCatNI(0, "");

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

  Icon _searchIcon = const Icon(Icons.search);
  Widget _appBarTitle = const Text("إدارة العقارات");

  void _searchPressed(LoadingControl myProv) {
    if (_searchIcon.icon == Icons.search) {
      _searchIcon = const Icon(Icons.close);
      _appBarTitle = TextField(
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search), hintText: "ابحث ..."),
        onChanged: (text) {
          // ignore: avoid_print
          print(text);

          realtyList!.clear();
                    catNIList!.clear();

          i = 0;
          getDataRealty(0, text);
                    getDataCatNI(0, text);

          myProv.add_loading();
        },
      );
    } else {
      _searchIcon = const Icon(Icons.search);
      _appBarTitle = const Text("إدارة العقارات");
    }
    myProv.add_loading();
  }

  bool isFabVisibleAdd = true;
  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<LoadingControl>(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Visibility(
        visible: isFabVisibleAdd,
        child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddRealtys()));
            },
            backgroundColor: pcPink,
            child: const Icon(
              Icons.add,
              color: Color.fromARGB(255, 231, 219, 182),
              size: 30,
            )),
      ),
      appBar: AppBar(
        // backgroundColor: pcPink,
        title: _appBarTitle,
        centerTitle: true,
        actions: [
          Container(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () {
                _searchPressed(myProvider);
              },
              child: _searchIcon,
            ),
          )
        ],
      ),
      backgroundColor: pcWhite,
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.forward) {
            setState(() {
              isFabVisibleAdd = true;
            });
          } else if (notification.direction == ScrollDirection.reverse) {
            setState(() {
              isFabVisibleAdd = false;
            });
          }
          return true;
        },
        child: RefreshIndicator(
          onRefresh: () async {
            i = 0;
            realtyList!.clear();
            catNIList!.clear();
            getDataRealty(0, "");
            getDataCatNI(0, "");
          },
          key: refreshKey,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 0),
                  child: ListView.builder(
                    controller: myScroll,
                    itemCount: realtyList!.length,
                    itemBuilder: (context, index) {
                      final item = realtyList![index];
                      return Dismissible(
                        key: Key(item.realty_id),
                        direction: DismissDirection.startToEnd,
                        child: SingleRealty(
                          realty_index: index,
                          realtys: realtyList![index],
                        ),
                        onDismissed: (direction) {
                          showAlertDialog(context, myProvider, item.realty_id);
                          realtyList!.remove(item);
                          // deleteData("realty_id", item.realty_id,
                          //     "realtys/delete_realty.php");
                          // myProvider.add_loading();
                        },
                      );
                    },
                  ),
                ),
                Positioned(
                    child: loadingList ? circularProgress() : const Text(""),
                    bottom: 0,
                    left: MediaQuery.of(context).size.width / 2.2)
              ],
            ),
          ),
        ),
      ),
      
    );
  }
}
