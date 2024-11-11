import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_network/image_network.dart';
import 'package:provider/provider.dart';

import 'package:dashboard/pages/provider/loading.dart';
import 'package:path_provider/path_provider.dart';

import '../config.dart';
import '../function.dart';
import 'realtys_data.dart';
import 'edit.dart';

class SingleRealty extends StatefulWidget {
  int realty_index;
  RealtysData realtys;
  SingleRealty({Key? key, required this.realty_index, required this.realtys})
      : super(key: key);

  @override
  State<SingleRealty> createState() => _SingleRealtyState();
}

class _SingleRealtyState extends State<SingleRealty> {
  showAlertDialog(BuildContext context, LoadingControl load) {
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
        realtyList!.removeAt(widget.realty_index);
        deleteData(
            "realty_id", widget.realtys.realty_id, "realtys/delete_realty.php");
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

  @override
  Widget build(BuildContext context) {
    var providerRealty = Provider.of<LoadingControl>(context);

    return Card(
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4.0),
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: pcPinkLight,
                ),
                child: widget.realtys.realty_thumbnail == "" ||
                        widget.realtys.realty_thumbnail == null
                    ? ImageNetwork(
                        image: imageRealty + "def.png",
                        width: 190,
                        height: 190,
                        onLoading: const CircularProgressIndicator(
                          color: pcPink,
                        ),
                        onError: const Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                      )
                    : ImageNetwork(
                        image: imageRealty + widget.realtys.realty_thumbnail,
                        width: 190,
                        height: 190,
                        onLoading: CircularProgressIndicator(
                          color: pcPink,
                        ),
                        onError: const Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                      ),
              ),
              Expanded(
                child: ListTile(
                  title: Text(
                    widget.realtys.realty_short_title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.realtys.realty_type,
                              style: const TextStyle(fontSize: 18),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                                Padding(padding: EdgeInsets.only(left: 5)),
                                Text(
                                  widget.realtys.realty_fav_number.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Cairo",
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  "\$",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Cairo",
                                      fontSize: 16),
                                ),
                                Padding(padding: EdgeInsets.only(left: 5)),
                                Text(
                                  widget.realtys.realty_price.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Cairo",
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.date_range,
                                  color: pcPink,
                                ),
                                Text(widget.realtys.realty_date),
                              ],
                            )
                          ])),
                  trailing: Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditRealtys(
                                        realty_index: widget.realty_index,
                                        realtys: widget.realtys,
                                      )));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 15,
                          ),
                          decoration: BoxDecoration(
                              color: pcPink,
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showAlertDialog(context, providerRealty);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 15,
                          ),
                          decoration: BoxDecoration(
                              color: pcPink,
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
