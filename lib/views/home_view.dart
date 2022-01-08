import 'dart:async';
import 'package:anthem/animation/fade_animation.dart';
import 'package:anthem/services/geolocation.dart';
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
  int? _noOfRatedSongs;
  int? _noOfFavoriteSongs;

  @override
  void initState() {
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());

    _getCurrentWeather();
    Timer.periodic(Duration(seconds: 300), (Timer t) => _getCurrentWeather());

    _getMusicStats();

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

    document.then((data) => {
      setState(() { _noOfFavoriteSongs = (data['noOfFavoriteSongs'] as int).toInt(); _noOfRatedSongs = (data['noOfRatedSongs'] as int).toInt();})
    }).catchError((error) {
      // error
    });
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
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Artist #1, Artist #2, Artist #3'),
                                      Text('... and more!')
                                    ],
                                  ),
                                  Icon(Icons.arrow_right_rounded)
                                ],),
                              style: ElevatedButton.styleFrom(primary: Constants.kQuartaryColor, onPrimary: Colors.white,
                              shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(10),
                                    
                                  )),
                              onPressed: () {
                              },
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