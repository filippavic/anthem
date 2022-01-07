import 'package:firebase_auth/firebase_auth.dart';
import 'package:anthem/services/firebase_service.dart';
import 'package:anthem/utils/constants.dart';
import 'package:anthem/utils/resource.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignInButton extends StatefulWidget {
  final FaIcon faIcon;
  final LoginType loginType;

  SignInButton({Key? key, required this.faIcon, required this.loginType})
      : super(key: key);

  @override
  _SignInButtonState createState() => _SignInButtonState();
}

class _SignInButtonState extends State<SignInButton> {
  bool isLoading = false;
  FirebaseService service = new FirebaseService();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              icon: this.widget.faIcon,
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                await this.loginWithProviders();
                setState(() {
                  isLoading = false;
                });
              },
              label: Text(
                Constants.textSignInTwitter,
                style: TextStyle(
                    color: Constants.kTextColor, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(primary: Constants.kPrimaryColor, onPrimary: Colors.white,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10),
              )),
            ),
          );
  }

  void showMessage(FirebaseAuthException e) {
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(e.message!),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () async {
                  Navigator.of(builderContext).pop();
                  if (e.code == 'account-exists-with-different-credential') {
                    List<String> emailList = await FirebaseAuth.instance
                        .fetchSignInMethodsForEmail(e.email!);
                    if (emailList.first == "google.com") {
                              Navigator.pushNamedAndRemoveUntil(
            context, "/home", (route) => false);
                    }
                  }
                },
              )
            ],
          );
        });
  }

  Future<void> loginWithProviders() async {
    String? displayName;
    Resource? result = Resource(status: Status.Error);
    try {
      switch (this.widget.loginType) {
        case LoginType.Twitter:
          result = await service.signInWithTwitter();
          break;
      }
      if (result!.status == Status.Success || displayName != null) {
        // Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);

        // ====================================================
        // Always navigate to initial pages - for testing only!
        Navigator.pushNamedAndRemoveUntil(context, "/initial-page", (route) => false);
      }
    } on Exception catch (e) {
      if (e is FirebaseAuthException) {
        showMessage(e);
      }
    }
  }
}