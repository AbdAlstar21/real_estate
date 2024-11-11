// ignore_for_file: unused_import, non_constant_identifier_names, must_be_immutable
import 'dart:async';
import 'dart:convert';
import 'package:dashboard/pages/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_network/image_network.dart';
import 'package:provider/provider.dart';
import 'package:dashboard/pages/provider/loading.dart';
import '../function.dart';
import 'users_data.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

class SingleUser extends StatelessWidget {
  int user_index;
  UsersData users;
  SingleUser({Key? key, required this.user_index, required this.users})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var providerUser = Provider.of<LoadingControl>(context);
    return Card(
      child: ListTile(
          leading: users.user_thumbnail == ""
              ? ProfilePicture(
                  name: users.user_name,
                  radius: 31,
                  fontsize: 21,
                  random: true,
                )
              : ProfilePicture(
                  name: users.user_name,
                  // role: 'ADMINISTRATOR',
                  radius: 31,
                  fontsize: 21,
                  tooltip: true,
                  img: imageUsers + users.user_thumbnail,
                ),
          title: Text(
            users.user_name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(users.user_mobile), Text(users.user_lastdate)]),
          trailing: PopupMenuButton(
              color: Colors.white,
              iconSize: 30,
              itemBuilder: (context) => [
                    PopupMenuItem(
                        onTap: () {
                          userList!.removeAt(user_index);
                          deleteData("user_id", users.user_id,
                              "users/delete_user.php");
                          providerUser.add_loading();
                        },
                        value: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const <Widget>[
                            Text('حظر'),
                            Padding(
                              padding: EdgeInsets.fromLTRB(8, 2, 2, 2),
                              child: Icon(
                                Icons.cancel_rounded,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        )),
                  ])),
    );
  }
}
