import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:keepaccount_app/bloc/account/account_bloc.dart';
import 'package:keepaccount_app/bloc/user/user_bloc.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/model/account/model.dart';

import 'package:keepaccount_app/routes/routes.dart';
import 'package:keepaccount_app/view/account/list/widget/enter.dart';
import 'package:keepaccount_app/widget/common/common.dart';

class AccountList extends StatefulWidget {
  const AccountList({Key? key, required this.account}) : super(key: key);
  final AccountDetailModel account;
  @override
  AccountListState createState() => AccountListState();
}

class AccountListState extends State<AccountList> {
  late int currentAccount;
  late List<AccountDetailModel> list;
  @override
  void initState() {
    currentAccount = widget.account.id;
    list = [];
    BlocProvider.of<AccountBloc>(context).add(AccountListFetchEvent());
    super.initState();
  }

  Widget listener(Widget widget) {
    return BlocListener<AccountBloc, AccountState>(
      listener: (_, state) {
        if (state is AccountListLoaded) {
          setState(() {
            list = state.list;
          });
        }
      },
      child: UserBloc.listenerCurrentAccountIdUpdate(
        () => _onUpdateCurrentAccount(),
        widget,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (list.isEmpty) {
      child = const ShimmerList();
    } else {
      child = _listView();
    }
    return listener(
      Scaffold(
        appBar: AppBar(title: const Text('我的账本'), actions: [
          IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => AccountRoutes.edit(context).push())
        ]),
        body: child,
      ),
    );
  }

  _listView() {
    return ListView.separated(
      itemCount: list.length,
      itemBuilder: (_, index) {
        final account = list[index];
        return ListTile(
          leading: _buildLeading(account),
          contentPadding: const EdgeInsets.only(left: Constant.padding, right: Constant.smallPadding),
          horizontalTitleGap: 0,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                account.name,
                style: const TextStyle(fontSize: ConstantFontSize.largeHeadline),
              ),
              Visibility(visible: account.type == AccountType.share, child: const ShareLabel()),
            ],
          ),
          subtitle: Text('建立时间：${DateFormat('yyyy-MM-dd HH:mm:ss').format(account.createTime)}'),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            Offstage(
              offstage: account.type != AccountType.share,
              child: CommonLabel(text: account.role.name),
            ),
            IconButton(
              onPressed: () async => _onClickAccount(list[index]),
              icon: const Icon(Icons.more_vert, size: 32),
            )
          ]),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return ConstantWidget.divider.indented;
      },
    );
  }

  Widget _buildLeading(AccountModel account) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
      SizedBox(
        width: 4,
        child: Container(
          color: account.id == widget.account.id ? Colors.blue : Colors.white,
        ),
      ),
      const SizedBox(width: Constant.margin),
      Icon(account.icon, size: 32),
      const SizedBox(width: Constant.margin),
    ]);
  }

  void _onClickAccount(AccountDetailModel account) async =>
      await AccountRoutes.operationList(context, account: account).showModalBottomSheet();

  void _onUpdateCurrentAccount() {
    if (currentAccount != UserBloc.currentAccount.id) {
      setState(() {
        currentAccount = UserBloc.currentAccount.id;
      });
    }
  }
}
