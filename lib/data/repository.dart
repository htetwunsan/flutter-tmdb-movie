import 'package:flutter_tmdb_movie/api/tmdb_service.dart';
import 'package:flutter_tmdb_movie/api/upcoming_response.dart';
import 'package:flutter_tmdb_movie/constants.dart';
import 'package:flutter_tmdb_movie/db/local_storage.dart';
import 'package:flutter_tmdb_movie/models/detail_movie.dart';
import 'package:flutter_tmdb_movie/models/upcoming_movie.dart';

class Repository {
  final LocalStorage _database;
  final TmdbService _service;

  Repository(this._database, this._service);

  Future<List<UpcomingMovie>> getCachedUpcomingMovie() async {
    return await _database.retrieveUpcomingMovies();
  }

  Future<List<UpcomingMovie>> getUpcomingMovieToPage(int toPage) async {
    final data = <UpcomingMovie>[];
    for (int i = Constants.TMDB_START_INDEX; i <= toPage; ++i) {
      final response = await _service.requestUpcomingMovies(i);
      data.addAll(UpcomingResponse.fromJson(response.data).results);
    }
    await _database.deleteUpcomingMovies();
    return await _database.saveAndRetrieve(data);
  }

  Future<List<UpcomingMovie>> getUpcomingMovieForPage(int page) async {
    final response = await _service.requestUpcomingMovies(page);
    final upcomingResponse = UpcomingResponse.fromJson(response.data);
    return _database.saveAndRetrieve(upcomingResponse.results);
  }

  Future<DetailMovie> getDetailMovie(int movieId) async {
    final response = await _service.requestDetailMovie(movieId);
    return DetailMovie.fromJson(response.data);
  }
}
