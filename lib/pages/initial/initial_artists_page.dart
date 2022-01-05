// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:anthem/animation/fade_animation.dart';
import 'package:anthem/pages/home_page.dart';

class InitialArtistsPage extends StatefulWidget {
  const InitialArtistsPage({ Key? key }) : super(key: key);

  @override
  _InitialArtistsPageState createState() => _InitialArtistsPageState();
}

class _InitialArtistsPageState extends State<InitialArtistsPage> {
  final user = FirebaseAuth.instance.currentUser!;

  List<dynamic> _artists =[
    ['Mariah Carey', 'https://i.scdn.co/image/ab6761610000517461355b9684caa60615698e66', '4iHNK0tOyZPYnBU7nGAgpQ'],
    ['Wham!', 'https://i.scdn.co/image/cdde1f06ec2ac6defe5d678444a357ce2ac49040', '5lpH0xAS4fVfLkACg9DAuM'],
    ['Elton John', 'https://i.scdn.co/image/ab6761610000f1780a7388b95df960b5c0da8970', '3PhoLpVuITZKcymswpck5b'],
    ['Petar Grašo', 'https://i.scdn.co/image/ab6761610000f178494fb8d264ab7a5483db4da1', '1JbDmDlop4Pm4IyJhc22jt'],
    ['Taylor Swift', 'https://i.scdn.co/image/ab6761610000f1789e3acf1eaf3b8846e836f441', '06HL4z0CvFAxyc27GXpf02'],
    ['Queen', 'https://i.scdn.co/image/c06971e9ff81696699b829484e3be165f4e64368', '1dfeR4HaWDbWqFHLkxsg1d'],
    ['ABBA', 'https://i.scdn.co/image/ab6761610000f178118de0c58b11e1fd54b66640', '0LcJLqbBmaGUft1e9Mm8HV']
  ];

  List<String> _selectedArtists = [];


  void setFavoriteArtists() async {
    // var genreCollection = FirebaseFirestore.instance.collection('users').doc(user.email).collection('favoriteArtists');

    for (var artist in _artists) {
      if (!_selectedArtists.contains(artist[2])) {
        // genreCollection.doc(artist[2]).delete();
      }
      else {
        // genreCollection.doc(artist[2]).set({
        //   'artistName': artist[0],
        //   'artistImageUrl': artist[1],
        //   'artistId': artist[2]
        // });
      }
    }

    Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light
    ));

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: _selectedArtists.isNotEmpty ? FloatingActionButton(
        onPressed: () {
          setFavoriteArtists();
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => HomePage()
          //   ),
          // );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${_selectedArtists.length}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
            SizedBox(width: 2),
            Icon(Icons.arrow_forward_ios, size: 18, color: Colors.greenAccent,),
          ],
        ),
        backgroundColor: Colors.white,
      ) : null,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: FadeAnimation(1, Padding(
                padding: EdgeInsets.only(top: 120.0, right: 20.0, left: 20.0),
                child: Text(
                  'We looked at your Twitter and found these artists. Which of them do you like?',
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ))
          ];
        },
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: _artists.length,
            itemBuilder: (BuildContext context, int index) {
              return FadeAnimation((1.2 + index) / 4, artist(_artists[index], index));
            }
          ),
        ),
      )
    );
  }
  
  artist(List artist, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedArtists.contains(artist[2]))
            _selectedArtists.remove(artist[2]);
          else 
            _selectedArtists.add(artist[2]);
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        margin: EdgeInsets.only(bottom: 20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            color: _selectedArtists.contains(artist[2]) ? Colors.greenAccent : Colors.greenAccent.withOpacity(0),
            width: 2.0,
          ),
          color: _selectedArtists.contains(artist[2]) ? Colors.grey.shade900 : Colors.grey.shade900,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(artist[1]),
                    ),
                    SizedBox(width: 20.0,),
                    Text(artist[0], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey.shade300),),
                  ],
                ),
                Spacer(),
                _selectedArtists.contains(artist[2]) ? 
                  Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Icon(Icons.check, color: Colors.greenAccent, size: 20,)
                  ) : 
                  SizedBox()
              ],
            ),
          ],
        )
      ),
    );
  }
}