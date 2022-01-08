import 'package:anthem/utils/classes.dart';
import 'package:anthem/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
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

  int? _songRating;

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
      setState(() { _songRating = data['rating'];})
    });
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
                        SmoothStarRating(
                          allowHalfRating: false,
                          onRated: (v) {
                            },
                          starCount: 5,
                          rating: 3.0,
                          size: 40.0,
                          isReadOnly:true,
                          color: Constants.kQuartaryColor,
                          borderColor: Colors.grey.shade500,
                          spacing:0.0
                        ),
                        SizedBox(height: 10),
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
                  child: Text('Save changes to rating'),
                  style: ElevatedButton.styleFrom(primary: Constants.kQuartaryColor, onPrimary: Colors.white,
                  shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10),
                        // side: BorderSide(color: Constants.kPrimaryColor, width: 2)
                      )),
                  onPressed: () {
                  },
                )
              )
            )
        ])
    );
  }
}