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

class _CommonRefreshAndLoadMoreWidgetState<T> extends State<CommonRefreshAndLoadMoreWidget<T>>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _loadingController;
  late final Animation<double> _loadingAnimation;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        print("object");
        BlocProvider.of<RefreshAndLoadMoreBloc<T>>(context).add(PageMoreDataFetch());
      }
    });
    if (mounted && widget.initRefresh) {
      BlocProvider.of<RefreshAndLoadMoreBloc<T>>(context).add(PageRefresh());
    }
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000), // 调整动画时长
    );

    _loadingAnimation = Tween<double>(begin: 0, end: 1).animate(_loadingController);
  }

  var indicator = GlobalKey<RefreshIndicatorState>();
  List<T> list = [];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RefreshAndLoadMoreBloc<T>, RefreshAndLoadMoreState>(buildWhen: (_, state) {
      if (state is PageLoaded<T> || state is PageLoading || state is PageNoData || state is PageLoadingMore) {
        return true;
      }
      return false;
    }, builder: (context, state) {
      // 无数据
      if (state is PageNoData) {
        return _buildNoData();
      }
      List<Widget> slivers = [];
      // 加载或刷新中
      if (state is PageLoading || state is PageRefreshing) {
        slivers.add(_buildLoading());
      }
      // 加载完成
      if (state is PageLoaded<T>) {
        list = state.data;
      }
      slivers.add(_buildSliverList());
      // 加载更多中
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
    return SliverToBoxAdapter(
        child: AnimatedBuilder(
      animation: _loadingAnimation,
      builder: (context, child) {
        return Transform.translate(
            offset: Offset(0, _loadingAnimation.value * 50),
            child: SizedBox(height: 64, child: const Center(child: CircularProgressIndicator())));
      },
    ));
  }
}

class RefreshAnimation extends RenderSliverToBoxAdapter {
  const RefreshAnimation({super.key});

  @override
  State<RefreshAnimation> createState() => _RefreshAnimationState();
}

class _RefreshAnimationState extends State<RefreshAnimation> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
