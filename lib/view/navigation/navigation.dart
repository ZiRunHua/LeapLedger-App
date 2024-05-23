import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keepaccount_app/api/model/model.dart';
import 'package:keepaccount_app/bloc/user/user_bloc.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/model/transaction/model.dart';
import 'package:keepaccount_app/routes/routes.dart';
import 'package:keepaccount_app/util/enter.dart';
import 'package:keepaccount_app/view/home/home.dart';
import 'package:keepaccount_app/view/share/home/share_home.dart';
import 'package:keepaccount_app/widget/common/common.dart';

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
  late final NavigationBloc _bloc;
  @override
  void initState() {
    UserBloc.checkUserState(context);
    _bloc = NavigationBloc(UserBloc.currentAccount);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NavigationBloc>.value(
        value: _bloc,
        child: MultiBlocListener(
          listeners: [
            BlocListener<UserBloc, UserState>(
              listenWhen: (_, state) => state is CurrentAccountChanged,
              listener: (context, state) {
                if (state is CurrentAccountChanged) {
                  _bloc.add(ChangeAccountEvent(UserBloc.currentAccount));
                }
              },
            ),
            BlocListener<NavigationBloc, NavigationState>(
              listener: (context, state) {
                if (state is NavigationAccountChannged) {
                  setState(() {});
                } else if (state is InUserHomePage) {
                  _scaffoldKey.currentState!.openEndDrawer();
                } else if (state is InFlowPage) {
                  var condition = TransactionQueryCondModel(
                      accountId: _bloc.account.id, startTime: Time.getFirstSecondOfMonth(), endTime: DateTime.now());
                  TransactionRoutes.pushFlow(context, condition: condition, account: _bloc.account);
                }
              },
            )
          ],
          child: _buildScaffold(),
        ));
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget _buildScaffold() {
    return Scaffold(
      key: _scaffoldKey,
      body: BlocBuilder<NavigationBloc, NavigationState>(
        buildWhen: (_, state) => state is! NavigationAccountChannged,
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
        onPressed: _onAdd,
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

  _onAdd() {
    if (false == TransactionRouterGuard.edit(mode: TransactionEditMode.add, account: _bloc.account)) {
      CommonToast.tipToast("当前账本为只读权限，不可新增交易");
      return;
    }

    TransactionRoutes.editNavigator(context, mode: TransactionEditMode.add, account: _bloc.account).push();
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
