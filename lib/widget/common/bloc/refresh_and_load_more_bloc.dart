import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'refresh_and_load_more_event.dart';
part 'refresh_and_load_more_state.dart';

enum PageStatus { loading, loaded, refreshing, moreDataFetching, noMoreData, noData }

class RefreshAndLoadMoreBloc<T> extends Bloc<RefreshAndLoadMoreEvent, RefreshAndLoadMoreState> {
  final void Function(int offset, int limit) callbackFetchData;
  RefreshAndLoadMoreBloc({required this.callbackFetchData}) : super(RefreshAndLoadMoreInitial()) {
    on<PageRefresh>(_handleRefresh);
    on<PageMoreDataFetch>(_fetchMoreData);
    on<PageDataFetchFinish<T>>(_finishDataFetch);
    on<PageDataUpdate<T>>(_updateData);
  }

  final int limit = 20;
  int offset = 0;
  PageStatus currentStatus = PageStatus.loaded;
  _handleRefresh(PageRefresh event, emit) {
    if (currentStatus == PageStatus.loading) {
      return;
    }
    currentStatus = PageStatus.loading;
    emit(PageLoading());
    offset = 0;
    callbackFetchData(offset, limit);
  }

  _fetchMoreData(PageMoreDataFetch event, emit) {
    print(currentStatus);
    if (currentStatus != PageStatus.loaded) {
      return;
    }
    currentStatus = PageStatus.moreDataFetching;
    emit(PageLoadingMore());
    offset += limit;
    callbackFetchData(offset, limit);
  }

  List<T> list = [];
  _finishDataFetch(PageDataFetchFinish<T> event, emit) {
    if (event.data.isEmpty) {
      list = [];
      if (currentStatus == PageStatus.moreDataFetching) {
        //currentStatus = PageStatus.noMoreData;
      } else {
        //currentStatus = PageStatus.noData;
      }
      return;
    }
    if (currentStatus != PageStatus.moreDataFetching) {
      list = [];
    }
    list.addAll(event.data);
    currentStatus = PageStatus.loaded;
    emit(PageLoaded<T>(event.data));
  }

  _updateData(PageDataUpdate<T> event, emit) {
    if (event.data.isEmpty) {
      currentStatus = PageStatus.noData;
      return;
    }
    currentStatus = PageStatus.loaded;
    emit(PageLoaded<T>(event.data));
  }
}
