import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tmdb_movie/constants.dart';
import 'package:flutter_tmdb_movie/main.dart';
import 'package:flutter_tmdb_movie/models/upcoming_movie.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._();
  factory LocalStorage() => _instance;

  LocalStorage._();

  late Database _db;

  List<String> _migrationScripts = [
    "CREATE TABLE ${Constants.UPCOMING_MOVIE_TABLE}(id INTEGER PRIMARY KEY, poster_path TEXT, adult INTEGER, overview TEXT, release_date TEXT, genre_ids TEXT, original_title TEXT, original_language TEXT, title TEXT, backdrop_path TEXT, popularity REAL, vote_count INTEGER, video INTEGER, vote_average REAL)",
  ];

  void init() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), Constants.DB_NAME),
      version: _migrationScripts.length,
      onCreate: (db, version) async {
        for (int i = 1; i <= version; ++i) {
          await db.execute(_migrationScripts[i - 1]);
        }
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        for (int i = oldVersion + 1; i <= newVersion; ++i) {
          await db.execute(_migrationScripts[i - 1]);
        }
      },
      onOpen: (db) async {},
    );
  }

  Future<void> insertUpcomingMovies(List<UpcomingMovie> movies) async {
    await _db.transaction((txn) async {
      movies.forEach((element) {
        txn.insert(Constants.UPCOMING_MOVIE_TABLE, element.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      });
    });
  }

  Future<List<UpcomingMovie>> retrieveUpcomingMovies() async {
    final List<Map> records = await _db.query(
      Constants.UPCOMING_MOVIE_TABLE,
      distinct: true,
      columns: null,
      orderBy: 'popularity DESC',
      // limit: page * 20,
    );
    return List.generate(
        records.length, (i) => UpcomingMovie.fromMap(records[i]));
  }

  Future<void> deleteUpcomingMovies() async {
    _db.delete(Constants.UPCOMING_MOVIE_TABLE);
  }

  Future<List<UpcomingMovie>> saveAndRetrieve(
      List<UpcomingMovie> movies) async {
    if (navigatorKey.currentContext != null) {
      movies.forEach((movie) {
        if (movie.posterPath != null) {
          final url = Constants.IMG_BASE_URL +
              "${Constants.IMG_WIDTH}" +
              movie.posterPath!;
          precacheImage(
              CachedNetworkImageProvider(url), navigatorKey.currentContext!);
        }
      });
    }
    await insertUpcomingMovies(movies);
    return await retrieveUpcomingMovies();
  }
}
