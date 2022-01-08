import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:anthem/pages/initial/initial_songs_page.dart';
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


class InitialArtistsPage extends StatefulWidget {
  const InitialArtistsPage({ Key? key }) : super(key: key);

  @override
  _InitialArtistsPageState createState() => _InitialArtistsPageState();

}

class _InitialArtistsPageState extends State<InitialArtistsPage> {
  final user = FirebaseAuth.instance.currentUser!;

  List<String> _selectedArtists = [];

  Future<void> setFavoriteArtists() async {
    // var genreCollection = FirebaseFirestore.instance.collection('users').doc(user.email).collection('favoriteArtists');

    //If user follows too little artists on Twitter add default list
    if (globals.artists.length < 5){
      globals.artists.add(['Mariah Carey', 'https://i.scdn.co/image/ab6761610000517461355b9684caa60615698e66', '4iHNK0tOyZPYnBU7nGAgpQ']);
      globals.artists.add(['Wham!', 'https://i.scdn.co/image/cdde1f06ec2ac6defe5d678444a357ce2ac49040', '5lpH0xAS4fVfLkACg9DAuM']);
      globals.artists.add(['Elton John', 'https://i.scdn.co/image/ab6761610000f1780a7388b95df960b5c0da8970', '3PhoLpVuITZKcymswpck5b']);
      globals.artists.add(['Petar Grašo', 'https://i.scdn.co/image/ab6761610000f178494fb8d264ab7a5483db4da1', '1JbDmDlop4Pm4IyJhc22jt']);
      globals.artists.add(['Taylor Swift', 'https://i.scdn.co/image/ab6761610000f1789e3acf1eaf3b8846e836f441', '06HL4z0CvFAxyc27GXpf02']);
      globals.artists.add(['Queen', 'https://i.scdn.co/image/c06971e9ff81696699b829484e3be165f4e64368', '1dfeR4HaWDbWqFHLkxsg1d']);
      globals.artists.add(['ABBA', 'https://i.scdn.co/image/ab6761610000f178118de0c58b11e1fd54b66640', '0LcJLqbBmaGUft1e9Mm8HV']);
    }
  }

  // Call Spotify API and get info for all songs that have been recommended
  Future<void> getSongsInfo() async {
    final SpotifyApi spotifyApi = new SpotifyApi();
    final token = await spotifyApi.getToken();

    var songs = {};
    for (var song in globals.recommendedSongs) {
      final responseTrack = await http.get(
        Uri.parse("https://api.spotify.com/v1/tracks/" + song),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ' + token,
        },
      );
      final responseFeatures = await http.get(
        Uri.parse("https://api.spotify.com/v1/audio-features/" + song),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ' + token,
        },
      );
      var decodedTrack = json.decode(responseTrack.body);
      var decodedFeatures = json.decode(responseFeatures.body);
      var artistsIds = [];
      for (var artist in decodedTrack["artists"]) {
        artistsIds.add(artist["id"]);
      }
      var artists = [];
      for (var artist in decodedTrack["artists"]) {
        artists.add(artist["name"]);
      }
      var year = decodedTrack["album"]["release_date"].split("-")[0];
      songs[decodedTrack["id"]] = {"acousticness": decodedFeatures["acousticness"],
        "album": decodedTrack["album"]["name"],
        "album_id": decodedTrack["album"]["id"],
        "artist_ids": artistsIds,
        "artists": artists,
        "danceability": decodedFeatures["danceability"],
        "disc_number": decodedTrack["disc_number"],
        "duration_ms": decodedTrack["duration_ms"],
        "energy": decodedFeatures["energy"],
        "explicit": decodedTrack["explicit"],
        "id": decodedTrack["id"],
        "instrumentalness": decodedFeatures["instrumentalness"],
        "key": decodedFeatures["key"],
        "liveness": decodedFeatures["liveness"],
        "loudness": decodedFeatures["loudness"],
        "mode": decodedFeatures["mode"],
        "name": decodedTrack["name"],
        "release_date": decodedTrack["album"]["release_date"],
        "speechiness": decodedFeatures["speechiness"],
        "tempo": decodedFeatures["tempo"],
        "time_signature": decodedFeatures["time_signature"],
        "track_number": decodedTrack["track_number"],
        "valence": decodedFeatures["valence"],
        "year": year
      };
    }

    globals.recommendedSongsInfo = songs;
    print(globals.recommendedSongsInfo);
  }


  // Call Spotify API and get recommended songs based on selected artists
  // TODO: Limit selection to 5 artists because that is the API max
  Future<void> getSongs() async {
    final SpotifyApi spotifyApi = new SpotifyApi();
    final token = await spotifyApi.getToken();

    var seed = _selectedArtists.join("%2C");
    final response = await http.get(
      Uri.parse("https://api.spotify.com/v1/recommendations?limit=10&market=HR&seed_artists=" + seed),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ' + token,
      },
    );
    print(response.statusCode);
    var decoded = json.decode(response.body);
    var songs = [];
    for (var track in decoded["tracks"]){
      songs.add(track["id"]);
    }

    globals.recommendedSongs = songs; //Lista idjeva preporucenih pjesama
    print(globals.recommendedSongs);

  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light
    ));

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: _selectedArtists.isNotEmpty ? FloatingActionButton(
        onPressed: () async {
          await setFavoriteArtists();
          await getSongs();
          await getSongsInfo();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InitialSongsPage(),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${_selectedArtists.length}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
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
                  'We looked at your Twitter and found these artists. Which of them do you like?',
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
            itemCount: globals.artists.length,
            itemBuilder: (BuildContext context, int index) {
              return FadeAnimation((1.2 + index) / 4, artist(globals.artists[index], index));
            }
          ),
        ),
      )
    );
  }

  artist(List artist, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedArtists.contains(artist[2]))
            _selectedArtists.remove(artist[2]);
          else
            _selectedArtists.add(artist[2]);
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        margin: EdgeInsets.only(bottom: 20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            color: _selectedArtists.contains(artist[2]) ? Constants.kPrimaryColor : Constants.kPrimaryColor.withOpacity(0),
            width: 2.0,
          ),
          color: _selectedArtists.contains(artist[2]) ? Colors.grey.shade900 : Colors.grey.shade900,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(artist[1]),
                    ),
                    SizedBox(width: 20.0,),
                    Text(artist[0], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey.shade300),),
                  ],
                ),
                Spacer(),
                _selectedArtists.contains(artist[2]) ?
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