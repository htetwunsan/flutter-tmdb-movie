import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tmdb_movie/blocs/upcomingmovies_bloc.dart';
import 'package:flutter_tmdb_movie/constants.dart';
import 'package:flutter_tmdb_movie/models/upcoming_movie.dart';
import 'package:flutter_tmdb_movie/ui/bottom_loader.dart';
import 'package:flutter_tmdb_movie/ui/detail/movie_detail.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/subjects.dart';

import '../../main.dart';
import '../favorite_button.dart';

class UpcomingMoviesPage extends StatefulWidget {
  const UpcomingMoviesPage({Key? key}) : super(key: key);

  @override
  _UpcomingMoviesPageState createState() => _UpcomingMoviesPageState();
}

class _UpcomingMoviesPageState extends State<UpcomingMoviesPage> {
  final _scrollController = ScrollController();
  final _bloc = UpcomingmoviesBloc();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _bloc.add(UpcomingmoviesRefresh());
  }

  Widget _buildListOrEmpty(UpcomingmoviesState state) {
    return RefreshIndicator(child: Builder(
      builder: (context) {
        if (state.data.isEmpty)
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("No Data Available"),
                MaterialButton(
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      _bloc.add(UpcomingmoviesRefresh());
                    },
                    child: Text("Retry",
                        style: TextStyle(
                            color: Theme.of(context).backgroundColor))),
              ],
            ),
          );
        return Scrollbar(
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0),
              controller: _scrollController,
              itemCount: state.hasReachedMax
                  ? state.data.length
                  : state.data.length + 2,
              itemBuilder: (context, index) {
                if (index >= state.data.length) {
                  return BottomLoader();
                }
                final item = state.data[index];
                return UpcomingGridTile(item);
              }),
        );
      },
    ), onRefresh: () async {
      _bloc.add(UpcomingmoviesRefresh());
      return _bloc.refreshCompleter.future;
    });
  }

  void _handleError(dynamic error) {
    String errorMessage = "";
    if (error is DioError) {
      errorMessage = error.message;
    } else {
      errorMessage = error.toString();
    }
    Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upcoming Movies"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => _bloc,
          child: BlocBuilder<UpcomingmoviesBloc, UpcomingmoviesState>(
              builder: (context, state) {
            switch (state.status) {
              case UpcomingmoviesStatus.failure:
                _handleError(state.error);
                return _buildListOrEmpty(state);
              case UpcomingmoviesStatus.success:
                return _buildListOrEmpty(state);
              default:
                return const Center(child: CircularProgressIndicator());
            }
          }),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) _bloc.add(UpcomingmoviesFetchMore());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.8);
  }
}

class UpcomingGridTile extends StatefulWidget {
  final UpcomingMovie item;
  const UpcomingGridTile(this.item, {Key? key}) : super(key: key);

  @override
  _UpcomingGridTileState createState() => _UpcomingGridTileState();
}

class _UpcomingGridTileState extends State<UpcomingGridTile> {
  final favoriteSubject = BehaviorSubject<bool>();

  @override
  void initState() {
    super.initState();

    favoriteSubject.add(prefs.getBool(widget.item.id.toString()) ?? false);
  }

  @override
  void dispose() {
    favoriteSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MovieDetail(widget.item.id, widget.item.originalTitle)))
            .whenComplete(() {
          this
              .favoriteSubject
              .add(prefs.getBool(widget.item.id.toString()) ?? false);
        });
      },
      child: Column(
        children: [
          Expanded(
            child: Builder(
              builder: (context) {
                if (widget.item.posterPath != null)
                  return CachedNetworkImage(
                      width: double.infinity,
                      placeholder: (_, __) => CupertinoActivityIndicator(),
                      errorWidget: (_, __, error) => Text(error.toString()),
                      fit: BoxFit.cover,
                      fadeOutDuration: Duration.zero,
                      fadeInDuration: Duration.zero,
                      imageUrl: Constants.IMG_BASE_URL +
                          Constants.IMG_WIDTH +
                          widget.item.posterPath.toString());
                return Center(child: Text("No Image. Not Error"));
              },
            ),
          ),
          Text("Popularity : ${widget.item.popularity}"),
          Align(
            alignment: Alignment.centerRight,
            child: StreamBuilder<bool>(
                initialData: false,
                stream: favoriteSubject,
                builder: (context, snapshot) {
                  bool flag = snapshot.data!;
                  return IconButton(
                    icon: Icon(flag ? Icons.favorite : Icons.favorite_border),
                    onPressed: () {
                      prefs.setBool(widget.item.id.toString(), !flag);
                      favoriteSubject.add(!flag);
                    },
                  );
                }),
          )
        ],
      ),
    );
  }
}
