import 'package:equatable/equatable.dart';

class UpcomingMovie extends Equatable {
  final int id;
  final String? posterPath;
  final bool adult;
  final String overview;
  final String releaseDate;
  final List<int> genreIds;
  final String originalTitle;
  final String originalLanguage;
  final String title;
  final String? backdropPath;
  final num popularity;
  final int voteCount;
  final bool video;
  final num voteAverage;

  UpcomingMovie.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        posterPath = json['poster_path'],
        adult = json['adult'],
        overview = json['overview'],
        releaseDate = json['release_date'],
        genreIds = json['genre_ids'].map<int>((e) => e as int).toList(),
        originalTitle = json['original_title'],
        originalLanguage = json['original_language'],
        title = json['title'],
        backdropPath = json['backdrop_path'],
        popularity = json['popularity'],
        voteCount = json['vote_count'],
        video = json['video'],
        voteAverage = json['vote_average'];

  // for sqflite
  Map<String, dynamic> toMap() => {
        "id": id,
        "poster_path": posterPath,
        "adult": adult ? 1 : 0,
        "overview": overview,
        "release_date": releaseDate,
        "genre_ids": listIntToString(genreIds),
        "original_title": originalTitle,
        "original_language": originalLanguage,
        "title": title,
        "backdrop_path": backdropPath,
        "popularity": popularity,
        "vote_count": voteCount,
        "video": video ? 1 : 0,
        "vote_average": voteAverage
      };

  UpcomingMovie.fromMap(Map<dynamic, dynamic> map)
      : id = map['id'],
        posterPath = map['poster_path'],
        adult = map['adult'] == 0 ? false : true,
        overview = map['overview'],
        releaseDate = map['release_date'],
        genreIds = stringToListInt(map['genre_ids']),
        originalTitle = map['original_title'],
        originalLanguage = map['original_language'],
        title = map['title'],
        backdropPath = map['backdrop_path'],
        popularity = map['popularity'],
        voteCount = map['vote_count'],
        video = map['video'] == 0 ? false : true,
        voteAverage = map['vote_average'];

  static String listIntToString(List<int> list) {
    String result = "";
    if (list.isNotEmpty) {
      result = list.map<String>((e) => e.toString()).join(",");
    }
    return result;
  }

  static List<int> stringToListInt(String s) {
    List<int> result = <int>[];
    if (s.isNotEmpty) {
      result = s.split(",").map<int>((e) => int.parse(e)).toList();
    }
    return result;
  }

  @override
  List<Object?> get props => [
        posterPath,
        adult,
        overview,
        releaseDate,
        genreIds,
        id,
        originalTitle,
        originalLanguage,
        title,
        backdropPath,
        popularity,
        voteCount,
        video,
        voteAverage
      ];
}
