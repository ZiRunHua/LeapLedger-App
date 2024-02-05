part of 'common.dart';

class CommonRefreshAndLoadMoreWidget<T> extends StatefulWidget {
  const CommonRefreshAndLoadMoreWidget({
    super.key,
    required this.buildListOne,
    this.prototypeData,
    this.initRefresh = true,
  });
  final Widget Function(T) buildListOne;
  final T? prototypeData;
  final bool initRefresh;
  @override
  State<CommonRefreshAndLoadMoreWidget<T>> createState() => _CommonRefreshAndLoadMoreWidgetState<T>();
}

class _CommonRefreshAndLoadMoreWidgetState<T> extends State<CommonRefreshAndLoadMoreWidget<T>> {
  late final ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        BlocProvider.of<RefreshAndLoadMoreBloc<T>>(context).add(PageMoreDataFetch());
      }
    });
    if (mounted && widget.initRefresh) {
      BlocProvider.of<RefreshAndLoadMoreBloc<T>>(context).add(PageRefresh());
    }
  }

  var indicator = GlobalKey<RefreshIndicatorState>();
  List<T> list = [];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RefreshAndLoadMoreBloc<T>, RefreshAndLoadMoreState>(buildWhen: (_, state) {
      if (state is PageLoaded || state is PageLoading || state is PageNoData) {
        return true;
      }
      return false;
    }, builder: (context, state) {
      if (state is PageNoData) {
        return _buildNoData();
      }
      List<Widget> slivers = [];
      if (state is PageLoading || state is PageRefreshing) {
        slivers.add(_buildLoading());
      }
      slivers.add(_buildSliverList());
      if (state is PageLoadingMore) {
        slivers.add(_buildLoading());
      }

      return CustomScrollView(controller: _scrollController, slivers: slivers);
    }, listenWhen: (_, state) {
      print(state);
      return true;
    }, listener: (context, state) {
      if (state is PageLoading || state is PageRefreshing) {
        if (indicator.currentState != null) {
          indicator.currentState!.show();
        }
      } else if (state is PageLoaded<T>) {
        list = state.data;
      }
    });
  }

  Widget _buildSliverList() {
    if (widget.prototypeData != null) {
      return SliverPrototypeExtentList(
        prototypeItem: widget.buildListOne(widget.prototypeData as T),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return widget.buildListOne(list[index]);
          },
          childCount: list.length,
        ),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return widget.buildListOne(list[index]);
        },
        childCount: list.length,
      ),
    );
  }

  Widget _buildNoData() {
    return const SliverToBoxAdapter(
      child: SizedBox(height: 64, child: Center(child: Text("无数据"))),
    );
  }

  Widget _buildLoading() {
    return const SliverToBoxAdapter(
      child: SizedBox(height: 64, child: Center(child: CircularProgressIndicator())),
    );
  }
}
