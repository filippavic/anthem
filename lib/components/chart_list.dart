import 'dart:async';
import 'package:anthem/pages/details/song_details_page.dart';
import 'package:anthem/utils/classes.dart';
import 'package:anthem/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ChartList extends StatefulWidget {

  final ChartDuration duration;

  const ChartList({Key? key, required this.duration}) : super(key: key);

  @override
  _ChartListState createState() => _ChartListState();
}

class _ChartListState extends State<ChartList> {

  Map<String, SongRating> _songMap = {};
  bool isLoading = true;
  List<SongAverage> _topChartList = [];

  @override
  void initState() {
    _getRatingsForDuration();

    // Wait for the calculation to finish
    Future.delayed(const Duration(milliseconds: 2000), () {
      _calculateTopChart(_songMap);
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  // Get the earliest date to include
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

  // Get the ratings for the desired time frame
  void _getRatingsForDuration() async {
    List<DocumentSnapshot> templist;
    List<String> listDayIDs = [];

    var dateLimit = _getDateLimit();

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

  // Get the song ratings for a single day
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


  // Calculate the average song ratings and sort them
  void _calculateTopChart(Map<String, SongRating> songMap) {
    List<SongAverage> songAverageRatigns = [];

    for (String songID in songMap.keys) {
      songAverageRatigns.add(SongAverage(song: songMap[songID]!, avgRating: songMap[songID]!.ratings.reduce((a,b) => a+b) / songMap[songID]!.ratings.length));
    }

    songAverageRatigns.sort((e1, e2) => e2.avgRating.compareTo(e1.avgRating));

    _topChartList = songAverageRatigns;
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
      itemCount: _topChartList.length,
      itemBuilder: (context, index) {
        final item = _topChartList[index];
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
                    Text(item.avgRating.toStringAsFixed(1), style:TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                    SizedBox(width: 15,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(item.song.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(item.song.artists.join(", "), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade300),
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            ),
                        ),     
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
                  builder: (context) => SongDetailsPage(item.song.songID),
                ),
              );
            },
          )
        );
      },
    );
  }
}