part of 'upcomingmovies_bloc.dart';

enum UpcomingmoviesStatus { initial, failure, success }

class UpcomingmoviesState extends Equatable {
  final UpcomingmoviesStatus status;
  final List<UpcomingMovie> data;
  final dynamic error;
  final bool hasReachedMax;
  final int nextPage;

  const UpcomingmoviesState(
      {this.status = UpcomingmoviesStatus.initial,
      this.data = const <UpcomingMovie>[],
      this.error = "",
      this.hasReachedMax = false,
      this.nextPage = Constants.TMDB_START_INDEX});

  UpcomingmoviesState copywith(
      {UpcomingmoviesStatus? status,
      List<UpcomingMovie>? data,
      dynamic error,
      bool? hasReachedMax,
      int? nextPage}) {
    return UpcomingmoviesState(
        status: status ?? this.status,
        data: data ?? this.data,
        error: error ?? this.error,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        nextPage: nextPage ?? this.nextPage);
  }

  @override
  List<Object> get props => [status, data, hasReachedMax, nextPage];

  @override
  String toString() {
    return '''UpcomingmoviesState { status: $status, hasReachedMax: $hasReachedMax, movies: ${data.length} }''';
  }
}
