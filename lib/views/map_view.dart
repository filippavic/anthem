import 'package:anthem/components/music_bottom_sheet.dart';
import 'package:anthem/utils/constants.dart';
import 'package:anthem/utils/map_markers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {

  // Mapbox data
  String mapboxAccessToken = dotenv.env['MAPBOX_ACCESS_TOKEN']!;
  String mapboxStyle = 'mapbox/dark-v10';

  final _myLocation = LatLng(46.161, 15.879);
  final _myLocation2 = LatLng(46.159, 15.878);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              minZoom: 5,
              maxZoom: 18,
              zoom: 16,
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
                markers: [
                  Marker(
                    point: _myLocation,
                    builder: (_) {
                      return _MyLocationMarker();
                    }
                  ),
                  Marker(
                    point: _myLocation2,
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
