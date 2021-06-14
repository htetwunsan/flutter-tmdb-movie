part of 'upcomingmovies_bloc.dart';

abstract class UpcomingmoviesEvent extends Equatable {
  const UpcomingmoviesEvent();

  @override
  List<Object> get props => [];
}

class UpcomingmoviesRefresh extends UpcomingmoviesEvent {}

class UpcomingmoviesFetchMore extends UpcomingmoviesEvent {}
