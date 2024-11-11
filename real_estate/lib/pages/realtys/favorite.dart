//changed//
import 'package:real_estate/pages/realty_details/realty_details.dart';
import 'package:real_estate/pages/realtys/single_fav.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/pages/realtys/realyts_data.dart';
import 'package:real_estate/pages/components/progres.dart';
import 'package:real_estate/pages/config.dart';
import 'package:real_estate/pages/function.dart';
import 'package:real_estate/pages/provider/loading.dart';
import '../function.dart';
import '../home/home.dart';
import '../home/selected_screen.dart';

List<CatNI>? catNIList;
List<RealtyData>? realtyList;
class CatNI {
  String cat_id;
  String cat_name;
  CatNI({
    required this.cat_id,
    required this.cat_name,
  });
}

class MyFavorite extends StatefulWidget {
  final String? cat_id;
  final String? cat_name;

  const MyFavorite({
    Key? key,
    this.cat_id,
    this.cat_name,
  }) : super(key: key);
  @override
  _MyFavoriteState createState() => _MyFavoriteState();
}

class _MyFavoriteState extends State<MyFavorite> {
  ScrollController? myScroll;
  GlobalKey<RefreshIndicatorState>? refreshKey;
  int i = 0;
  bool loadingList = false;

  void getrepname(int count, String strSearch) async {
    setState(() {});
    List arr = await getData(count, "reports/readrep.php", strSearch, "");
    for (int i = 0; i < arr.length; i++) {
      repList!.add(Rep(rep_id: arr[i]["rep_id"], rep_note: arr[i]["rep_note"]));
    }
    setState(() {});
  }



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

  void getDataFav(int count, String strSearch) async {
    loadingList = true;
    setState(() {});
    List arr = await getData(count, "favorite/readfav.php", strSearch,
        "cat_id=${widget.cat_id}&user_id=${G_user_id_val}&");
    for (int i = 0; i < arr.length; i++) {
      realtyListFav!.add(RealtyData(
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
    realtyListFav!.clear();
    realtyList!.clear();
    catNIList!.clear();
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    realtyListFav = <RealtyData>[];
    // realtyList = <RealtyData>[];
    catNIList = <CatNI>[];
    myScroll = ScrollController();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    repList = <Rep>[];
               getDataCatNI(0, "");
    getrepname(0, "");
    getDataFav(0, "");
    // getDataCatNI(0, "");
    
    myScroll?.addListener(() {
      if (myScroll!.position.pixels == myScroll?.position.maxScrollExtent) {
        i += 10;
        getDataFav(i, "");
        getDataCatNI(i, "");
        // ignore: avoid_print
        print("scroll");
      }
    });
  }

  Icon _searchIcon = const Icon(Icons.search);
  Widget _appBarTitle = const Text("المفضلة");

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

          realtyListFav!.clear();

          catNIList!.clear();
          i = 0;

           getDataCatNI(0, text);
               getrepname(0,text);

          getDataFav(0, text);
                   myProv.add_loading();
        },
      );
    } else {
      _searchIcon = const Icon(Icons.search);
    }
    myProv.add_loading();
  }

  bool isFabVisibleAdd = true;
  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<LoadingControl>(context);
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: pcBlue,
        title: _appBarTitle,
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(
              Icons.home,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SelectedScreen()));
            }),
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
            realtyListFav!.clear();
            catNIList!.clear();
            getDataFav(0, "");
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
                    itemCount: realtyListFav!.length,
                    itemBuilder: (context, index) {
                      final item = realtyListFav![index];
                      return Dismissible(
                        key: Key(item.realty_id),
                        direction: DismissDirection.startToEnd,
                        child: SingleFavorite(
                          realty_index: index,
                          realtys: realtyListFav![index],
                        ),
                        onDismissed: (direction) {
                          realtyListFav!.remove(item);
                          deleteData(
                              "realty_id", item.realty_id, "realtys/delete_realty.php");
                          myProvider.add_loading();
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
