import 'dart:io';
import 'dart:convert';

import 'package:anthem/pages/initial/initial_artists_page.dart';
import 'package:anthem/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:anthem/animation/fade_animation.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:anthem/globals/globals.dart' as globals;
import 'package:firebase_auth/firebase_auth.dart';

class InitialPage extends StatelessWidget {

  final user = FirebaseAuth.instance.currentUser!;

  //Twitter API call
  Future<void> getFriends() async {  
    final profile = user.providerData;
    final uid = profile.last.uid;
    final response = await http.get(
      Uri.parse('https://api.twitter.com/1.1/friends/ids.json?user_id=' + uid.toString()),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ' + dotenv.env['BEARER_TOKEN']!,
      },
    );

    Map<String, dynamic> responseJson = jsonDecode(response.body);

    var ids;

    for (var element in responseJson.entries) {
      if(element.key == "ids"){
        ids = element.value.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '').split(",");
      }
    }


    for (var id in ids){
      if (globals.artistsMap.containsKey(int.parse(id))){
        globals.artists.add(globals.artistsMap[int.parse(id)]);
      }
    }
  }

  Future<void> createUserDoc() async {
    await FirebaseFirestore.instance.collection('users').doc(user.email!).set({
      'noOfRatedSongs': 0.toInt(),
      'noOfFavoriteSongs': 0.toInt(),
      'lastLocation': null
    });
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Expanded(  
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 100),
                  child: FadeAnimation(0.5, Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text("First, we need to get to know you.", style: TextStyle(fontSize: 45, fontWeight: FontWeight.w800, color: Colors.white)),
                    ]
                  ))
                )
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: FadeAnimation(0.9, ElevatedButton(
                          child: Text('Continue'),
                          style: ElevatedButton.styleFrom(primary: Constants.kPrimaryColor, onPrimary: Colors.white,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10),
                          )),
                          onPressed: () async {
                            await getFriends();
                            await createUserDoc();
                            debugPrint(globals.artists.toString());
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InitialArtistsPage(),
                              ),
                            );
                          },
                        ))
                      )
                    ]
                  )
                )
    
              )
            ],
          )
        )
      )
      )
    );
  }

}