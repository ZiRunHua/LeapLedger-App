import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leap_ledger_app/bloc/transaction/transaction_bloc.dart';
import 'package:leap_ledger_app/bloc/user/user_bloc.dart';
import 'package:leap_ledger_app/common/global.dart';
import 'package:leap_ledger_app/model/account/model.dart';
import 'package:leap_ledger_app/model/common/model.dart';
import 'package:leap_ledger_app/routes/routes.dart';
import 'package:leap_ledger_app/view/share/home/bloc/share_home_bloc.dart';
import 'package:leap_ledger_app/widget/common/common.dart';

import 'widget/enter.dart';

class ShareHome extends StatefulWidget {
  const ShareHome({super.key});

  @override
  State<ShareHome> createState() => _ShareHomeState();
}

class _ShareHomeState extends State<ShareHome> {
  late final ShareHomeBloc _bloc;
  @override
  void initState() {
    _bloc = ShareHomeBloc(transactionBloc: BlocProvider.of<TransactionBloc>(context));
    // 当前账本为共享则加载当前
    if (UserBloc.currentAccount.isValid && UserBloc.currentAccount.type == AccountType.share) {
      _bloc.add(LoadShareHomeEvent(account: UserBloc.currentAccount));
    } else if (UserBloc.currentShareAccount.isValid) {
      _bloc.add(LoadShareHomeEvent(account: UserBloc.currentShareAccount));
    } else {
      // 否则交给bloc处理
      _bloc.add(LoadShareHomeEvent(account: UserBloc.currentAccount));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: _bloc,
        child: BlocListener<UserBloc, UserState>(
          listenWhen: (context, state) {
            return state is CurrentShareAccountChanged || state is CurrentAccountChanged;
          },
          listener: (context, state) {
            if (UserBloc.currentShareAccount.isValid) {
              _bloc.add(ChangeAccountEvent(UserBloc.currentShareAccount));
            } else if (UserBloc.currentAccount.isValid && UserBloc.currentAccount.type == AccountType.share) {
              _bloc.add(ChangeAccountEvent(UserBloc.currentAccount));
            } else {
              // 否则只能传递无效的共享账本 交给bloc处理
              _bloc.add(ChangeAccountEvent(UserBloc.currentShareAccount));
            }
          },
          child: BlocBuilder<ShareHomeBloc, ShareHomeState>(
            buildWhen: (previous, current) => current is ShareHomePageState,
            builder: (context, state) {
              if (state is ShareHomeInitial) {
                return const Center(child: ConstantWidget.activityIndicator);
              }
              if (state is NoShareAccount) {
                return const NoAccountPage();
              }
              return Scaffold(
                appBar: AppBar(
                  title: const AccountMenu(),
                  centerTitle: true,
                ),
                backgroundColor: ConstantColor.greyBackground,
                body: RefreshIndicator(
                  onRefresh: () async => _bloc.add(LoadShareHomeEvent()),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Constant.margin),
                    child: _buildContent(),
                  ),
                ),
              );
            },
          ),
        ));
  }

  Widget _buildContent() {
    return CustomScrollView(
      slivers: [
        SliverPadding(padding: const EdgeInsets.only(top: Constant.margin)),
        SliverToBoxAdapter(
          child: BlocBuilder<ShareHomeBloc, ShareHomeState>(
              buildWhen: (previous, current) => current is AccountTotalLoaded,
              builder: ((context, state) {
                if (state is AccountTotalLoaded) {
                  return AccountTotal(todayTransTotal: state.todayTransTotal, monthTransTotal: state.monthTransTotal);
                } else {
                  return AccountTotal(todayTransTotal: InExStatisticModel(), monthTransTotal: InExStatisticModel());
                }
              })),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(Constant.margin),
          sliver: SliverToBoxAdapter(
              child: SizedBox(
            height: 48,
            width: MediaQuery.of(context).size.width,
            child: _buildOperationalNavigation(),
          )),
        ),
        SliverToBoxAdapter(child: const AccountUserCard()),
        SliverToBoxAdapter(child: const AccountTransList())
      ],
    );
  }

  _buildOperationalNavigation() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        BlocBuilder<ShareHomeBloc, ShareHomeState>(
          buildWhen: (_, state) => state is AccountMappingLoad,
          builder: (context, state) {
            if (state is AccountMappingLoad && state.mapping != null) {
              // 存在关联账本
              return _buildNavigationCard(
                  text: state.mapping!.relatedAccount.name,
                  icon: state.mapping!.relatedAccount.icon,
                  onTap: _clickMapping);
            }
            if (ShareHomeBloc.account != null && ShareHomeBloc.account!.isReader) {
              // 只读权限
              return _buildNavigationCard(
                  text: ShareHomeBloc.account!.name, icon: Icons.receipt_long_outlined, onTap: _clickMapping);
            }
            // 未设置关联账本或正在加载中
            return _buildNavigationCard(text: "关联账本", icon: Icons.receipt_long_outlined, onTap: _clickMapping);
          },
        ),
        _buildNavigationCard(
          text: "交易类型",
          icon: Icons.settings_outlined,
          onTap: () {
            if (ShareHomeBloc.account != null) {
              TransactionCategoryRoutes.settingNavigator(context,
                      account: ShareHomeBloc.account!, relatedAccount: _bloc.accountMapping?.relatedAccount)
                  .pushTree();
            }
          },
        ),
        _buildNavigationCard(
          text: "图表分析",
          icon: Icons.pie_chart_outline_outlined,
          onTap: () => TransactionRoutes.chartNavigator(context, account: ShareHomeBloc.account!).push(),
        ),
        _buildNavigationCard(
            text: "查看邀请",
            icon: Icons.send_outlined,
            onTap: () async {
              await AccountRoutes.pushAccountUserInvitation(context, account: ShareHomeBloc.account!);
            })
      ],
    );
  }

  _clickMapping() async {
    if (ShareHomeBloc.account != null &&
        AccountRouterGuard.mapping(mainAccount: ShareHomeBloc.account!, mapping: _bloc.accountMapping)) {
      AccountRoutes.mapping(
        context,
        mainAccount: ShareHomeBloc.account!,
        mapping: _bloc.accountMapping,
        onMappingChange: (mapping) => _bloc.add(SetAccountMappingEvent(mapping)),
      ).showModalBottomSheet();
    } else {
      CommonToast.tipToast("只读，不可关联账本");
    }
  }

  Widget navigatorButton(String text, {String? subTitle, IconData? icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: const EdgeInsets.only(left: Constant.margin / 2, right: Constant.margin / 2),
          padding: const EdgeInsets.symmetric(horizontal: Constant.padding),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(90)),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: ConstantColor.primaryColor,
                size: 24,
              ),
              const SizedBox(
                width: Constant.margin / 2,
              ),
              Text(text),
            ],
          )),
    );
  }

  _buildNavigationCard({required String text, required IconData icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: const EdgeInsets.only(left: Constant.margin / 2, right: Constant.margin / 2),
          padding: const EdgeInsets.symmetric(horizontal: Constant.padding),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(90)),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: ConstantColor.primaryColor,
                size: 24,
              ),
              const SizedBox(
                width: Constant.margin / 2,
              ),
              Text(text),
            ],
          )),
    );
  }
}
