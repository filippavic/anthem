import 'dart:async';
import 'package:anthem/animation/fade_animation.dart';
import 'package:anthem/pages/details/favorite_songs_page.dart';
import 'package:anthem/pages/details/song_details_page.dart';
import 'package:anthem/services/weather_api.dart';
import 'package:anthem/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:anthem/utils/chart_data.dart';

class LibraryView extends StatefulWidget {
  @override
  _LibraryViewState createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {

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
                            "My Library",
                            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Favourite artists",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
                              ),
                              Text(
                                "See all",
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey.shade700),
                              ),
                            ],
                          ), 
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                height: 100,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade900,
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(image: NetworkImage(artistsMap[0][1]), fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken))
                                ),
                                child:
                                  Text(
                                    artistsMap[0][0],
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)
                                  ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                height: 100,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade900,
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(image: NetworkImage(artistsMap[1][1]), fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken))
                                ),
                                child:
                                  Text(
                                    artistsMap[1][0],
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)
                                  ),
                              )
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                height: 100,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade900,
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(image: NetworkImage(artistsMap[2][1]), fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken))
                                ),
                                child:
                                  Text(
                                    artistsMap[2][0],
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)
                                  ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                height: 100,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade900,
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(image: NetworkImage(artistsMap[3][1]), fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken))
                                ),
                                child:
                                  Text(
                                    artistsMap[3][0],
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)
                                  ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Favourite songs",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FavoriteSongsPage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "See all",
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white),
                                  ),
                              ),
                            ],
                          ), 
                          SizedBox(height: 5),
                          ListView(
                            shrinkWrap: true,
                            children: <Widget>[
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
                                          Text(songs[0][1], style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                                          Text(songs[0][0], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade300))
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
                                        builder: (context) => SongDetailsPage("1sFWEpf1aPYN576LS1aa4Y"),
                                      ),
                                    );
                                  },
                                )
                              ),
                              SizedBox(height: 10),
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
                                          Text(songs[1][1], style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                                          Text(songs[1][0], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade300))
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
                                        builder: (context) => SongDetailsPage("1sFWEpf1aPYN576LS1aa4Y"),
                                      ),
                                    );
                                  },
                                )
                              ),
                              SizedBox(height: 10),
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
                                          Text(songs[2][1], style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                                          Text(songs[2][0], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade300))
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
                                        builder: (context) => SongDetailsPage(songs[2][2]),
                                      ),
                                    );
                                  },
                                )
                              ),
                              SizedBox(height: 10),
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
                                          Text(songs[3][1], style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                                          Text(songs[3][0], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade300))
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
                                        builder: (context) => SongDetailsPage("1m81kKiAMphhyNvuazFoui"),
                                      ),
                                    );
                                  },
                                )
                              ),
                            ],
                          ),
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