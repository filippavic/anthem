import 'package:anthem/pages/details/song_details_page.dart';
import 'package:anthem/utils/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteSongsPage extends StatefulWidget {
  @override
  _FavoriteSongsPageState createState() => _FavoriteSongsPageState();
}

class _FavoriteSongsPageState extends State<FavoriteSongsPage> {

  // User data 
  final user = FirebaseAuth.instance.currentUser!;

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
                        ],
                      ),
                    ),
                    SizedBox(height: 30,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('users').doc(user.email).collection('favoriteSongs').snapshots(),
                        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            return ListView(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: snapshot.data!.docs.map((song) {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: SizedBox(
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
                                              Container(
                                                width: MediaQuery.of(context).size.width * 0.7,
                                                child: Text(song["name"].toString(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                                                  softWrap: false,
                                                  overflow: TextOverflow.ellipsis,
                                                  ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context).size.width * 0.7,
                                                child: Text((song["artists"] as List<dynamic>).join(", "), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade300),
                                                  softWrap: false,
                                                  overflow: TextOverflow.ellipsis,
                                                  ),
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
                                            builder: (context) => SongDetailsPage(song["id"]),
                                          ),
                                        );
                                      },
                                    )
                                  )
                                  );
                              }).toList()
                            );
                          }
                          else {
                            return CircularProgressIndicator(color: Colors.white, strokeWidth: 2,);
                          }
                        }
                      ),
                    )
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