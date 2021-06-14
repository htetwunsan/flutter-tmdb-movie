import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tmdb_movie/data/repository.dart';
import 'package:flutter_tmdb_movie/models/detail_movie.dart';
import 'package:flutter_tmdb_movie/ui/favorite_button.dart';
import 'package:get_it/get_it.dart';

import '../../constants.dart';

// No Architecture xD

class MovieDetail extends StatefulWidget {
  final int movieId;
  final String title;
  const MovieDetail(this.movieId, this.title, {Key? key}) : super(key: key);

  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SafeArea(
          child: FutureBuilder<DetailMovie>(
              future: GetIt.I.get<Repository>().getDetailMovie(widget.movieId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                if (snapshot.hasData) {
                  final item = snapshot.data!;
                  return ListView(
                    children: [
                      Builder(
                        builder: (context) {
                          if (item.posterPath != null)
                            return CachedNetworkImage(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                placeholder: (_, __) =>
                                    CupertinoActivityIndicator(),
                                errorWidget: (_, __, error) =>
                                    Text(error.toString()),
                                fit: BoxFit.cover,
                                fadeOutDuration: Duration.zero,
                                fadeInDuration: Duration.zero,
                                imageUrl: Constants.IMG_BASE_URL +
                                    Constants.IMG_WIDTH +
                                    item.posterPath.toString());
                          return Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: Center(
                              child: Text("No Poster Image To Show"),
                            ),
                          );
                        },
                      ),
                      Text(
                        item.originalTitle,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Divider(),
                      if (item.overview != null) Text(item.overview!),
                      Divider(),
                      Text("Release Date : ${item.releaseDate}}"),
                      Text("Status : ${item.status}"),
                      Text("Budget : ${item.budget}"),
                      if (item.imdbId != null) Text("ImdbID : ${item.imdbId!}"),
                      Text("Revenue: ${item.revenue}"),
                      Align(
                        alignment: Alignment.centerRight,
                        child: FavoriteButton(item.id),
                      )
                    ],
                  );
                }
                return Center(child: const CircularProgressIndicator());
              }),
        ));
  }
}
