import 'package:flutter_tmdb_movie/models/upcoming_movie.dart';

class UpcomingResponse {
  final int totalPages;
  final int totalResults;
  final List<UpcomingMovie> results;

  UpcomingResponse.fromJson(Map<String, dynamic> json)
      : totalPages = json['total_pages'],
        totalResults = json['total_results'],
        results = json['results']
            .map<UpcomingMovie>((e) => UpcomingMovie.fromJson(e))
            .toList();
}
