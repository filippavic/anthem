import 'package:dio/dio.dart';
import 'dart:core';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherApi {
  Map<String, String>? headers;
  String searchEndpoint = dotenv.env['WEATHER_SEARCH_ENDPOINT']!;
  String appId = dotenv.env['WEATHER_APP_ID']!;

  fetchWeather(String cityQuery) async {

    final dio = Dio(BaseOptions(
        baseUrl: searchEndpoint,
        contentType: "application/json"
      ));

      final response = await dio.get("", queryParameters: {
        "q": cityQuery,
        "appid": appId,
        'units': 'metric'
      });

    var currentWeather, currentTemp, minTemp, maxTemp, city, dateTime;

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var weather = response.data;

      weather.entries.forEach((element) {
        if(element.key == "weather"){
          currentWeather =  element.value.toString().split(",")[1].split(":")[1].toString().replaceAll(' ', '');
        }
        if(element.key == "main"){
          currentTemp =  element.value.toString().split(",")[0].split(":")[1].toString().replaceAll(' ', '');
          minTemp =  element.value.toString().split(",")[2].split(":")[1].toString().replaceAll(' ', '');
          maxTemp =  element.value.toString().split(",")[3].split(":")[1].toString().replaceAll(' ', '');
        }
        if(element.key == "dt"){
          dateTime = element.value.toString();
        }
        if(element.key == "name"){
          city =  element.value.toString();
        }
      }
      );

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load weather');
    }

    var weatherResponse = {
      'currentWeather': currentWeather,
      // 'currentTemp': currentTemp,
      // 'city': city,
      // 'dateTime': DateTime.now().toString()
    };

    return weatherResponse;

  }


  fetchWeatherByCoordinates(String lat, String lng) async {

    final dio = Dio(BaseOptions(
        baseUrl: searchEndpoint,
        contentType: "application/json"
      ));

      final response = await dio.get("", queryParameters: {
        "lat": lat,
        "lon": lng,
        "appid": appId,
        'units': 'metric'
      });

    var currentWeather, currentTemp, minTemp, maxTemp, city, dateTime;

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var weather = response.data;

      weather.entries.forEach((element) {
        if(element.key == "weather"){
          currentWeather =  element.value.toString().split(",")[1].split(":")[1].toString().replaceAll(' ', '');
        }
        if(element.key == "main"){
          currentTemp =  element.value.toString().split(",")[0].split(":")[1].toString().replaceAll(' ', '');
          minTemp =  element.value.toString().split(",")[2].split(":")[1].toString().replaceAll(' ', '');
          maxTemp =  element.value.toString().split(",")[3].split(":")[1].toString().replaceAll(' ', '');
        }
        if(element.key == "dt"){
          dateTime = element.value.toString();
        }
        if(element.key == "name"){
          city =  element.value.toString();
        }
      }
      );

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load weather');
    }

    var weatherResponse = {
      'currentWeather': currentWeather,
      // 'currentTemp': currentTemp,
      // 'city': city,
      // 'dateTime': DateTime.now().toString()
    };

    return weatherResponse;

  }


}