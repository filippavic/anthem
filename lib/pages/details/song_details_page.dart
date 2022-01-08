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
    var document = FirebaseFirestore.instance.collection('users').doc(user.email).collection('ratedSongs').doc(widget.songID);

    document.get().then((data) => {
      setState(() { _songRating = (data['rating'] as int).toDouble();})
    }).catchError((error) {
      setState(() { _songRating = 0.0;});
    });
  }


  void saveRating() async {
    // Save rating for the user
    var batch = FirebaseFirestore.instance.batch();

    var newGroup = FirebaseFirestore.instance.collection('users').doc(user.email);
    batch.update(newGroup, {'noOfRatedSongs': FieldValue.increment(1)});

    if (_songRating! >= 3) {
      batch.update(newGroup, {'noOfFavoriteSongs': FieldValue.increment(1)});

      var newFavorite = newGroup.collection('favoriteSongs').doc(widget.songID);
      batch.set(newFavorite, {
        'name': _song!.name,
        'album': _song!.album,
        'artists': _song!.artists,
        'releaseDate': _song!.releaseDate,
        'energy': _song!.energy,
        'acousticness': _song!.acousticness,
        'valence': _song!.valence,
        'id': _song!.songID
      });
    }

    var newMember = newGroup.collection('ratedSongs').doc(widget.songID);
    batch.set(newMember, {
      'rating': _songRating!.toInt(),
      'dateRated': DateTime.now()
    });

    batch.commit().then((value) => {
      setState(() { _ratingChange = false;})
    }).catchError((err) {
      print(err);
    });

    // Save rating globally
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);

    var query = FirebaseFirestore.instance.collection('ratings').where('date', isEqualTo: date).limit(1).get();

    query.then((data) async {
      var d = data.docs;
      if (d.isEmpty) {
        // This date doesn't exists
        var batch = FirebaseFirestore.instance.batch();

        var newGroup = FirebaseFirestore.instance.collection('ratings').doc();
        batch.set(newGroup, {'date': date});

        var newMember = newGroup.collection('songs').doc(_song!.songID);
        batch.set(newMember, {
          'name': _song!.name,
          'artists': _song!.artists,
          'ratings': _songRating!.toInt()
        });

        batch.commit().catchError((err) {
          print(err);
        });
      }
      else {
        // This date is already in the databse
        var listDocs = d.map((DocumentSnapshot docSnapshot) {
          return docSnapshot.id;
        }).toList();
        var querySong = await FirebaseFirestore.instance.collection('ratings').doc(listDocs[0]).collection('songs').doc(widget.songID).get();
  
        if (querySong.data() != null) {
          // So is the song
          var ratings = querySong.data()!['ratings'] as List<dynamic>;
          ratings.add(_songRating!.toInt());
          FirebaseFirestore.instance.collection('ratings').doc(listDocs[0]).collection('songs').doc(widget.songID).update({
            'ratings': ratings
          });
        }
        else {
          // The song isn't in the database
          var ratings = [_songRating!.toInt()];
          FirebaseFirestore.instance.collection('ratings').doc(listDocs[0]).collection('songs').doc(widget.songID).set({
            'name': _song!.name,
            'artists': _song!.artists,
            'ratings': ratings
          });
        }
      }
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