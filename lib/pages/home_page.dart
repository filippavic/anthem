import 'package:anthem/pages/user_page.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'package:anthem/utils/constants.dart';
import 'package:anthem/pages/user_page.dart';
import 'package:anthem/views/home_view.dart';
import 'package:anthem/views/library_view.dart';
import 'package:anthem/views/map_view.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
      extendBody: true,
      body: buildPages(),
      bottomNavigationBar: buildBottomNavigation(),
  );


  Widget buildPages() {
    switch(_index) {
      case 1:
        return LibraryView();
      case 2:
      return LibraryView();
      case 3:
        return MapView();
      case 0:
      default:
        return HomeView();
    }
  }

   Widget buildBottomNavigation() {
     return Container(
       decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, Colors.black87],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          tileMode: TileMode.clamp,
          ),
        ),
        child: BottomNavigationBar(
          // elevation: 0,
          backgroundColor: Colors.transparent,
            currentIndex: _index,
            onTap: (index) {
              setState(() {
                this._index = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Padding(padding: EdgeInsets.only(bottom: 5), child: Icon(FeatherIcons.home, size: 20,)),
                label: Constants.textNavBarHome,
              ),
              BottomNavigationBarItem(
                icon: Padding(padding: EdgeInsets.only(bottom: 5), child: Icon(FeatherIcons.music, size: 20,)),
                label: Constants.textNavBarLibrary,
              ),
              BottomNavigationBarItem(
                icon: Padding(padding: EdgeInsets.only(bottom: 5), child: Icon(FeatherIcons.barChart2, size: 20,)),
                label: Constants.textNavBarCharts,
              ),
              BottomNavigationBarItem(
                icon: Padding(padding: EdgeInsets.only(bottom: 5), child: Icon(FeatherIcons.mapPin, size: 20,)),
                label: Constants.textNavBarMap,
              )
            ]
        )
     );
  }
}