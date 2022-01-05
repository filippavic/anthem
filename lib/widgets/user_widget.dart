import 'package:flutter/material.dart';
import 'package:anthem/services/firebase_service.dart';
import 'package:provider/provider.dart';

class UserWidget extends StatelessWidget {

  FirebaseService service = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Pozdrav!',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 48)
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.white, onPrimary: Colors.green,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20),
              )),
              child: Text('Logout'),
              onPressed: () {
                service.signOutFromTwitter();
                Navigator.pushReplacementNamed(context, "/");
              },
            ),
          ]
        )
      )
    );
  }

}