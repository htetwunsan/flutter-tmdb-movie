import 'package:equatable/equatable.dart';

class DetailMovie extends Equatable {
  // similar with UpcomingMovie
  final int id;
  final String? posterPath;
  final bool adult;
  final String? overview;
  final String releaseDate;
  final String originalTitle;
  final String originalLanguage;
  final String title;
  final String? backdropPath;
  final num popularity;
  final int voteCount;
  final bool video;
  final num voteAverage;

  final int budget;
  final String? imdbId;
  final int revenue;
  final String status;

  DetailMovie.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        posterPath = json['poster_path'],
        adult = json['adult'],
        overview = json['overview'],
        releaseDate = json['release_date'],
        originalTitle = json['original_title'],
        originalLanguage = json['original_language'],
        title = json['title'],
        backdropPath = json['backdrop_path'],
        popularity = json['popularity'],
        voteCount = json['vote_count'],
        video = json['video'],
        voteAverage = json['vote_average'],
        budget = json['budget'],
        imdbId = json['imdb_id'],
        revenue = json['revenue'],
        status = json['status'];

  @override
  List<Object?> get props => [
        posterPath,
        adult,
        overview,
        releaseDate,
        id,
        originalTitle,
        originalLanguage,
        title,
        backdropPath,
        popularity,
        voteCount,
        video,
        voteAverage,
        budget,
        imdbId,
        revenue,
        status
      ];
}
