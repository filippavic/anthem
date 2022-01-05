import 'package:anthem/pages/user_page.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:anthem/utils/constants.dart';
import 'package:anthem/pages/user_page.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
      body: buildPages(),
      bottomNavigationBar: buildBottomNavigation(),
  );


  Widget buildPages() {
    switch(index) {
      case 0:
      default:
        return UserPage();
    }
  }

  Widget buildBottomNavigation() {
    return BottomNavyBar(
      iconSize: 20,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      selectedIndex: index,
      onItemSelected: (index) => setState(() => this.index = index),
      backgroundColor: Constants.kPrimaryDarkBackgroundColor,
      showElevation: true,
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          icon: FaIcon(FontAwesomeIcons.user),
          title: Text("User"),
          activeColor: Colors.green,
          inactiveColor: Colors.grey.shade700,
          textAlign: TextAlign.center
        ),
        BottomNavyBarItem(
          icon: FaIcon(FontAwesomeIcons.music),
          title: Text("Music"),
          activeColor: Colors.purple,
          inactiveColor: Colors.grey.shade700,
          textAlign: TextAlign.center
        ),
      ],
    );
  }
}