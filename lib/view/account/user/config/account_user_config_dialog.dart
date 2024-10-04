import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leap_ledger_app/bloc/user/user_bloc.dart';
import 'package:leap_ledger_app/common/global.dart';
import 'package:leap_ledger_app/model/account/model.dart';
import 'package:leap_ledger_app/view/account/user/config/cubit/account_user_config_cubit.dart';

class AccountUserConfigDialog extends StatefulWidget {
  final AccountDetailModel account;
  const AccountUserConfigDialog({Key? key, required this.account}) : super(key: key);

  @override
  AccountUserConfigDialogState createState() => AccountUserConfigDialogState();
}

class AccountUserConfigDialogState extends State<AccountUserConfigDialog> {
  late final AccountUserConfigCubit _cubit;
  @override
  void initState() {
    _cubit = AccountUserConfigCubit(account: widget.account)..fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountUserConfigCubit>.value(
      value: _cubit,
      child: BlocBuilder<AccountUserConfigCubit, AccountUserConfigState>(builder: (context, state) {
        if (state is AccountUserConfigLoaded) {
          return AlertDialog(
              contentPadding: EdgeInsets.all(Constant.margin),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [..._buildFlags()],
              ));
        } else {
          return const Center(child: ConstantWidget.activityIndicator);
        }
      }),
    );
  }

  List<Widget> _buildFlags() {
    if (_cubit.config == null) {
      return [];
    }
    List<Widget> list = [];
    _cubit.config!.getFlagList().forEach(
          (element) => list.add(_buildFlag(title: element.name, flagName: element.flagName, value: element.status)),
        );
    return list;
  }

  Widget _buildFlag({required String title, required String flagName, required bool value, IconData? iconData}) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: Constant.margin),
      value: value,
      title: Text(title),
      onChanged: (bool? value) {
        if (value == null) {
          return;
        }
        _cubit.updateFlag(flagName: flagName, status: value);
      },
      secondary: iconData != null ? Icon(iconData) : null,
    );
  }
}

class TestAccountConfigDialog extends StatelessWidget {
  const TestAccountConfigDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AccountUserConfigDialog(
      account: UserBloc.currentAccount,
    );
  }
}
