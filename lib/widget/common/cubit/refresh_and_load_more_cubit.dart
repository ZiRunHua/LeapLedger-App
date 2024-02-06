import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'refresh_and_load_more_state.dart';

enum PageStatus { loading, loaded, refreshing, moreDataFetching, noMoreData, noData }

class RefreshAndLoadMoreCubit<T> extends Cubit<RefreshAndLoadMoreState> {
  RefreshAndLoadMoreCubit(this.callbackFetchData) : super(RefreshAndLoadMoreInitial());
  final void Function(int offset, int limit) callbackFetchData;
  final int limit = 20;
  int offset = 0;
  PageStatus currentStatus = PageStatus.loaded;
  void refresh() {
    if (currentStatus == PageStatus.loading) {
      return;
    }
    currentStatus = PageStatus.loading;
    emit(PageLoading());
    offset = 0;
    callbackFetchData(offset, limit);
  }

  void fetchMoreData() {
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
  void finishDataFetch(List<T> data) {
    if (data.isEmpty) {
      list = [];
      if (currentStatus == PageStatus.moreDataFetching) {
        currentStatus = PageStatus.noMoreData;
      } else {
        currentStatus = PageStatus.noData;
      }
      return;
    }
    if (currentStatus != PageStatus.moreDataFetching) {
      list = [];
    }
    list.addAll(data);
    currentStatus = PageStatus.loaded;
    emit(PageLoaded<T>(list));
  }

  void updateData(List<T> data) {
    if (data.isEmpty) {
      currentStatus = PageStatus.noData;
      return;
    }
    currentStatus = PageStatus.loaded;
    emit(PageLoaded<T>(data));
  }
}
