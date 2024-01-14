import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:keepaccount_app/bloc/user/user_bloc.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/model/account/model.dart';

import 'package:keepaccount_app/routes/routes.dart';
import 'package:keepaccount_app/view/account/bloc/account_bloc.dart';
import 'package:keepaccount_app/view/account/list/widget/enter.dart';
import 'package:keepaccount_app/widget/common/common.dart';

import 'package:keepaccount_app/view/account/list/bloc/account_list_bloc.dart';

class AccountList extends StatelessWidget {
  const AccountList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<AccountListBloc>(
        create: (context) => AccountListBloc(),
      ),
      BlocProvider<AccountBloc>(create: (context) => AccountBloc())
    ], child: const _AccountList());
  }
}

class _AccountList extends StatefulWidget {
  const _AccountList({Key? key}) : super(key: key);

  @override
  _AccountListState createState() => _AccountListState();
}

class _AccountListState extends State<_AccountList> {
  late int currentAccount;
  late List<AccountModel> list;
  @override
  void initState() {
    currentAccount = UserBloc.currentAccount.id;
    list = [];
    BlocProvider.of<AccountListBloc>(context).add(GetListEvent());
    super.initState();
  }

  void updateCurrentAccount() {
    if (currentAccount != UserBloc.currentAccount.id) {
      setState(() {
        currentAccount = UserBloc.currentAccount.id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return listener(Scaffold(
      appBar: AppBar(title: const Text('我的账本'), actions: [
        IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () async {
              //添加
              var result = await AccountRoutes.pushEdit(context);
              if (result == null) {
                return;
              }
              setState(() {
                list.insert(list.length, result);
              });
            })
      ]),
      body: BlocBuilder<AccountListBloc, AccountListState>(
        builder: (_, state) {
          if (state is AccountListLoaded) {
            list = state.list;
            return _listView();
          }
          return buildShimmer();
        },
      ),
    ));
  }

  void refresh() {
    BlocProvider.of<AccountListBloc>(context).add(RefreshEvent());
  }

  Widget listener(Widget widget) {
    return BlocListener<AccountBloc, AccountState>(
        listener: (_, state) {}, child: UserBloc.listenerCurrentAccountIdUpdate(() => updateCurrentAccount(), widget));
  }

  List<Widget> operationName = [
    const Text('设为当前账本', style: TextStyle(fontWeight: FontWeight.bold)),
    const Text('打开'),
    const Text('编辑'),
    const Text('删除', style: TextStyle(color: Colors.red))
  ];
  late List<Function(BuildContext context, AccountModel account)> operationFunction;
  _listView() {
    operationFunction = [
      (BuildContext context, AccountModel account) {
        //设置当前账本
        RepositoryProvider.of<UserBloc>(context).add(SetCurrentAccount(account));
        setState(() {
          currentAccount = account.id;
        });
        Navigator.pop(context);
      },
      (BuildContext context, AccountModel account) {
        //详情
        Navigator.pushReplacementNamed(context, AccountRoutes.detail, arguments: {'accountModel': account});
      },
      (BuildContext context, AccountModel account) async {
        //编辑
        var result = await AccountRoutes.pushEdit(context, account: account);
        if (result == null) {
          return;
        }
        setState(() {
          int index = list.indexWhere((element) => element.id == result.id);
          list[index] = result;
        });
      },
      (BuildContext context, AccountModel account) {
        //删除
        showDeleteConfirmationDialog(context, () => _onDelete(account));
      }
    ];
    return ListView.separated(
        itemCount: list.length,
        itemBuilder: (_, index) {
          final account = list[index];
          return ListTile(
            leading: _buildLeading(account),
            contentPadding: const EdgeInsets.only(left: 16, right: 8), // 设置左右侧填充
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
            subtitle: Text('建立时间：${DateFormat('yyyy-MM-dd HH:mm:ss').format(account.createdAt)}'),
            trailing: IconButton(
                onPressed: () async {
                  await _showCustomModalBottomSheet(list[index]);
                },
                icon: const Icon(Icons.more_vert, size: 32)),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return ConstantWidget.divider.indented;
        });
  }

  Widget _buildLeading(AccountModel account) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
      SizedBox(
        width: 4,
        child: Container(
          color: account.id == currentAccount ? Colors.blue : Colors.white,
        ),
      ),
      const SizedBox(
        width: 4,
      ),
      Icon(
        account.icon,
        size: 32,
      ),
      const SizedBox(
        width: 4,
      ),
    ]);
  }

  _showCustomModalBottomSheet(AccountModel account) async {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
          ),
          height: MediaQuery.of(context).size.height / 2.0,
          child: ListView.separated(
            itemBuilder: (_, int index) {
              return ListTile(
                  title: Center(child: operationName[index]),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                  onTap: () => operationFunction[index](context, account));
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(color: Colors.grey, height: 8);
            },
            itemCount: operationName.length,
          ),
        );
      },
    );
  }

  void showDeleteConfirmationDialog(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('确认删除？'),
          content: const Text('你确定要删除这个项目吗？'),
          actions: [
            TextButton(
                child: const Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            TextButton(
              child: const Text('确认'),
              onPressed: () {
                onConfirm();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onDelete(AccountModel account) {
    BlocProvider.of<AccountBloc>(context).add(AccountDeleteEvent(account));
    setState(() {
      list.removeWhere((element) => element.id == account.id);
      Navigator.pop(context);
    });
  }
}
