import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_network/image_network.dart';
import 'package:provider/provider.dart';

import 'package:real_estate/pages/realty_details/realty_details.dart';
import 'package:real_estate/pages/provider/loading.dart';

import '../config.dart';
import '../function.dart';
import 'realyts_data.dart';

class SingleRealtyAll extends StatelessWidget {
  int realty_index;
  RealtyData realtys;
  SingleRealtyAll({Key? key, required this.realty_index, required this.realtys})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var providerRealty = Provider.of<LoadingControl>(context);

    return MaterialButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => RealtyDetails(realtys: realtys, realty_index: realty_index)));
      },
      child: Card(
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2.0),
                  margin: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: pcPink,
                  ),
                  child:
                      realtys.realty_thumbnail == "" || realtys.realty_thumbnail == null
                          ? ImageNetwork(
                              image: imageRealty + "def.png",
                              width: 170,
                              height: 180,
                              onLoading: const CircularProgressIndicator(
                                color: pcPinkLight,
                              ),
                              onError: const Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                            )
                          : ImageNetwork(
                              image: imageRealty + realtys.realty_thumbnail,
                              width: 170,
                              height: 180,
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
                      realtys.realty_short_title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                       
                           Text(
                            realtys.realty_type,
                            style: const TextStyle(fontSize: 18),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                              Text(realtys.realty_fav_number.toString()),
                              Padding(padding: EdgeInsets.only(right: 10)),
                              Row(
                                children: [
                                  // const Icon(
                                  //   Icons.download,
                                  //   color: Colors.green,
                                  // ),
                                  const Text(
                                                                                      "\$",
                                                                                      style:TextStyle(color: Colors.green,fontWeight: FontWeight.bold, fontFamily: "Cairo", fontSize: 17),
                                                                                    ),
                                  Text(realtys.realty_price),
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
                              Text(realtys.realty_date),
                            ],
                          )
                        ]),
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
