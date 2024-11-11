// ignore_for_file: unnecessary_import, avoid_print

import 'dart:ui';
import 'package:dashboard/pages/components/progres.dart';
import 'package:dashboard/pages/provider/loading.dart';
import 'package:dashboard/pages/users/users_data.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/pages/config.dart';
import 'package:dashboard/pages/function.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../function.dart';
import 'single_user.dart';

class Users extends StatefulWidget {
  const Users({Key? key}) : super(key: key);

  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  ///////
  ///
  


  //////
  ScrollController? myScroll;
  GlobalKey<RefreshIndicatorState>? refreshKey;
  int i = 0;
  bool loadingList = false;
  void getDataUser(int count, String strSearch) async {
    loadingList = true;
    setState(() {});
    List arr = await getData(count, "users/readuser.php", strSearch, "");
    for (int i = 0; i < arr.length; i++) {
      if (arr[i]["user_name"] == "admin") {
        continue;
      }
      userList!.add(UsersData(
        user_id: arr[i]["user_id"],
        user_name: arr[i]["user_name"],
        user_pwd: arr[i]["user_password"],
        user_mobile: arr[i]["user_email"],
        user_active: arr[i]["user_active"] == "1" ? true : false,
        user_lastdate: arr[i]["user_lastdate"],
        user_note: arr[i]["user_note"],
        user_thumbnail: arr[i]["user_thumbnail"],
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
    userList!.clear();
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    // userList=new List<UserData>();
    userList = <UsersData>[];
    myScroll = ScrollController();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    getDataUser(0, "");

    myScroll?.addListener(() {
      if (myScroll!.position.pixels == myScroll?.position.maxScrollExtent) {
        i += 10;
        getDataUser(i, "");
        print("scroll");
      }
    });
  }

  Icon _searchIcon = const Icon(Icons.search);
  Widget _appBarTitle = const Text("إدارة المستخدمين");

  void _searchPressed(LoadingControl myProv) {
    if (_searchIcon.icon == Icons.search) {
      _searchIcon = const Icon(Icons.close);
      _appBarTitle = TextField(
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search), hintText: "ابحث ..."),
        onChanged: (text) {
          print(text);

          userList!.clear();
          i = 0;
          getDataUser(0, text);
          myProv.add_loading();
        },
      );
    } else {
      _searchIcon = const Icon(Icons.search);
      _appBarTitle = const Text("إدارة المستخدمين");
    }
    myProv.add_loading();
  }

  bool isFabVisibleAdd = true;
  @override
  Widget build(BuildContext context) {
    var myProvider = Provider.of<LoadingControl>(context);
    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      // floatingActionButton: Visibility(
      //   visible: isFabVisibleAdd,
      //   child: FloatingActionButton(
      //       onPressed: () {
      //         Navigator.push(
      //             context, MaterialPageRoute(builder: (context) => AddUsers()));
      //       },
      //       backgroundColor: Colors.blue,
      //       child: const Icon(
      //         Icons.add,
      //       )),
      // ),
      appBar: AppBar(
        // backgroundColor: pcBlue,
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
            userList!.clear();
            getDataUser(0, "");
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
                    itemCount: userList!.length,
                    itemBuilder: (context, index) {
                      final item = userList![index];
                      return Dismissible(
                        key: Key(item.user_id),
                        direction: DismissDirection.startToEnd,
                        child: SingleUser(
                          user_index: index,
                          users: userList![index],
                        ),
                        onDismissed: (direction) {
                                                    // showAlertDialog(context, myProvider, item.user_id);

                           userList!.remove(item);
                          // deleteData(
                          //     "user_id", item.user_id, "users/delete_user.php");
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
      // bottomNavigationBar: Visibility(
      //   visible: isFabVisibleAdd,
      //   child: SizedBox(
      //     height: 50.0,
      //     child: Column(
      //       children: <Widget>[
      //         Container(
      //           alignment: Alignment.center,
      //           child: GestureDetector(
      //             onTap: () {
      //               Navigator.push(context,
      //                   MaterialPageRoute(builder: (context) => AddUsers()));
      //             },
      //             child: const Text(
      //               "اضافة مستخدم جديد",
      //               style: TextStyle(color: Colors.white, fontSize: 20),
      //             ),
      //           ),
      //           height: 40.0,
      //           decoration: BoxDecoration(
      //               color: Colors.blue,
      //               borderRadius: BorderRadius.circular(40)),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}







//       users.user_thumbnail == ""
      // ? ImageNetwork(
      //     image: imageUsers + "user.png",
      //                 height: 400,
      //                 width: 55,
      //                 onLoading: const CircularProgressIndicator(
      //                   color: Colors.indigoAccent,
      //                 ),
      //                 onError: const Icon(
      //                   Icons.error,
      //                   color: Colors.red,
      //                 ),
      //               )
      //             : ImageNetwork(
      //                 image: imageUsers + users.user_thumbnail,
      //                 height: 400,
      //                 width: 55,
      //                 onLoading: CircularProgressIndicator(
      //                   color: Colors.indigoAccent,
      //                 ),
      //                 onError: const Icon(
      //                   Icons.error,
      //                   color: Colors.red,
      //                 ),
      //               ),