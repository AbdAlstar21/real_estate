// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:toast/toast.dart';

// import 'package:real_estate/pages/config.dart';
// import 'package:real_estate/pages/provider/loading.dart';

// import '../realtys/realtys_data.dart';
// import '../components/progres.dart';
// import '../function.dart';
// import 'realty_details.dart';

// class MyPopMenu extends StatefulWidget {
//   int? realty_index;
//   RealtyData realtys;
//   MyPopMenu({
//     Key? key,
//     this.realty_index,
//     required this.realtys,
//   }) : super(key: key);

//   @override
//   _MyPopMenuState createState() => _MyPopMenuState();
// }

// class _MyPopMenuState extends State<MyPopMenu> {
//   TextEditingController txtrep_note = TextEditingController();

// //start insert report

//   var rep_note;

//   var rep_id_list = repList!.map((e) {
//     return e.rep_id;
//   }).toList();

//   var rep_note_list = repList!.map((e) {
//     return e.rep_note;
//   }).toList();
//   void getNI() {
//     for (int i = 0; i < repList!.length; i++) {
//       if (rep_id_list[i] == widget.realtys.rep_id) {
//         // print(rep_id_list[i]);
//         rep_note = rep_note_list[i];
//       }
//     }
//   }

//   bool isloading = false;

//   saveRep(context, LoadingControl load) async {
//     if (!await checkConnection()) {
//       Toast.show("Not connected Internet", context,
//           duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
//     }
//     load.add_loading();
//     if (txtrep_note.text.isNotEmpty) {
//       isloading = true;
//       load.add_loading();
//       Map arr = {
//         "user_id": G_user_id_val,
//         "realty_id": widget.realtys.realty_id,
//         "rep_note": txtrep_note.text,
//         "realty_short_title": title,
//       };
//       Map res = await SaveDataListRepEva(
//           arr,
//           "reports/insert_rep.php",
//           () => RealtyDetails(
//               realtys: widget.realtys, realty_index: widget.realty_index),
//           context,
//           "insert");

//       isloading = res != null ? true : false;
//       if (isloading) {
//         realtyList![widget.realty_index!].rep_id = res["rep_id"];
//         widget.realtys.rep_id = res["rep_id"];

//         load.add_loading();
//       }

//       load.add_loading();
//     } else {
//       Toast.show("لا يمكن أن يكون الحقل فارغا", context,
//           duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
//     }
//   }

// //edit
//   editRep(context, LoadingControl load) async {
//     if (!await checkConnection()) {
//       Toast.show("Not connected Internet", context,
//           duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
//     }
//     load.add_loading();
//     if (txtrep_note.text.isNotEmpty) {
//       isloading = true;
//       load.add_loading();
//       Map arr = {
//         "rep_id": widget.realtys.rep_id,
//         "rep_note": txtrep_note.text,
//       };
//       Map res = await SaveDataListRepEva(
//           arr,
//           "reports/update_rep.php",
//           () => RealtyDetails(
//               realtys: widget.realtys, realty_index: widget.realty_index),
//           context,
//           "insert");

//       isloading = res != null ? true : false;
//       if (isloading) {
//         realtyList![widget.realty_index!].rep_id = res["rep_id"];
//         widget.realtys.rep_id = res["rep_id"];
//         load.add_loading();
//         Navigator.of(context).pop();
//       }

//       load.add_loading();
//     } else {
//       Toast.show("لا يمكن أن يكون الحقل فارغا", context,
//           duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
//     }
//   }

// //
//   String txtbtn = "";

//   _displayDialog(BuildContext context, LoadingControl load) async {
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return Directionality(
//             textDirection: TextDirection.rtl,
//             child: AlertDialog(
//               title: Row(
//                 children: [
//                   Icon(Icons.info, color: pcPink),
//                   Text("أكتب ملاحظتك عن العقار",
//                       style: TextStyle(
//                           color: pcPink, fontWeight: FontWeight.w500)),
//                 ],
//               ),
//               content: TextField(
//                 controller: txtrep_note,
//                 decoration: InputDecoration(hintText: "أدخل النص هنا"),
//               ),
//               actions: [
//                 // widget.realtys.rep_id != null || widget.realtys.rep_id != ""
//                 //     ? MaterialButton(
//                 //         child: Container(
//                 //             child: Text("ارسال الملاحظة",
//                 //                 style: TextStyle(
//                 //                   color: pcPink,
//                 //                   fontSize: 20,
//                 //                 ))),
//                 //         onPressed: () {
//                 //           // repList!.removeAt(widget.realty_index!);
//                 //           deleteData("rep_id", widget.realtys.rep_id,
//                 //               "reports/delete_rep.php");
//                 //           realtyList![widget.realty_index!].rep_id = "";
//                 //           widget.realtys.rep_id = "";

//                 //           // updateEva(context);
//                 //           Navigator.push(
//                 //               context,
//                 //               MaterialPageRoute(
//                 //                   builder: (context) => RealtyDetails(
//                 //                       realtys: widget.realtys,
//                 //                       realty_index: widget.realty_index)));
//                 //           // setState(() {});
//                 //         },
//                 //       )
//                 //     :
//                 MaterialButton(
//                   child: Container(
//                       child: Text("ارسال الملاحظة",
//                           style: TextStyle(
//                             color: pcPink,
//                             fontSize: 20,
//                           ))),
//                   onPressed: () {
//                     saveRep(context, load);
//                     print("ttt : $title");
//                     // if (widget.realtys.rep_id != null ||
//                     //     widget.realtys.rep_id != "") {
//                     //   editRep(context, load);
//                     //   if (txtrep_note.text.isNotEmpty) {
//                     //     Navigator.of(context).pop();
//                     //   }
//                     // } else {
//                     //   saveRep(context, load);
//                     //   txtbtn = "تعديل الملاحظة";
//                     //   if (txtrep_note.text.isNotEmpty) {
//                     //     Navigator.of(context).pop();
//                     //   }
//                     // }
//                   },
//                 ),
//               ],
//             ),
//           );
//         });
//   }

//   String? title;
//   @override
//   void initState() {
//     getNI();
//     txtrep_note.text = rep_note;
//     // ignore: todo
//     // TODO: implement initState
//     super.initState();

//     txtrep_note.text = rep_note;
//     title = widget.realtys.realty_short_title;

//     // if (widget.realtys.rep_id != null || widget.realtys.rep_id != "") {
//     //   txtrep_note.text = rep_note;
//     //   txtbtn = "تعديل الملاحظة";
//     // } else {
//     //   txtbtn = "ارسل الملاحظة";
//     // }
//     // if (widget.realtys.eva_id != null && widget.realtys.eva_id != "") {
//     //   txtbtneva = "تعديل التقييم";
//     //   getNIEva();
//     //   txteva_note.text = eva_note;
//     //   rating = double.parse(eva_avg);
//     // } else {
//     //   txtbtneva = "تقييم";

//     // }
//   }

//   @override
//   void dispose() {
//     // ignore: todo
//     // TODO: implement dispose
//     super.dispose();

//     // txtrep_note.dispose();
//   }

// //end insert report
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<LoadingControl>(builder: (context, load, child) {
//       return PopupMenuButton(
//           onSelected: ((value) {
//             if (value == 4) {
//               _displayDialog(context, load);
//               // Navigator.push(
//               //     context,
//               //     MaterialPageRoute(
//               //         builder: (context) => AddReport(
//               //             realtys: widget.realtys, realty_index: widget.realty_index)));
//             }
//             if (value == 2) {
//               // _displayDialogEva(context, load);
//             }
//           }),
//           color: Colors.white,
//           iconSize: 30,
//           itemBuilder: (context) => [
//                 // PopupMenuItem(
//                 //     value: 1,
//                 //     child: Row(
//                 //       mainAxisAlignment: MainAxisAlignment.end,
//                 //       children: const <Widget>[
//                 //         Text('التقييمات'),
//                 //         Padding(
//                 //           padding: EdgeInsets.fromLTRB(8, 2, 2, 2),
//                 //           child: Icon(
//                 //             Icons.star,
//                 //             color: Colors.green,
//                 //           ),
//                 //         ),
//                 //       ],
//                 //     )),
//                 // PopupMenuItem(
//                 //     // onTap: () {},
//                 //     value: 2,
//                 //     child: Row(
//                 //       mainAxisAlignment: MainAxisAlignment.end,
//                 //       children: const <Widget>[
//                 //         Text('تقييم'),
//                 //         Padding(
//                 //           padding: EdgeInsets.fromLTRB(0, 2, 2, 2),
//                 //           child: Icon(
//                 //             Icons.star,
//                 //             color: Colors.amber,
//                 //           ),
//                 //         ),
//                 //       ],
//                 //     )),

//                 PopupMenuItem(
//                     value: 4,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: const <Widget>[
//                         Text('ارسل ملاحظة'),
//                         Padding(
//                           padding: EdgeInsets.fromLTRB(16, 2, 2, 2),
//                           child: Icon(
//                             Icons.report,
//                             color: Colors.redAccent,
//                           ),
//                         ),
//                       ],
//                     )),
//               ]);
//     });
//   }
// }
