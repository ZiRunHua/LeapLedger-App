part of 'enter.dart';

enum PageState { loading, loaded, refreshing, moreDataFetching, noMoreData, noData }

class CommonPageController<T> extends ChangeNotifier {
  CommonPageController({this.refreshListener, this.loadMoreListener, bool Function(T)? filter}) {
    this._filter = filter;
    addListener(listener);
  }

  final Function({required int offset, required int limit})? refreshListener, loadMoreListener;
  PageState state = PageState.loaded;
  final int limit = 20;
  int get offset => _list.length;
  List<T> get list => _filter != null ? _list.where(_filter!).toList() : _list;
  bool Function(T)? _filter;

  void listener() {
    switch (state) {
      case PageState.loading:
        return;
      case PageState.loaded:
        return;
      case PageState.refreshing:
        if (refreshListener != null) {
          this.refreshListener!(offset: 0, limit: limit);
        }
        return;
      case PageState.moreDataFetching:
        if (loadMoreListener != null) {
          this.loadMoreListener!(offset: offset, limit: limit);
        }
        return;
      case PageState.noMoreData:
        return;
      case PageState.noData:
        return;
    }
  }

  loadMore() {
    if (state != PageState.loaded) {
      return;
    }
    _changeState(PageState.moreDataFetching);
  }

  refresh() {
    if (state != PageState.loaded && state != PageState.noData) {
      return;
    }
    _changeState(PageState.refreshing);
  }

  List<T> _list = [];
  setList(List<T> list) {
    _list = list;
    if (_list.isEmpty) {
      _changeState(PageState.noData);
    }
    _changeState(PageState.loaded);
  }

  addNewItemInHeader(T item) {
    list.insert(0, item);
    _changeState(PageState.loaded);
  }

  bool updateListItemWhere(bool Function(T item) find, T item) {
    var index = list.indexWhere((element) => find(element));
    if (index >= 0) {
      list[index] = item;
      _changeState(PageState.loaded);
      return true;
    }
    return false;
  }

  addListData(List<T> list) {
    if (list.isEmpty) {
      if (state == PageState.refreshing) {
        _changeState(PageState.noData);
      } else {
        _changeState(PageState.noMoreData);
      }
      return;
    }
    if (state == PageState.loading || state == PageState.refreshing) {
      _list = [];
    }
    _list.addAll(list);
    _changeState(PageState.loaded);
  }

  _changeState(PageState newState) {
    state = newState;
    notifyListeners();
  }

  @override
  void dispose() {
    _list = [];
    super.dispose();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
