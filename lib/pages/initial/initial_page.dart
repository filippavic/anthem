import 'dart:io';
import 'dart:convert';

import 'package:anthem/pages/initial/initial_artists_page.dart';
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

  //Twitter API call
  Future<void> getFriends() async {
    final user = FirebaseAuth.instance.currentUser!;
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: 
    SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(  
              flex: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: FadeAnimation(0.5, Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text("First, we need to get to know you.", style: TextStyle(fontSize: 50, fontWeight: FontWeight.w800, color: Colors.white)),
                  ]
                ))
              )
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: FadeAnimation(0.9, ElevatedButton(
                        child: Text('Continue'),
                        style: ElevatedButton.styleFrom(primary: Colors.grey.shade900, onPrimary: Colors.greenAccent,
                        shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20),
                            )),
                        onPressed: () async {
                          await getFriends();
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
    );
  }

}