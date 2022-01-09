import 'package:anthem/pages/details/song_details_page.dart';
import 'package:anthem/utils/classes.dart';
import 'package:anthem/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MusicBottomSheet extends StatefulWidget {
  final BuildContext context;
  final String userID;

  MusicBottomSheet({Key? key, required this.context, required this.userID})
      : super(key: key);

  @override
  _MusicBottomSheetState createState() => _MusicBottomSheetState();
}

class _MusicBottomSheetState extends State<MusicBottomSheet> {

  @override
  Widget build(BuildContext context) {
    return Container(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("✨ Mystery User ✨", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: Colors.white),),
          SizedBox(height: 30),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').doc(widget.userID).collection('favoriteSongs').limit(3).snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return ListView(
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
                                  Text((song["artists"] as List<dynamic>).join(","), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade300))
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
        ],
      ),),
    );
  }
}