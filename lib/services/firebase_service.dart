import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:anthem/utils/resource.dart';
import 'package:twitter_login/twitter_login.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> linkProviders(UserCredential userCredential, AuthCredential newCredential) async {
    return await userCredential.user!.linkWithCredential(newCredential);
  }

  Future<Resource?> signInWithTwitter() async {
    final twitterLogin = TwitterLogin(
      apiKey: dotenv.env['API_KEY']!,
      apiSecretKey: dotenv.env['API_SECRET_KEY']!,
      redirectURI: dotenv.env['REDIRECT_URI']!,
    );
    final authResult = await twitterLogin.login();

    switch (authResult.status) {
      case TwitterLoginStatus.loggedIn:
        final AuthCredential twitterAuthCredential =
            TwitterAuthProvider.credential(
                accessToken: authResult.authToken!,
                secret: authResult.authTokenSecret!);

        final userCredential =
            await _auth.signInWithCredential(twitterAuthCredential);
        return Resource(status: Status.Success);
      case TwitterLoginStatus.cancelledByUser:
        return Resource(status: Status.Cancelled);
      case TwitterLoginStatus.error:
        return Resource(status: Status.Error);
      default:
        return null;
    }
  }

  Future<void> signOutFromGoogle() async {
    await _auth.signOut();
  }

  Future<void> signOutFromTwitter() async {
    await _auth.signOut();
  }
}