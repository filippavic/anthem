import 'dart:async';
import 'package:anthem/animation/fade_animation.dart';
import 'package:anthem/pages/details/recommended_song_page.dart';
import 'package:anthem/services/geolocation.dart';
import 'package:anthem/services/recommender_service.dart';
import 'package:anthem/services/weather_api.dart';
import 'package:anthem/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'package:anthem/utils/chart_data.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  // User data 
  final user = FirebaseAuth.instance.currentUser!;

  // Time and weather
  late String _timeString;
  String _currentWeather = "";

  // Songs
  List<dynamic> _recommendedSongs = [];
  List<dynamic> _distinctArtists = [];
  bool _isLoading = true;

  // Statistics
  int? _noOfRatedSongs;
  int? _noOfFavoriteSongs;
  double? _avgEnergy;
  double? _avgValence;
  double? _avgAcousticness;

  @override
  void initState() {
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());

    _getCurrentWeather();
    Timer.periodic(Duration(seconds: 300), (Timer t) => _getCurrentWeather());

    _getMusicStats();

    _getRecommendedSongs();

    super.initState();
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);

    if (this.mounted) {
      setState(() {
        _timeString = formattedDateTime;
      });
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('kk:mm').format(dateTime);
  }

  void _getCurrentWeather() async {
    Position? currentPosition;

    await determinePosition().then((value) => {
      currentPosition = value
    }).onError((error, stackTrace) => {});

    if (currentPosition != null) {
      // Save last known location to database
      FirebaseFirestore.instance.collection('users').doc(user.email).update({
        'lastLocation': GeoPoint(currentPosition!.latitude, currentPosition!.longitude)
      });

      final response = await WeatherApi().fetchWeatherByCoordinates(currentPosition!.latitude.toString(), currentPosition!.longitude.toString());

      if (this.mounted) {
        setState(() {
          _currentWeather = response['currentWeather'].toString().toLowerCase();
        });
      }
    }
  }

  _getMusicStats() async {
    var document = FirebaseFirestore.instance.collection('users').doc(user.email).get();

    document.then((data) {
      double avgEnergy = 0.0;
      double avgValence = 0.0;
      double avgAcousticness = 0.0;

      int noOfFavoriteSongs = (data['noOfFavoriteSongs'] as int).toInt();

      if (noOfFavoriteSongs > 0) {
        avgEnergy = (data['sumEnergy'] as num).toDouble() / noOfFavoriteSongs;
        avgValence = (data['sumValence'] as num).toDouble() / noOfFavoriteSongs;
        avgAcousticness = (data['sumAcousticness'] as num).toDouble() / noOfFavoriteSongs;
      }

      setState(() {
        _noOfFavoriteSongs = (data['noOfFavoriteSongs'] as int).toInt();
        _noOfRatedSongs = (data['noOfRatedSongs'] as int).toInt();
        _avgEnergy = avgEnergy;
        _avgValence = avgValence;
        _avgAcousticness = avgAcousticness;
      });
    }).catchError((error) {
      // error
    });
  }

  _getRecommendedSongs() {
    setState(() {
      _isLoading = true;
    });

    getRecommendations(user.email!).then((value) {
      List<DocumentSnapshot> templist;
      List<dynamic> list = [];
      List<String> artists = [];
      Set<dynamic> artistsSet = Set();

      templist = value.docs;

      list = templist.map((DocumentSnapshot docSnapshot) {
        return docSnapshot.data() as Map<dynamic,dynamic>;
      }).toList();

      list.shuffle();

      list.forEach((element) {
        artistsSet.addAll(element["artists"] as List<dynamic>);
      });

      setState(() {
        _distinctArtists = artistsSet.take(3).toList();
        _recommendedSongs = list;
        _isLoading = false;
      });
    });
  }

  void _openRecommendations() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecommendedSongsPage(recommendedSongs: _recommendedSongs),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .6,
            decoration: BoxDecoration(
              color: Constants.kPrimaryColor,
            ),
          ),
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0),
                    Colors.black.withOpacity(.75),
                    Colors.black.withOpacity(1),
                    Colors.black.withOpacity(1),
                    Colors.black.withOpacity(1),
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Hey!",
                            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white),
                          ),
                          Row(
                            children: [
                              Icon(FeatherIcons.settings, color: Colors.white, size: 22),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _currentWeather != "" ?
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                              children: <TextSpan>[
                                TextSpan(text: "It's "),
                                TextSpan(text: _timeString, style: TextStyle(fontWeight: FontWeight.w800, color: Constants.kQuartaryColor)),
                                TextSpan(text: " and "),
                                TextSpan(text: _currentWeather),
                                TextSpan(text: "."),
                              ]
                            )
                          ):
                          Center(
                            child: SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(strokeWidth:2.0, color: Colors.white)
                            )),
                          SizedBox(height: 15),
                          Text(
                            "Perfect for listening to your new recommendations.",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 65,
                            child: ElevatedButton(                  
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _isLoading ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2,) :
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.7,
                                        child: Text(_distinctArtists.join(", "),
                                          softWrap: false,
                                          overflow: TextOverflow.ellipsis,
                                          ),
                                      ),
                                      Text('... and more!')
                                    ],
                                  ),
                                  Icon(Icons.arrow_right_rounded)
                                ],),
                              style: ElevatedButton.styleFrom(primary: _isLoading? Constants.kSecondaryDarkBackgroundColor : Constants.kQuartaryColor, onPrimary: Colors.white,
                                                              onSurface: Colors.white24,
                              shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(10),
                                    
                                  )),
                              onPressed: _isLoading ? null : _openRecommendations,
                            )
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(                   
                              child: Text('Recommend something new'),
                              style: ElevatedButton.styleFrom(primary: Colors.transparent, onPrimary: Colors.white,
                              shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(10),
                                    side: BorderSide(color: Constants.kPrimaryColor, width: 2)
                                  )),
                              onPressed: () {
                                _getRecommendedSongs();
                              },
                            )
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Your stats",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Constants.kQuartaryColor, Constants.kPrimaryColor
                          ]
                        )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _noOfFavoriteSongs != null ?
                              Text(
                              _noOfFavoriteSongs.toString(),
                              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: Colors.white),
                              ) : CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              SizedBox(height: 8),
                              Text(
                                "favorite songs",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _noOfRatedSongs != null ?
                              Text(
                              _noOfRatedSongs.toString(),
                              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: Colors.white),
                              ) : CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              SizedBox(height: 8),
                              Text(
                                "rated songs",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                              )
                            ],
                          ),                       
                        ],
                      )
                      )
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Constants.kSecondaryDarkBackgroundColor
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _avgEnergy != null ?
                              Text(
                              _avgEnergy!.toStringAsFixed(3),
                              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: Colors.white),
                              ) : CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              SizedBox(height: 8),
                              Text(
                                "energy",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _avgValence != null ?
                              Text(
                              _avgValence!.toStringAsFixed(3),
                              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: Colors.white),
                              ) : CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              SizedBox(height: 8),
                              Text(
                                "valence",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _avgAcousticness != null ?
                              Text(
                              _avgAcousticness!.toStringAsFixed(3),
                              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: Colors.white),
                              ) : CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              SizedBox(height: 8),
                              Text(
                                "acousticness",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                              )
                            ],
                          ),                        
                        ],
                      )
                      )
                    ),
                    // SizedBox(height: 16),
                    //  Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 16),
                    //   child: Container(
                    //   width: double.infinity,
                    //   height: 160,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(15),
                    //     color: Colors.grey.shade900
                    //   ),
                    //   child: Stack(
                    //     alignment: AlignmentDirectional.center,
                    //     children: [
                    //       Container(
                    //         width: double.infinity,
                    //         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                    //         child: LineChart(
                    //           getChartData()
                    //         ),
                    //       )                     
                    //     ],
                    //   )
                    //   )
                    // ),
                    // SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}