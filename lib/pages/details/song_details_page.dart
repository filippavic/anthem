import 'package:anthem/utils/classes.dart';
import 'package:anthem/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SongDetailsPage extends StatefulWidget {
  final String songID;
  const SongDetailsPage(this.songID);

  @override
  _SongDetailsPageState createState() => _SongDetailsPageState();
}

class _SongDetailsPageState extends State<SongDetailsPage> {

  // User data 
  final user = FirebaseAuth.instance.currentUser!;

  Song? _song;

  double? _songRating;
  bool _ratingChange = false;

  @override
  void initState() {
    _getSongDetails();
    _getSongRatingForUser();
    super.initState();
  }

  _getSongDetails() async {
    Song song;

    var document = FirebaseFirestore.instance.collection('songs').doc(widget.songID);

    document.get().then((data) => {
      setState(() { _song = Song(
        songID: widget.songID,
        name: data['name'],
        album: data['album'],
        artists: data['artists'],
        releaseDate: data['release_date'],
        energy: data['energy'],
        acousticness: data['acousticness'],
        valence: data['valence']
      );    
      })
    });
  }

  _getSongRatingForUser() async {
    var document = FirebaseFirestore.instance.collection('ratings').doc(widget.songID).collection('userRatings').doc(user.email);

    document.get().then((data) => {
      setState(() { _songRating = (data['rating'] as int).toDouble();})
    }).catchError((error) {
      setState(() { _songRating = 0.0;});
    });
  }


  void saveRating() {
    FirebaseFirestore.instance.collection('ratings').doc(widget.songID).collection('userRatings').doc(user.email).set({
      'rating': _songRating!.toInt(),
      'dateRated': DateTime.now()
    }).then((value) => setState(() { _ratingChange = false;}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: 80),
                Container(
                  alignment: AlignmentDirectional.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        _song != null ?
                        Text(
                          _song!.name,
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white),
                          textAlign: TextAlign.center,
                        ) : CircularProgressIndicator(strokeWidth:2.0, color: Colors.white),
                        SizedBox(height: 20),
                        _song != null ?
                        Text(
                          _song!.artists.join(","),
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
                          textAlign: TextAlign.center,
                        ) : CircularProgressIndicator(strokeWidth:2.0, color: Colors.white),
                        SizedBox(height: 50),
                        RatingBar(
                        initialRating: _songRating != null ? _songRating! : 0.0,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        ratingWidget: RatingWidget(
                          full: Icon(FeatherIcons.star, color: Constants.kQuartaryColor,),
                          half: Icon(FeatherIcons.star, color: Constants.kQuartaryColor,),
                          empty: Icon(FeatherIcons.star, color: Colors.white24),
                        ),
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        onRatingUpdate: (rating) {
                          if (_songRating != null) {
                            if (_songRating != rating) {
                              setState(() { _songRating = rating;});
                              setState(() { _ratingChange = true;});
                            }
                          }
                          else {
                            setState(() { _songRating = rating;});
                            setState(() { _ratingChange = true;});
                          }
                        },
                        ),
                        SizedBox(height: 15),
                        Text(
                          "My rating",
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _song != null ?
                            Text(
                              _song!.album,
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)
                            ) : CircularProgressIndicator(strokeWidth:2.0, color: Colors.white),
                            SizedBox(height: 5,),
                            Text(
                              "Album Name",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white)
                            ),
                          ],
                        )    
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _song != null ?
                            Text(
                              _song!.releaseDate,
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)
                            ) : CircularProgressIndicator(strokeWidth:2.0, color: Colors.white),
                            SizedBox(height: 5,),
                            Text(
                              "Release Date",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white)
                            ),
                          ],
                        )    
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.29,
                        height: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _song != null ?
                            Text(
                              _song!.energy.toStringAsFixed(3),
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)
                            ) : CircularProgressIndicator(strokeWidth:2.0, color: Colors.white),
                            SizedBox(height: 5,),
                            Text(
                              "Energy",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white)
                            ),
                          ],
                        )    
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.29,
                        height: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _song != null ?
                            Text(
                              _song!.acousticness.toStringAsFixed(3),
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)
                            ) : CircularProgressIndicator(strokeWidth:2.0, color: Colors.white),
                            SizedBox(height: 5,),
                            Text(
                              "Acousticness",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white)
                            ),
                          ],
                        )    
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.29,
                        height: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _song != null ?
                            Text(
                              _song!.valence.toStringAsFixed(3),
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)
                            ) : CircularProgressIndicator(strokeWidth:2.0, color: Colors.white),
                            SizedBox(height: 5,),
                            Text(
                              "Valence",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white)
                            ),
                          ],
                        )    
                      ),
                    ],
                  ),
                ),
              ],
            )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(                   
                  child: Text('Save rating'),
                  style: ElevatedButton.styleFrom(primary: _ratingChange ? Constants.kQuartaryColor : Colors.transparent, onPrimary: Colors.white, onSurface: Colors.white24,
                  shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10),
                      )),
                  onPressed: !_ratingChange ? null : saveRating,
                )
              )
            )
        ])
    );
  }
}