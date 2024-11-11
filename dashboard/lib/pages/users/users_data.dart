// ignore_for_file: unused_import, non_constant_identifier_names, must_be_immutable


import '../config.dart';

List<UsersData>? userList;
String imageUsers = images_path + "users/";

class UsersData {
  String user_id;
  String user_name;
  String user_pwd;
  String user_mobile;
  bool user_active;
  String user_lastdate;
  String user_note;
  String user_thumbnail;
  UsersData({
    required this.user_id,
    required this.user_name,
    required this.user_pwd,
    required this.user_mobile,
    required this.user_active,
    required this.user_lastdate,
    required this.user_note,
    required this.user_thumbnail,

  });
}

