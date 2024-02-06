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
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {}
    });
    if (mounted && widget.initRefresh) {
      context.read<RefreshAndLoadMoreCubit<T>>().fetchMoreData();
    }
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000), // 调整动画时长
    );

    _loadingAnimation = Tween<double>(begin: 0, end: 1).animate(_loadingController);
  }

  var indicator = GlobalKey<RefreshIndicatorState>();
  List<T> list = [];
  bool inRefresh = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RefreshAndLoadMoreCubit<T>, RefreshAndLoadMoreState>(buildWhen: (_, state) {
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

      return RefreshIndicator(
          child: CustomScrollView(controller: _scrollController, slivers: slivers),
          onRefresh: () async {
            context.read<RefreshAndLoadMoreCubit<T>>().refresh();
          });
    }, listenWhen: (_, state) {
      print(state);
      return true;
    }, listener: (context, state) {
      if (state is PageLoading) {
        inRefresh = true;
      } else {
        inRefresh = false;
      }
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
    _loadingController.forward();
    return SliverToBoxAdapter(
        child: AnimatedBuilder(
      animation: _loadingController,
      builder: (BuildContext context, Widget? child) {
        return SlideTransition(
            position: Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(_loadingController),
            child: Container(
                color: ConstantColor.secondaryColor,
                height: 64,
                child: const Center(child: CircularProgressIndicator())));
      },
    ));
  }
}

class RefreshAnimation extends AnimatedWidget {
  const RefreshAnimation({Key? key, required this.progress}) : super(key: key, listenable: progress);
  final Animation<double> progress;
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: Duration(seconds: 1),
      tween: Tween(begin: 0, end: 50),
      builder: (BuildContext context, int value, Widget? child) {
        return Container(
            color: ConstantColor.secondaryColor, height: 64, child: const Center(child: CircularProgressIndicator()));
      },
    );
  }
}

class TestRefreshAnimation extends StatefulWidget {
  const TestRefreshAnimation({super.key});

  @override
  State<TestRefreshAnimation> createState() => _TestRefreshAnimationState();
}

class _TestRefreshAnimationState extends State<TestRefreshAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _loadingController;
  void initState() {
    super.initState();

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // 调整动画时长
    );
    _loadingController.forward();
  }

  bool display = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          AnimatedBuilder(
            animation: _loadingController,
            builder: (BuildContext context, Widget? child) {
              return SlideTransition(
                  position: Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(_loadingController),
                  child: Container(
                      color: ConstantColor.secondaryColor,
                      height: 64,
                      child: const Center(child: CircularProgressIndicator())));
            },
          ),
          const SizedBox(
            height: 100,
          ),
          TextButton(
              onPressed: () {
                setState(() {
                  display = !display;
                  _loadingController.forward();
                });
              },
              child: const Text("test")),
        ],
      ),
    );
  }
}
