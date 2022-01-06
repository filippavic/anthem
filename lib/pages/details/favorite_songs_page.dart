import 'package:anthem/utils/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class FavoriteSongsPage extends StatefulWidget {
  @override
  _FavoriteSongsPageState createState() => _FavoriteSongsPageState();
}

class _FavoriteSongsPageState extends State<FavoriteSongsPage> {

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
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "All favourite songs",
                            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white),
                          ),
                          // List of all favourite songs
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