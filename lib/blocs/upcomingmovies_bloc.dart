import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tmdb_movie/constants.dart';
import 'package:flutter_tmdb_movie/data/repository.dart';
import 'package:flutter_tmdb_movie/models/upcoming_movie.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

part 'upcomingmovies_event.dart';
part 'upcomingmovies_state.dart';

class UpcomingmoviesBloc
    extends Bloc<UpcomingmoviesEvent, UpcomingmoviesState> {
  UpcomingmoviesBloc() : super(const UpcomingmoviesState());

  final _repository = GetIt.instance.get<Repository>();
  Completer<void> refreshCompleter = Completer<void>();

  @override
  Stream<Transition<UpcomingmoviesEvent, UpcomingmoviesState>> transformEvents(
    Stream<UpcomingmoviesEvent> events,
    TransitionFunction<UpcomingmoviesEvent, UpcomingmoviesState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<UpcomingmoviesState> mapEventToState(
    UpcomingmoviesEvent event,
  ) async* {
    if (event is UpcomingmoviesRefresh) {
      yield* _mapRefreshToState(state);
    }
    if (event is UpcomingmoviesFetchMore) {
      yield await _mapFetchMoreToState(state);
    }
  }

  Stream<UpcomingmoviesState> _mapRefreshToState(
      UpcomingmoviesState state) async* {
    try {
      if (state.status == UpcomingmoviesStatus.initial) {
        final cachedData = await _repository.getCachedUpcomingMovie();
        yield state.copywith(
            status: UpcomingmoviesStatus.success,
            data: cachedData,
            hasReachedMax: false);
      }
      final data = await _repository.getUpcomingMovieToPage(3);
      yield state.copywith(
          status: UpcomingmoviesStatus.success,
          data: data,
          nextPage: 4,
          hasReachedMax: false);

      refreshCompleter.complete();
      refreshCompleter = Completer<void>();
    } catch (e) {
      final cachedData = await _repository.getCachedUpcomingMovie();
      yield state.copywith(
          status: UpcomingmoviesStatus.failure,
          data: cachedData,
          hasReachedMax: true);
      refreshCompleter.completeError(e);
      refreshCompleter = Completer<void>();
    }
  }

  Future<UpcomingmoviesState> _mapFetchMoreToState(
      UpcomingmoviesState state) async {
    if (state.hasReachedMax) return state;
    UpcomingmoviesState newState = state;
    try {
      final data = await _repository.getUpcomingMovieForPage(state.nextPage);
      newState = state.copywith(
          status: UpcomingmoviesStatus.success,
          data: data,
          hasReachedMax: state.data.length == data.length,
          nextPage: state.nextPage + 1);
    } catch (e) {
      newState = state.copywith(
        status: UpcomingmoviesStatus.failure,
        error: e,
      );
    }
    return newState;
  }
}
