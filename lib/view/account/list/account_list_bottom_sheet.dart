import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/model/account/model.dart';
import 'package:keepaccount_app/view/account/list/bloc/account_list_bloc.dart';

import 'widget/enter.dart';

class AccountListBottomSheet extends StatefulWidget {
  const AccountListBottomSheet({required this.currentAccount, super.key});
  final AccountModel currentAccount;
  @override
  State<AccountListBottomSheet> createState() => _AccountListBottomSheetState();
}

class _AccountListBottomSheetState extends State<AccountListBottomSheet> {
  late AccountModel currentAccount;

  List<AccountModel> list = [];
  @override
  void initState() {
    BlocProvider.of<AccountListBloc>(context).add(GetListEvent());
    currentAccount = widget.currentAccount;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountListBloc, AccountListState>(
      listener: (context, state) {
        if (state is AccountListLoaded) {
          setState(() {
            list = state.list;
          });
        }
      },
      child: Container(
        decoration: ConstantDecoration.bottomSheet,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(Constant.margin, Constant.margin, Constant.margin, 0),
                child: Text(
                  '选择账本',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2.0,
              child: ListView.separated(
                itemBuilder: (_, int index) {
                  var account = list[index];
                  return ListTile(
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 4,
                          height: double.infinity,
                          color: account.id == currentAccount.id ? Colors.blue : Colors.white,
                        ),
                        Icon(account.icon),
                      ],
                    ),
                    title: Row(children: [
                      Text(account.name),
                      Visibility(visible: account.type == AccountType.share, child: const ShareLabel()),
                    ]),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                    onTap: () {
                      onUpdateAccount(account);
                    },
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return ConstantWidget.divider.list;
                },
                itemCount: list.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onUpdateAccount(AccountModel account) {
    Navigator.pop<AccountModel>(context, account);
  }
}
