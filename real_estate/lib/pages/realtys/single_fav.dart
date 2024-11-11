import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_network/image_network.dart';
import 'package:provider/provider.dart';

import 'package:real_estate/pages/realty_details/realty_details.dart';
import 'package:real_estate/pages/provider/loading.dart';

import '../components/progres.dart';
import '../config.dart';
import '../function.dart';
import 'realyts_data.dart';
// import 'edit.dart';

class SingleFavorite extends StatefulWidget {
  int realty_index;
  RealtyData realtys;
  SingleFavorite({Key? key, required this.realty_index, required this.realtys})
      : super(key: key);

  @override
  State<SingleFavorite> createState() => _SingleFavoriteState();
}

class _SingleFavoriteState extends State<SingleFavorite> {
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
        realtyListFav!.removeAt(widget.realty_index);
        deleteData("fav_id", widget.realtys.fav_id, "favorite/delete_fav.php");
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
    var providerFav = Provider.of<LoadingControl>(context);

    return MaterialButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RealtyDetails(
                      realtys: widget.realtys,
                      realty_index: widget.realty_index,
                    )));
      },
      child: Card(
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4.0),
                  margin: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: pcPink,
                  ),
                  child: widget.realtys.realty_thumbnail == "" ||
                          widget.realtys.realty_thumbnail == null
                      ? ImageNetwork(
                          image: imageRealty + "def.png",
                          width: 110,
                          height: 140,
                          onLoading: const CircularProgressIndicator(
                            color: pcPinkLight,
                          ),
                          onError: const Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                        )
                      : ImageNetwork(
                          image: imageRealty + widget.realtys.realty_thumbnail,
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
                Expanded(
                  child: ListTile(
                    title: Text(
                      widget.realtys.realty_short_title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Column(
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
                              Text(widget.realtys.realty_fav_number.toString()),
                              Padding(padding: EdgeInsets.only(right: 10)),
                              Row(
                                children: [
                                  // const Icon(
                                  //   Icons.download,
                                  //   color: Colors.green,
                                  // ),
                                  const Text(
                                    "\$",
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Cairo",
                                        fontSize: 17),
                                  ),
                                  Text(widget.realtys.realty_price),
                                ],
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
                        ]),
                    trailing: Column(
                      children: <Widget>[
                        Consumer<LoadingControl>(
                            builder: (context, load, child) {
                          return GestureDetector(
                            onTap: () {
                              showAlertDialog(context, providerFav);
                            },
                            child: widget.realtys.fav_id == null ||
                                    widget.realtys.fav_id == ""
                                ? Icon(
                                    Icons.favorite_border,
                                    size: 34,
                                  )
                                : Icon(
                                    Icons.favorite,
                                    color: Colors.purple,
                                    size: 34,
                                  ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
