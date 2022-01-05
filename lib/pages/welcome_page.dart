import 'package:anthem/components/sign_in_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:anthem/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:anthem/utils/resource.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    User? result = FirebaseAuth.instance.currentUser;

    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Scaffold(
          body:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(  
              flex: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(Constants.title, style: TextStyle(fontSize: 62, fontWeight: FontWeight.w800, color: Colors.white)),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      Constants.textIntro,
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.grey.shade300,
                      )
                    )
                  ]
                )
              )
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    result == null ?
                    SignInButton(loginType: LoginType.Twitter,faIcon: FaIcon(FontAwesomeIcons.twitter))
                    :
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(                   
                        child: Text('Continue'),
                        style: ElevatedButton.styleFrom(primary: Colors.grey.shade900, onPrimary: Colors.white,
                        shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20),
                            )),
                        onPressed: () {
                          // Navigator.pushReplacementNamed(context, "/home");

                          // ====================================================
                          // Always navigate to initial pages - for testing only!
                          Navigator.pushReplacementNamed(context, "/initial-page");
                        },
                      )
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