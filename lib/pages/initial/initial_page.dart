import 'package:anthem/pages/initial/initial_artists_page.dart';
import 'package:flutter/material.dart';
import 'package:anthem/animation/fade_animation.dart';


class InitialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: 
    SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(  
              flex: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: FadeAnimation(0.5, Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text("First, we need to get to know you.", style: TextStyle(fontSize: 50, fontWeight: FontWeight.w800, color: Colors.white)),
                  ]
                ))
              )
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: FadeAnimation(0.9, ElevatedButton(
                        child: Text('Continue'),
                        style: ElevatedButton.styleFrom(primary: Colors.grey.shade900, onPrimary: Colors.greenAccent,
                        shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20),
                            )),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InitialArtistsPage(),
                            ),
                          );
                        },
                      ))
                    )
                  ]
                )
              )
  
            )
          ],
        )
      )
    )
    );
  }

}