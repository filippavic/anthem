import 'dart:async';
import 'package:anthem/animation/fade_animation.dart';
import 'package:anthem/pages/details/favorite_songs_page.dart';
import 'package:anthem/pages/details/song_details_page.dart';
import 'package:anthem/services/weather_api.dart';
import 'package:anthem/utils/classes.dart';
import 'package:anthem/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:anthem/utils/chart_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

class ChartList extends StatefulWidget {

  final ChartDuration duration;

  const ChartList({Key? key, required this.duration}) : super(key: key);

  @override
  _ChartListState createState() => _ChartListState();
}

class _ChartListState extends State<ChartList> {

  Map<String, SongRating> _songMap = {};
  List<SongRating> _songRatings = [];
  List<double> _songAvg = [];
  bool isLoading = true;

  @override
  void initState() {
    _getRatingsForDuration();

    Future.delayed(const Duration(milliseconds: 2000), () {
      _calculateTopChart(_songMap);
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  DateTime _getDateLimit() {
    var now = DateTime.now();

    switch(widget.duration) {
      case ChartDuration.year:
        return now.subtract(const Duration(days: 365));
      case ChartDuration.month:
        return now.subtract(const Duration(days: 31));
      case ChartDuration.week:
      default:
        return now.subtract(const Duration(days: 7));
    }
  }

  void _getRatingsForDuration() async {
    List<DocumentSnapshot> templist;
    List<String> listDayIDs = [];
    Map<String, SongRating> songMap = {};

    var dateLimit = _getDateLimit();

    print(dateLimit);

    Query query = FirebaseFirestore.instance.collection('ratings').where('date', isGreaterThanOrEqualTo: dateLimit);
    QuerySnapshot collectionSnapshot = await query.get();

    templist = collectionSnapshot.docs;

    listDayIDs = templist.map((DocumentSnapshot docSnapshot) {
      return docSnapshot.id;
    }).toList();

    await Future.forEach(listDayIDs, (String dayID) => {
      _getRatingsForDay(dayID).then((returnedMap) => {
        returnedMap.keys.forEach((key) {
          if (_songMap.containsKey(key)) {
            List<dynamic> newRatings = _songMap[key]!.ratings;
            newRatings.addAll(returnedMap[key]!.ratings);
            _songMap.update(key, (value) => SongRating(songID: key, name: returnedMap[key]!.name, artists: returnedMap[key]!.artists, ratings: newRatings));
          }
          else {
            _songMap[key] = SongRating(songID: key, artists: returnedMap[key]!.artists, name: returnedMap[key]!.name, ratings: returnedMap[key]!.ratings);
          }
        })
      })
    });
  }

  Future<Map<String, SongRating>> _getRatingsForDay(String dayID) async {
    List<DocumentSnapshot> templist;
    List<Map<String, dynamic>> listSongs = [];
    List<String> songIDs = [];
    Map<String, SongRating> songMap = {};

    Query query = FirebaseFirestore.instance.collection('ratings').doc(dayID).collection('songs');
    QuerySnapshot collectionSnapshot = await query.get();

    templist = collectionSnapshot.docs;

    listSongs = templist.map((DocumentSnapshot docSnapshot) {
      songIDs.add(docSnapshot.id);
      return docSnapshot.data() as Map<String,dynamic>;
    }).toList();

    for (int i = 0; i < songIDs.length; i++) {
      songMap[songIDs[i]] = SongRating(songID: songIDs[i], artists: listSongs[i]['artists'], name: listSongs[i]['name'], ratings: listSongs[i]['ratings']);
    }

    return songMap;
  }


  void _calculateTopChart(Map<String, SongRating> songMap) {
    List<SongRating> songRatings = [];

    var sortMapByValue = Map.fromEntries(
    songMap.entries.toList()
    ..sort((e1, e2) => (e1.value.ratings.map((rating) => rating).reduce((a,b) => a+b) / e1.value.ratings.length)
    .compareTo(e2.value.ratings.map((rating) => rating).reduce((a,b) => a*b) / e2.value.ratings.length)));

    _songRatings = songMap.entries.map((entry) => entry.value).toList();

    for (SongRating sr in _songRatings) {
      _songAvg.add(sr.ratings.map((rating) => rating).reduce((a,b) => a+b)/sr.ratings.length);
    }
  }


  @override
  Widget build(BuildContext context) {

    return 
    isLoading ? 
    Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2,)) 
    :
    ListView.separated(
      separatorBuilder: (BuildContext context, int index) => Divider(),
      shrinkWrap: true,
      itemCount: _songRatings.length,
      itemBuilder: (context, index) {
        final item = _songRatings[index];
        return SizedBox(
          width: double.infinity,
          height: 65,
          child: ElevatedButton(                  
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row (
                  children: [
                    Text(_songAvg[index].toStringAsFixed(1), style:TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                    SizedBox(width: 15,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                        Text(item.artists.join(","), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade300))
                      ],
                    ),
                  ],
                ),
                Icon(Icons.arrow_right_rounded)
              ],),
            style: ElevatedButton.styleFrom(primary: Constants.kSecondaryDarkBackgroundColor, onPrimary: Colors.white,
            shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10),
                  
                )),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SongDetailsPage(item.songID),
                ),
              );
            },
          )
        );
      },
    );
  }
}