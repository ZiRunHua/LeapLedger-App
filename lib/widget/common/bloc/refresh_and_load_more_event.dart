part of 'refresh_and_load_more_bloc.dart';

@immutable
sealed class RefreshAndLoadMoreEvent {}

class PageRefresh extends RefreshAndLoadMoreEvent {}

class PageMoreDataFetch extends RefreshAndLoadMoreEvent {}

class PageDataUpdate<T> extends RefreshAndLoadMoreEvent {
  final List<T> data;
  PageDataUpdate(this.data);
}

class PageDataFetchFinish<T> extends RefreshAndLoadMoreEvent {
  final List<T> data;
  PageDataFetchFinish(this.data);
}
