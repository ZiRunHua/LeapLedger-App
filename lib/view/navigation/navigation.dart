import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leap_ledger_app/api/model/model.dart';
import 'package:leap_ledger_app/bloc/user/user_bloc.dart';
import 'package:leap_ledger_app/common/global.dart';
import 'package:leap_ledger_app/model/transaction/model.dart';
import 'package:leap_ledger_app/model/user/model.dart';
import 'package:leap_ledger_app/routes/routes.dart';
import 'package:leap_ledger_app/util/enter.dart';
import 'package:leap_ledger_app/view/home/home.dart';
import 'package:leap_ledger_app/view/share/home/share_home.dart';
import 'package:leap_ledger_app/widget/common/common.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _bloc = NavigationBloc(account: UserBloc.currentAccount);
    _pages = [Home(), ShareHome()];
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
                    accountId: _bloc.account.id,
                    startTime: Tz.getFirstSecondOfMonth(date: _bloc.nowTime),
                    endTime: _bloc.nowTime,
                  );
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
          var index = 0;
          switch (_bloc.currentDisplayPage) {
            case TabPage.home:
              index = 0;
              break;
            case TabPage.share:
              index = 1;
              break;
            default:
              index = 0;
          }
          return IndexedStack(index: index, children: _pages);
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: _onAdd, child: Icon(Icons.add, size: Constant.iconSize)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const _BottomNavigationBar(),
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
}

class _BottomNavigationBar extends StatefulWidget {
  const _BottomNavigationBar();

  @override
  State<_BottomNavigationBar> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<_BottomNavigationBar> {
  late NavigationBloc _bloc;
  TabPage get _currentTab => _bloc.currentDisplayPage;
  @override
  void initState() {
    _bloc = BlocProvider.of<NavigationBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color iconColor = Colors.grey.shade800;
    return BottomAppBar(
      surfaceTintColor: Colors.white,
      color: Colors.white,
      shadowColor: Colors.grey,
      height: 52.sp,
      padding: EdgeInsets.zero,
      shape: CircularNotchedRectangle(),
      elevation: Constant.margin,
      notchMargin: Constant.margin,
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          var children = [
            _navigationbutton('首页',
                unSelect: Icon(Icons.home_outlined, color: iconColor),
                select: Icon(Icons.home, color: iconColor),
                tabPage: TabPage.home,
                onTap: () => _bloc.add(NavigateToHomePage())),
            _navigationbutton('流水',
                unSelect: Icon(Icons.compare_arrows_rounded, color: iconColor),
                select: Icon(Icons.compare_arrows_rounded, color: iconColor),
                tabPage: TabPage.flow,
                onTap: () => _bloc.add(NavigateToFlowPage())),
            const Spacer(),
            _navigationbutton('共享',
                unSelect: Icon(Icons.people_outline, color: iconColor),
                select: Icon(Icons.people, color: iconColor),
                tabPage: TabPage.share,
                onTap: () => _bloc.add(NavigateToSharePage())),
            _navigationbutton('我的',
                unSelect: Icon(Icons.person_outline, color: iconColor),
                select: Icon(Icons.person, color: iconColor),
                tabPage: TabPage.userHome,
                onTap: () => _bloc.add(NavigateToUserHomePage())),
          ];
          return DefaultTextStyle(
            style: TextStyle(color: Colors.black54, fontSize: ConstantFontSize.body),
            child: Row(children: children),
          );
        },
      ),
    );
  }

  Widget _navigationbutton(
    String label, {
    required Widget unSelect,
    required Widget select,
    required TabPage tabPage,
    required Function onTap,
  }) {
    return Expanded(
        child: GestureDetector(
      onTap: () => onTap(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [_currentTab == tabPage ? select : unSelect, Text(label)],
      ),
    ));
  }
}
