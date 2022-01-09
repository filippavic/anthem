import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<QuerySnapshot<Map<String, dynamic>>> getRecommendations(String userID) async {
  var snap = await FirebaseFirestore.instance.collection('users').doc(userID).collection('favoriteSongs').get();

  // Sljedece, napraviti statistiku na temelju koje ce se raditi recommend

  // Lista varijanci po kojoj ce se raditi range u kojem ce biti sljedeci recommend
  List<double> variances = List<double>.filled(3, 0);

  // Lista srednjih vrijednosti
  List<double> averages = List<double>.filled(3, 0);

  List<double> _energy = [];
  List<double> _valence = [];
  List<double> _acousticness = [];

  var numberOfSongs = snap.size;

  // Ovo ce biti potrebno kasnije
  var _songId = [];

  // Za svaku pjesmu spremiti rezultate u navedene liste
  snap.docs.forEach((res) {
    var data = res.data();
    _energy.add(data["energy"]);
    averages[0] += data["energy"]/numberOfSongs;
    _valence.add(data["valence"]);
    averages[0] += data["valence"]/numberOfSongs;
    _acousticness.add(data["acousticness"]);
    averages[0] += data["acousticness"]/numberOfSongs;
    _songId.add(data["id"]);
  });

  var lists = [_energy, _valence, _acousticness];
  var strings = ["energy", "valence", "acousticness"];

  var i = 0;
  for (var list in lists) {
    var total = 0.0;
    for (var number in list) {
      total += pow(averages[i] - number, 2);
    }
    variances[i] = sqrt(total/(numberOfSongs-1));
    i++;
  }

  var minVariance = variances.reduce((curr, next) => curr > next? curr: next);

  var index = variances.indexOf(minVariance);
  var bestAtribute = strings[index];

  // Sada na temelju dobivenog rezultata radimo recommend, listamo po rangu atributa, da nisu u favoritima, sortirano po ratingu (jedino nisam siguran kako ide ako nema rating, raspada li se query?)

  // Zato sto je lista ida pjesama ogranicena (nije moguce dobiti rezultat koji potpuno nema ni jednu pjesmu u favoritima) smanjiti _songId listu na 10 (max)
  var compList;

  if (_songId.length > 10){
    compList = _songId.sublist(0,10);
  } else {
    compList = _songId;
  }

  //lista preporucenih pjesama
  var songs = FirebaseFirestore.instance.collection('songs')
              .where(bestAtribute, isLessThan: averages[index] + variances[index])
              .where(bestAtribute, isGreaterThan: averages[index] - variances[index])
              // .where("id", whereNotIn: compList)
              .limit(10)
              .get();
  
  return songs;
}