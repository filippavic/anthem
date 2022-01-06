import 'dart:core';
import 'dart:convert';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication {
  final String url = "https://accounts.spotify.com/api/token";
  final Map<String, String> body = {"grant_type": "client_credentials"};
  static Map<String, String>? headers;
  String? secret;
  SharedPreferences? prefs;

  _fetchSecret() async {
    prefs ??= await SharedPreferences.getInstance();

    // Ovo se ne smije raditi (secret treba ici u .env), ali je dosta za sad
    prefs!.setString('spotify_secret', "6135702b376f4bcbb7f20066b1525dbf:cf3e47fd307f4c35bba5b4336bd7fba4");
  }

  Future<String> _getSecret() async {
    String? result;
    prefs ??= await SharedPreferences.getInstance();
    result = prefs!.getString('spotify_secret');
    if (result == null) {
      // await _fetchSecret();
      prefs!.setString('spotify_secret', "6135702b376f4bcbb7f20066b1525dbf:cf3e47fd307f4c35bba5b4336bd7fba4");
      result = "6135702b376f4bcbb7f20066b1525dbf:cf3e47fd307f4c35bba5b4336bd7fba4";
    }
    return result;
  }

  Future _setTokenExpirationDate() async {
    prefs ??= await SharedPreferences.getInstance();
    DateTime _hourFromNow = DateTime.now();
    _hourFromNow = _hourFromNow.add(const Duration(minutes: 55));

    String dateString = _hourFromNow.toString();
    prefs!.setString('token_date', dateString);
  }

  Future getAuthToken() async {
    prefs = await SharedPreferences.getInstance();
    secret = await _getSecret();

    final dioForToken = Dio(BaseOptions(
    baseUrl: url,
    headers: {
      'Authorization': 'Basic ' + base64Encode(utf8.encode(secret.toString()))
    },
    contentType: "application/x-www-form-urlencoded"
    ));

    try {
      final response = await dioForToken.post("", data: {'grant_type':'client_credentials'});

      await _setTokenExpirationDate();

      Map<dynamic, dynamic> map = jsonDecode(response.toString());

      prefs!.setString('access_token', map["access_token"]);

    } on Exception catch (e) {
      debugPrint(e.toString());
      throw AuthError(e.toString());
    }
    
  }
}

class AuthError extends Error {
  final String message;
  AuthError(this.message);
}