import 'dart:async';
import 'package:anthem/animation/fade_animation.dart';
import 'package:anthem/components/chart_list.dart';
import 'package:anthem/pages/details/favorite_songs_page.dart';
import 'package:anthem/pages/details/song_details_page.dart';
import 'package:anthem/services/weather_api.dart';
import 'package:anthem/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:anthem/utils/chart_data.dart';

class ChartsView extends StatefulWidget {
  @override
  _ChartsViewState createState() => _ChartsViewState();
}

class _ChartsViewState extends State<ChartsView> {

  // Time period for charts
  int _index = 0;

  var artistsMap = [
    ['Justin Bieber', 'https://i.scdn.co/image/ab676161000051748ae7f2aaa9817a704a87ea36', '1uNFoZAHBGtllmzznpCI3s'],
    ['Katy Perry', 'https://i.scdn.co/image/ab67616100005174dc9dcb7e4a97b4552e1224d6', '6jJ0s89eD6GaHleKKya26X'],
    ['Rihanna', 'https://i.scdn.co/image/ab67616100005174019d6873a01987cbe35888cd', '5pKCCKE2ajJHZ9KAiaK11H'],
    ['Taylor Swift', 'https://i.scdn.co/image/ab676161000051749e3acf1eaf3b8846e836f441', '06HL4z0CvFAxyc27GXpf02'],
  ];

  var songs = [
    ['Justin Bieber', 'Without You', '1uNFoZAHBGtllmzznpCI3s'],
    ['Katy Perry', 'Hot N Cold', '6jJ0s89eD6GaHleKKya26X'],
    ['Rihanna', 'Monster', '5pKCCKE2ajJHZ9KAiaK11H'],
    ['Taylor Swift', 'Blank Space', '06HL4z0CvFAxyc27GXpf02'],
    ['Taylor Swift', 'Blank Space', '06HL4z0CvFAxyc27GXpf02'],
  ];

  // Widget buildCharts() {
  //   switch(_index) {
  //     case 1:
  //       return ChartList(ChartDuration.month);
  //     case 2:
  //       return ChartList(ChartDuration.year);
  //     case 0:
  //     default:
  //       return ChartList(ChartDuration.week);
  //   }
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .5,
            decoration: BoxDecoration(
              // color: Constants.kPrimaryColor,
            ),
          ),
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  tileMode: TileMode.decal,
                  colors: [
                    Constants.kPrimaryColor.withOpacity(0),
                    Constants.kPrimaryColor.withOpacity(.75),
                    // Constants.kPrimaryColor.withOpacity(1),
                    // Constants.kPrimaryColor.withOpacity(1),
                    // Constants.kPrimaryColor.withOpacity(1),
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
                            "Top Rated",
                            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 100,
                                child: ElevatedButton(                  
                                  child: Text("Week", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                                  style: ElevatedButton.styleFrom(primary: _index == 0 ? Constants.kQuartaryColor : Colors.transparent, onPrimary: Colors.white,
                                  shape: new RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(10),
                                        side: BorderSide(color: Colors.white24, width: _index == 0 ? 0 : 2)
                                      )),
                                  onPressed: () {
                                    setState(() {
                                      this._index = 0;
                                    });
                                  },
                                ),
                              ),  
                              SizedBox(
                                width: 100,
                                child: ElevatedButton(                  
                                  child: Text("Month", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                                  style: ElevatedButton.styleFrom(primary: _index == 1 ? Constants.kQuartaryColor : Colors.transparent, onPrimary: Colors.white,
                                  shape: new RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(10),
                                        side: BorderSide(color: Colors.white24, width: _index == 1 ? 0 : 2)
                                      )),
                                  onPressed: () {
                                    setState(() {
                                      this._index = 1;
                                    });
                                  },
                                ),
                              ),  
                              SizedBox(
                                width: 100,
                                child: ElevatedButton(                  
                                  child: Text("Year", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                                  style: ElevatedButton.styleFrom(primary: _index == 2 ? Constants.kQuartaryColor : Colors.transparent, onPrimary: Colors.white,
                                  shape: new RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(10),
                                        side: BorderSide(color: Colors.white24, width: _index == 2 ? 0 : 2)
                                      )),
                                  onPressed: () {
                                    setState(() {
                                      this._index = 2;
                                    });
                                  },
                                ),
                              ),  
                            ],
                          ), 
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (_index == 0) ChartList(key: Key("week"), duration: ChartDuration.week)
                          else if (_index == 1) ChartList(key: Key("month"), duration: ChartDuration.month)
                          else ChartList(key: Key("year"), duration: ChartDuration.year)
                        ],
                      ),
                    ),
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