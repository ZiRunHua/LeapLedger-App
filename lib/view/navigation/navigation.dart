import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keepaccount_app/api/model/model.dart';
import 'package:keepaccount_app/bloc/user/user_bloc.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/routes/routes.dart';
import 'package:keepaccount_app/util/enter.dart';
import 'package:keepaccount_app/view/home/home.dart';
import 'package:keepaccount_app/view/share/home/share_home.dart';
import 'package:keepaccount_app/widget/dialog/enter.dart';

import 'bloc/navigation_bloc.dart';

part 'widget/user_drawer.dart';
part 'widget/user_drawer_header.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  @override
  void initState() {
    UserBloc.checkUserState(context);
    super.initState();
  }

  TabPage currentPage = TabPage.home;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => NavigationBloc(),
        child: BlocListener<NavigationBloc, NavigationState>(
          child: buildScaffold(),
          listener: (context, state) {
            if (state is InUserHomePage) {
              _scaffoldKey.currentState!.openEndDrawer();
            } else if (state is InFlowPage) {
              var condition = TransactionQueryConditionApiModel(
                  accountId: UserBloc.currentAccount.id,
                  startTime: Time.getFirstSecondOfMonth(),
                  endTime: DateTime.now());
              TransactionRoutes.pushFlow(context, condition: condition, account: UserBloc.currentAccount);
            }
          },
        ));
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget buildScaffold() {
    return Scaffold(
      key: _scaffoldKey,
      body: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          if (state is InHomePage) {
            return buildPageByType(TabPage.home);
          } else if (state is InFlowPage) {
            var page = BlocProvider.of<NavigationBloc>(context).currentDisplayPage;
            return buildPageByType(page);
          } else if (state is InUserHomePage) {
            var page = BlocProvider.of<NavigationBloc>(context).currentDisplayPage;
            return buildPageByType(page);
          } else if (state is InSharePage) {
            return buildPageByType(TabPage.share);
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          TransactionRoutes.pushEdit(context, mode: TransactionEditMode.add);
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const _DemoBottomAppBar(
        fabLocation: FloatingActionButtonLocation.centerDocked,
        shape: CircularNotchedRectangle(),
      ),
      endDrawer: const UserDrawer(),
    );
  }

  Widget buildPageByType(TabPage page) {
    switch (page) {
      case TabPage.home:
        return const Home();
      case TabPage.share:
        return const Center(
          child: ShareHome(),
        );
      default:
        return Container();
    }
  }
}

class _DemoBottomAppBar extends StatelessWidget {
  const _DemoBottomAppBar({
    this.fabLocation = FloatingActionButtonLocation.endDocked,
    this.shape = const CircularNotchedRectangle(),
  });

  final FloatingActionButtonLocation fabLocation;
  final NotchedShape? shape;

  static final List<FloatingActionButtonLocation> centerLocations = <FloatingActionButtonLocation>[
    FloatingActionButtonLocation.centerDocked,
    FloatingActionButtonLocation.centerFloat,
  ];

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 64,
      padding: EdgeInsets.zero,
      shape: shape,
      color: Colors.blue,
      notchMargin: 4,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _textIcon('首页', Icons.home_filled, TabPage.home, () {
            BlocProvider.of<NavigationBloc>(context).add(NavigateToHomePage());
          }),
          _textIcon('流水', Icons.compare_arrows, TabPage.flow, () {
            BlocProvider.of<NavigationBloc>(context).add(NavigateToFlowPage());
          }),
          if (centerLocations.contains(fabLocation)) const Spacer(),
          _textIcon('共享', Icons.people, TabPage.share, () {
            BlocProvider.of<NavigationBloc>(context).add(NavigateToSharePage());
          }),
          _textIcon('我的', Icons.person, TabPage.userHome, () {
            BlocProvider.of<NavigationBloc>(context).add(NavigateToUserHomePage());
          }),
        ],
      ),
    );
  }

  Widget _textIcon(String label, IconData icon, TabPage tabPage, Function onTap) {
    return Expanded(
        child: GestureDetector(
      onTap: () => onTap(),
      child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(
          icon,
          color: Colors.white,
          size: 30,
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        )
      ]),
    ));
  }
}
