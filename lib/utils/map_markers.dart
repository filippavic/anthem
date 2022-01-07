import 'package:latlong2/latlong.dart';

class MapSong {
  const MapSong({
    required this.title,
    required this.artist,
    required this.id
  });

  final String title;
  final String artist;
  final String id;
}

class MapMarker {
  const MapMarker({
    required this.location,
    required this.mapSongs
  });

  final LatLng location;
  final List<MapSong> mapSongs;
}

final _locations = [
  LatLng(46.0, 15.879),
  LatLng(50.2, 15.879),
  LatLng(45.3, 15.879)
];

final mapMarkers = [
  MapMarker(location: _locations[0], mapSongs: [MapSong(title: "Popular song #1", artist: "Bastille", id: "1234"), MapSong(title: "Popular song #2", artist: "Ed Sheeran", id: "1234")]),
  MapMarker(location: _locations[1], mapSongs: [MapSong(title: "Popular song #3", artist: "Bastille", id: "1234"), MapSong(title: "Popular song #4", artist: "Ed Sheeran", id: "1234")]),
  MapMarker(location: _locations[2], mapSongs: [MapSong(title: "Popular song #5", artist: "Bastille", id: "1234"), MapSong(title: "Popular song #6", artist: "Ed Sheeran", id: "1234")])
];