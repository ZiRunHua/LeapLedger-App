part of 'enter.dart';

class CommonPageList<T> extends StatefulWidget {
  const CommonPageList({
    super.key,
    required this.buildListOne,
    this.prototypeData,
    this.initRefresh = true,
    required this.controller,
  });
  final Widget Function(T) buildListOne;
  final T? prototypeData;
  final bool initRefresh;
  final CommonPageController<T> controller;
  @override
  State<CommonPageList<T>> createState() => _CommonPageListState<T>();
}

class _CommonPageListState<T> extends State<CommonPageList<T>> with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final GlobalKey<_RefreshAnimationState> _refreshAnimationKey;

  List<T> get list => widget.controller.list;
  PageState get state => widget.controller.state;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent - _scrollController.position.pixels < 100) {
        widget.controller.loadMore();
      }
    });
    _refreshAnimationKey = GlobalKey<_RefreshAnimationState>();
    widget.controller.addListener(() {
      if (widget.controller.state == PageState.loaded) {
        if (_refreshAnimationKey.currentState != null) {
          _refreshAnimationKey.currentState!.hide();
        }
      }
      setState(() {});
    });
    if (widget.initRefresh) {
      widget.controller.refresh();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool scrollToTop = false;
  bool get canScroll => _scrollController.position.maxScrollExtent > _scrollController.position.viewportDimension;
  double lastDy = 0;
  @override
  Widget build(BuildContext context) {
    return Listener(
        onPointerMove: (details) {
          if (scrollToTop || false == canScroll) {
            if (_refreshAnimationKey.currentState == null) {
              return;
            }
            _refreshAnimationKey.currentState!.addHeight(details.position.dy - lastDy);
            if (_refreshAnimationKey.currentState!.fullDisplay) {
              widget.controller.refresh();
            }
          }
          lastDy = details.position.dy;
        },
        onPointerCancel: (details) {},
        onPointerDown: (details) {
          lastDy = details.position.dy;
        },
        onPointerUp: (details) {
          scrollToTop = false;
          if (_refreshAnimationKey.currentState == null) {
            return;
          }
          _refreshAnimationKey.currentState!.hide();
        },
        child: NotificationListener(
          onNotification: (ScrollNotification notification) {
            if (notification is OverscrollNotification && notification.overscroll < 0) {
              scrollToTop = true;
            } else if (notification is ScrollUpdateNotification) {
              scrollToTop = false;
            } else {}
            return false;
          },
          child: CustomScrollView(controller: _scrollController, slivers: _buildSlevers()),
        ));
  }

  List<Widget> _buildSlevers() {
    switch (state) {
      case PageState.loading:
        return [_buildLoading(), _buildSliverList()];
      case PageState.loaded:
        return [_buildLoading(), _buildSliverList()];

      case PageState.refreshing:
        return [_buildLoading(), _buildSliverList()];

      case PageState.moreDataFetching:
        return [_buildSliverList()];
      case PageState.noData:
        return [_buildNoData()];
      default:
        return [_buildSliverList()];
    }
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
    return SliverToBoxAdapter(
      child: SizedBox(height: 64.sp, child: Center(child: NoData.commonWidget)),
    );
  }

  Widget _buildLoading() {
    return SliverToBoxAdapter(
      child: RefreshAnimation(key: _refreshAnimationKey, height: 78.sp),
    );
  }
}

class TestCommonPage extends StatefulWidget {
  const TestCommonPage({super.key});

  @override
  State<TestCommonPage> createState() => _TestCommonPageState();
}

class _TestCommonPageState extends State<TestCommonPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
