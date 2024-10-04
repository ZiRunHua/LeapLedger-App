part of 'enter.dart';

class RefreshAnimation extends StatefulWidget {
  const RefreshAnimation({super.key, this.height = 78});
  final double height;
  @override
  State<RefreshAnimation> createState() => _RefreshAnimationState();
}

class _RefreshAnimationState extends State<RefreshAnimation> with SingleTickerProviderStateMixin {
  double _height = 0;
  double get _loadPositioned => _height / 2 - 18;
  bool get fullDisplay => _height == widget.height && !doAnimation;
  bool doAnimation = false;
  late final AnimationController _controller;
  late final CurvedAnimation curvedAnimation;
  late Animation<double> _heightAnimation;
  late Animation<double> _positionAnimation;
  final Duration animationDuration = const Duration(milliseconds: 500);
  @override
  void initState() {
    _controller = AnimationController(
      duration: animationDuration,
      vsync: this,
    );
    curvedAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _heightAnimation = Tween<double>(
      begin: widget.height.sp,
      end: 0,
    ).animate(curvedAnimation);
    _positionAnimation = Tween<double>(
      begin: (widget.height.sp - 36) / 2,
      end: 0,
    ).animate(curvedAnimation);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        doAnimation = false;
        _height = 0;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        AnimatedBuilder(
          animation: _heightAnimation,
          builder: (context, child) {
            return Container(
              decoration: const BoxDecoration(color: ConstantColor.greyBackground),
              height: doAnimation ? _heightAnimation.value : _height,
            );
          },
        ),
        AnimatedBuilder(
            animation: _positionAnimation,
            builder: (context, child) {
              return Positioned(
                top: doAnimation ? _positionAnimation.value : _loadPositioned,
                child: CircularProgressIndicator(
                  value: widget.height == _height || doAnimation ? null : _height / widget.height,
                ),
              );
            })
      ],
    );
  }

  void addHeight(double heiget) {
    if (heiget == widget.height || heiget < 0) {
      return;
    }

    if (heiget + _height >= widget.height) {
      _height = widget.height;
    } else {
      _height += heiget;
    }
    setState(() {});
  }

  void hide() {
    if (_height == 0 || doAnimation) {
      return;
    }
    doAnimation = true;
    _controller.reset();
    _controller.forward();
  }
}

class TestRefreshAnimation extends StatefulWidget {
  const TestRefreshAnimation({this.pageController, super.key});
  final CommonPageController? pageController;
  @override
  State<TestRefreshAnimation> createState() => _TestRefreshAnimationState();
}

class _TestRefreshAnimationState extends State<TestRefreshAnimation> {
  bool display = false;
  double _dragOffset = 0;
  GlobalKey<_RefreshAnimationState> refreshAnimation = GlobalKey<_RefreshAnimationState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta == null) {
          return;
        }
        _dragOffset += details.primaryDelta!;
        if (refreshAnimation.currentState == null) {
          return;
        }
        refreshAnimation.currentState!.addHeight(_dragOffset);
      },
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            RefreshAnimation(
              key: refreshAnimation,
            ),
            SizedBox(height: 100.sp),
            TextButton(
                onPressed: () {
                  setState(() {
                    display = !display;
                  });
                },
                child: const Text("test")),
          ],
        ),
      ),
    );
  }
}
