import 'package:anthem/pages/user_page.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      body: buildPages(),
      bottomNavigationBar: buildBottomNavigation(),
  );


  Widget buildPages() {
    switch(_index) {
      case 1:
        return LibraryView();
      case 2:
        return MapView();
      case 0:
      default:
        return HomeView();
    }
  }

   Widget buildBottomNavigation() {
    return BottomNavigationBar(
        currentIndex: _index,
        onTap: (index) {
          setState(() {
            this._index = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: Constants.textNavBarHome,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: Constants.textNavBarLibrary,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pin_drop_outlined),
            label: Constants.textNavBarMap,
          )
        ]
    );
  }

  // Widget buildBottomNavigation() {
  //   return BottomNavyBar(
  //     iconSize: 20,
  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //     selectedIndex: index,
  //     onItemSelected: (index) => setState(() => this.index = index),
  //     backgroundColor: Constants.kPrimaryDarkBackgroundColor,
  //     showElevation: true,
  //     items: <BottomNavyBarItem>[
  //       BottomNavyBarItem(
  //         icon: FaIcon(FontAwesomeIcons.user),
  //         title: Text("User"),
  //         activeColor: Colors.green,
  //         inactiveColor: Colors.grey.shade700,
  //         textAlign: TextAlign.center
  //       ),
  //       BottomNavyBarItem(
  //         icon: FaIcon(FontAwesomeIcons.music),
  //         title: Text("Music"),
  //         activeColor: Colors.purple,
  //         inactiveColor: Colors.grey.shade700,
  //         textAlign: TextAlign.center
  //       ),
  //     ],
  //   );
  // }
}