part of 'refresh_and_load_more_bloc.dart';

@immutable
sealed class RefreshAndLoadMoreState {}

final class RefreshAndLoadMoreInitial extends RefreshAndLoadMoreState {}

class PageLoading extends RefreshAndLoadMoreState {}

class PageLoaded<T> extends RefreshAndLoadMoreState {
  final List<T> data;
  PageLoaded(this.data);
}

class PageRefreshing extends RefreshAndLoadMoreState {}

class PageLoadingMore extends RefreshAndLoadMoreState {}

class PageNoData extends RefreshAndLoadMoreState {}
