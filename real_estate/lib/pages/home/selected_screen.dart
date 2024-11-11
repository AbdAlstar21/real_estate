// ignore_for_file: non_constant_identifier_names, use_key_in_widget_constructors, duplicate_ignore

import 'package:real_estate/pages/realty_details/realty_details.dart';
import 'package:real_estate/pages/drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:real_estate/pages/config.dart';

import '../realtys/favorite.dart';
import '../categories/categories.dart';
import 'home.dart';

class SelectedScreen extends StatefulWidget {
  const SelectedScreen({Key? key}) : super(key: key);

  @override
  _SelectedScreenState createState() => _SelectedScreenState();
}

class _SelectedScreenState extends State<SelectedScreen> {
  final GlobalKey<ScaffoldState> _keyDrawer = GlobalKey<ScaffoldState>();
  // ignore: non_constant_identifier_names
  int _selectedScreenIndex = 0;
  final List _screens = [
    {"screen": const Home()},
    {"screen": const MyFavorite()}
  ];

  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedScreenIndex]["screen"],
      bottomNavigationBar: Directionality(
        textDirection: TextDirection.rtl,
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'الصفحة الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
              ),
              label: 'المفضلة',
            ),
          ],
          onTap: _selectScreen,
          currentIndex: _selectedScreenIndex,
          selectedItemColor: pcPink,
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }
}
