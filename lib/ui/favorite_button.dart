import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../main.dart';

class FavoriteButton extends StatefulWidget {
  final int movieId;
  const FavoriteButton(this.movieId, {Key? key}) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  final favoriteSubject = BehaviorSubject<bool>();

  @override
  void initState() {
    super.initState();

    favoriteSubject.add(prefs.getBool(widget.movieId.toString()) ?? false);
  }

  @override
  void dispose() {
    favoriteSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        initialData: false,
        stream: favoriteSubject,
        builder: (context, snapshot) {
          bool flag = snapshot.data!;
          return IconButton(
            icon: Icon(flag ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              prefs.setBool(widget.movieId.toString(), !flag);
              favoriteSubject.add(!flag);
            },
          );
        });
  }
}
