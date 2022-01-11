import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:anthem/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:anthem/animation/fade_animation.dart';
import 'package:anthem/pages/home_page.dart';
import 'package:anthem/globals/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:anthem/api/spotify_api.dart';
import 'package:anthem/globals/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class InitialSongsPage extends StatefulWidget {
  const InitialSongsPage({ Key? key }) : super(key: key);

  @override
  _InitialSongsPageState createState() => _InitialSongsPageState();

}

class _InitialSongsPageState extends State<InitialSongsPage> {
  final user = FirebaseAuth.instance.currentUser!;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final List<String> _selectedSongs = [];

  // Save songs to both "user" collection in doc favoriteSongs and in collection "songs" for further expanding songs database
  Future<void> saveSongs() async {
    // ---- Writing songs to Firestore BEGIN ----
    for (var song in globals.recommendedSongsInfo.values) {
      print("song: " + song.toString());
      if(_selectedSongs.contains(song["id"])){
        var batch = FirebaseFirestore.instance.batch();

        var newGroup = FirebaseFirestore.instance.collection('users').doc(user.email);
        batch.update(newGroup, {'noOfFavoriteSongs': FieldValue.increment(1)});

        var newMember = newGroup.collection('favoriteSongs').doc(song["id"]);
        batch.set(newMember, song);

        batch.commit().catchError((err) {
          print(err);
        });

        // FirebaseFirestore.instance
        //     .collection('users')
        //     .doc(user.email)
        //     .collection('favoriteSongs')
        //     .doc(song["id"])
        //     .set(song);
      }
      FirebaseFirestore.instance
          .collection('songs')
          .doc(song["id"])
          .set(song);
    }
    // ---- Writing songs to Firestore END ----
  }

  Future<void> _setFinishedSetup() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setBool('finishedSetup', true);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light
    ));

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: _selectedSongs.isNotEmpty ? FloatingActionButton(
          onPressed: () async {
            // await setFavoriteArtists();
            await saveSongs();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${_selectedSongs.length}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(width: 2),
              Icon(Icons.arrow_forward_ios, size: 18, color: Colors.white),
            ],
          ),
          backgroundColor: Constants.kPrimaryColor,
        ) : null,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(
                child: FadeAnimation(1, Padding(
                  padding: EdgeInsets.only(top: 120.0, right: 20.0, left: 20.0),
                  child: Text(
                    'Take a look at some songs. Select the ones you find interesting.',
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ))
            ];
          },
          body: Padding(
            padding: EdgeInsets.all(20.0),
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: globals.recommendedSongs.length,
              itemBuilder: (BuildContext context, int index) {
                return FadeAnimation((1.2 + index) / 4, song(globals.recommendedSongs[index], index));
              }
            ),
          ),
        )
      )
    );

  }

  // Promijeniti ovisno o strukturi
  song(String songID, int index) { 
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedSongs.contains(songID))
            _selectedSongs.remove(songID);
          else
            _selectedSongs.add(songID);
        });
      },
      child: Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        margin: EdgeInsets.only(bottom: 20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            color: _selectedSongs.contains(songID) ? Constants.kPrimaryColor : Constants.kPrimaryColor.withOpacity(0),
            width: 2.0,
          ),
          color: _selectedSongs.contains(songID) ? Colors.grey.shade900 : Colors.grey.shade900,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(globals.recommendedSongsInfo[songID]["name"], style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                        SizedBox(height: 3,),
                        Text(globals.recommendedSongsInfo[songID]["artists"].join(", "), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade300))
                      ],
                    ),
                  ],
                ),
                Spacer(),
                _selectedSongs.contains(songID) ?
                  Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Constants.kPrimaryColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Icon(Icons.check, color: Colors.white, size: 20,)
                  ) : 
                  SizedBox()
              ],
            ),
          ],
        )
      ),
    );
  }
}