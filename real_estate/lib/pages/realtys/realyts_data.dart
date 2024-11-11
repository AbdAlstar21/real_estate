// ignore_for_file: unused_import, non_constant_identifier_names, must_be_immutable
//changed//
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_network/image_network.dart';
import 'package:provider/provider.dart';

import 'package:real_estate/pages/provider/loading.dart';

import '../config.dart';
import '../function.dart';
//بيانات العقار ضمن كلاس 
List<RealtyData>? realtyListall;
List<RealtyData>? realtyListFav;
String imageRealty = images_path + "realtys/";

class RealtyData {
  String? cat_id;
  String fav_id;
  String rep_id;
  String realty_id;
  String realty_short_title;
  String number_phone;
  String realty_type;
  bool realty_block;
  String realty_date;
  String realty_summary;
  String realty_thumbnail;
   String? realty_image;
  String? realty_fav_number;
  String realty_price;

  

  RealtyData({
     this.cat_id,
    required this.fav_id,
    required this.rep_id,
    required this.realty_id,
    required this.realty_short_title,
    required this.number_phone,
    required this.realty_type,
    required this.realty_block,
    required this.realty_date,
    required this.realty_summary,
    required this.realty_thumbnail,
    this.realty_image,
    this.realty_fav_number,
   required this.realty_price,
  });
}

class CatNI {
  String cat_id;
  String cat_name;
  CatNI({
    required this.cat_id,
    required this.cat_name,
  });
}