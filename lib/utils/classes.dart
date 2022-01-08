class PositionData {
  const PositionData({
    required this.lat,
    required this.lng
  });

  final double lat;
  final double lng;
}


class Song {
  const Song({
    required this.songID,
    required this.name,
    required this.album,
    required this.artists,
    required this.releaseDate,
    required this.energy,
    required this.acousticness,
    required this.valence
  });

  final String songID;
  final String name;
  final String album;
  final List<dynamic> artists;
  final String releaseDate;
  final double energy;
  final double acousticness;
  final double valence;
}


class SongRating {
  const SongRating({
    required this.songID,
    required this.name,
    required this.artists,
    required this.ratings,
    this.avgRating
  });

  final String songID;
  final String name;
  final List<dynamic> artists;
  final List<dynamic> ratings;
  final double? avgRating;
}