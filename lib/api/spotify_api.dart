import 'package:dio/dio.dart';
// import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:anthem/api/spotify_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:core';
import 'package:anthem/globals/globals.dart' as globals;

class SpotifyApi {
  SharedPreferences? prefs;
  String? token;
  Map<String, String>? headers;
  String endpoint = "https://api.spotify.com/v1/recommendations?";
  bool? isValid;
  final Authentication auth = Authentication();

  Future<bool> _validateToken() async {
    prefs ??= await SharedPreferences.getInstance();

    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime now = DateTime.now();
    DateTime tokenDateTime;
    String? tokenDateString = prefs!.getString('token_date');

    if (tokenDateString == null) {
      // Set datetime in the past in case the device never
      // set tokenDateString before (e.g. on first install)
      tokenDateTime = DateTime(2020, 01, 01, 12, 0, 0);
    } else {
      tokenDateTime = dateFormat.parse(tokenDateString);
    }

    if (now.isAfter(tokenDateTime)) {
      return false;
    } else {
      return true;
    }
  }

  _setHeaders(String token) {
    headers = {
      "Authorization": "Bearer $token",
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
  }


  Future<String> getToken() async {
    bool tokenIsValid = await _validateToken();

    if (tokenIsValid) {
      return prefs!.getString('access_token').toString();
    } else {
      try {
        await auth.getAuthToken();
      } on AuthError catch (e) {
        throw AuthError(e.message);
      }
      return prefs!.getString('access_token').toString();
    }
  }


   // Get a list of available genres.
  Future<Response> getGenres() async {
    String endpoint = 'https://api.spotify.com/v1/recommendations/available-genre-seeds';

    bool tokenIsValid = await _validateToken();

    if (tokenIsValid) {
      final dio = Dio(BaseOptions(
        baseUrl: endpoint,
        headers: {
          'Authorization': 'Bearer ' + (prefs!.getString('access_token').toString()),
          'Content-Type': 'application/json'
        },
        contentType: "application/json"
      ));

      final response = await dio.get("");

      print(response);

      return response;

    } else {
      try {
        await auth.getAuthToken();
      } on AuthError catch (e) {
        throw AuthError(e.message);
      }

      final dio = Dio(BaseOptions(
        baseUrl: endpoint,
        headers: {
          'Authorization': 'Bearer ' + prefs!.getString('access_token').toString(),
          'Content-Type': 'application/json'
        },
        contentType: "application/json"
      ));
      
      final response = await dio.get("");

      return response;
    }
  }



}