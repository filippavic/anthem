import 'package:anthem/services/geolocation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:anthem/components/music_bottom_sheet.dart';
import 'package:anthem/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {

  // User data 
  final user = FirebaseAuth.instance.currentUser!;

  // Mapbox data
  String mapboxAccessToken = dotenv.env['MAPBOX_ACCESS_TOKEN']!;
  String mapboxStyle = 'mapbox/dark-v10';

  var _myLocation;

  List<Marker> _markers = [];


  @override
  void initState() {
    // Get user's current location
    determinePosition().then((value) => {
      setState(() { _myLocation = LatLng(value.latitude, value.longitude); })
    }).onError((error, stackTrace) => {});

    // Get locations from other users
    _getOtherUsers().then((list) => {
      setState(() { _markers = _buildMarkers(list); })
    });

    super.initState();
  }


  Future<List<GeoPoint>> _getOtherUsers() async {
    List<DocumentSnapshot> templist;
    List<Map<dynamic, dynamic>> list = [];

    Query query = FirebaseFirestore.instance.collection('users').where(FieldPath.documentId, isNotEqualTo: user.email).limit(10);
    QuerySnapshot collectionSnapshot = await query.get();

    templist = collectionSnapshot.docs;

    list = templist.map((DocumentSnapshot docSnapshot){
      return docSnapshot.data() as Map<dynamic,dynamic>;
    }).toList();

    List<GeoPoint> locationList = [];

    list.map((item) => {
      locationList.add(item['lastLocation'])
    }).toList();

    return locationList;
  }

  List<Marker> _buildMarkers(List<GeoPoint> locationList) {
    final _markerList = <Marker>[];

    locationList.forEach((element) {
      _markerList.add(
        Marker(
          point: LatLng(element.latitude, element.longitude),
          builder: (_) {
            return GestureDetector(
              child: Center(
                child:  Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: Constants.kQuartaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Constants.kQuartaryColor.withOpacity(0.7),
                        blurRadius: 10,
                        spreadRadius: 10
                      )
                    ]
                  ),
                )
              ),
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  backgroundColor: Colors.black,
                  context: context,
                  builder: (context) => MusicBottomSheet(context: context, userID: "123"));
              },
              );
          }
        )
      );
    });

    return _markerList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // This doesn't work, for some reason
          AnimatedOpacity(
          opacity: _myLocation == null ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black,
          )
          ),
          if (_myLocation != null)
          FlutterMap(
          options: MapOptions(
            minZoom: 5,
            maxZoom: 18,
            zoom: 13,
            center: _myLocation,
            interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate
          ),
          nonRotatedLayers: [
            TileLayerOptions(
              urlTemplate: 'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
              additionalOptions: {
                'accessToken': mapboxAccessToken,
                'id': mapboxStyle
              }
            ),
            MarkerLayerOptions(
              markers: _markers
            ),
            MarkerLayerOptions(
              markers: [
                Marker(
                  point: _myLocation,
                  builder: (_) {
                    return _MyLocationMarker();
                  }
                )
              ]
            )
          ],)
        ],
      )
    );
  }
}

class _MyLocationMarker extends StatelessWidget {
  const _MyLocationMarker({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child:  Container(
      height: 15,
      width: 15,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.white60,
            blurRadius: 7,
            spreadRadius: 7
          )
        ]
      ),
      )
    );
  }
}
