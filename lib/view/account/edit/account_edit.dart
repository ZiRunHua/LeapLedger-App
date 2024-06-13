import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keepaccount_app/bloc/account/account_bloc.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/model/account/model.dart';
import 'package:keepaccount_app/routes/routes.dart';
import 'package:keepaccount_app/widget/common/common.dart';
import 'package:keepaccount_app/widget/form/form.dart';
import 'package:keepaccount_app/widget/icon/enter.dart';

enum AccountEditMode {
  add,
  update,
}

class AccountEdit extends StatefulWidget {
  const AccountEdit({super.key, this.account});
  final AccountDetailModel? account;
  @override
  AccountEditState createState() => AccountEditState();
}

class AccountEditState extends State<AccountEdit> {
  final _formKey = GlobalKey<FormState>();
  late AccountModel account;
  late final AccountEditMode mode;
  void initData() {
    if (widget.account != null && widget.account!.isValid) {
      mode = AccountEditMode.update;
    } else {
      mode = AccountEditMode.add;
    }
    if (widget.account == null) {
      account = AccountDetailModel.fromJson({});
    } else {
      account = widget.account!.copy();
    }
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  void didUpdateWidget(AccountEdit oldWidget) {
    if (widget.account != oldWidget.account) {
      initData();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountBloc, AccountState>(
        listener: (context, state) async {
          if (state is AccountSaveSuccess) {
            if (mode == AccountEditMode.add) {
              await Navigator.push(context, TransactionCategoryRoutes.getTemplateRoute(context, account: state.account))
                  .then((value) => Navigator.pop<AccountDetailModel>(context, state.account));
            } else {
              Navigator.pop<AccountDetailModel>(context, state.account);
            }
          }
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(mode == AccountEditMode.add ? "添加账本" : "编辑账本"),
              actions: <Widget>[
                IconButton(icon: const Icon(Icons.save, size: 24), onPressed: _onSave),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(Constant.padding),
              child: buildForm(),
            )));
  }

  Widget buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildRadio(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Constant.padding),
            child: CircularIcon(icon: account.icon),
          ),
          FormInputField.string('名称', account.name, (text) => account.name = text),
          const SizedBox(
            height: 16,
          ),
          FormSelecter.accountIcon(account.icon, onChanged: _onSelectIcon),
        ],
      ),
    );
  }

  Widget _buildRadio() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "类型：",
            style: TextStyle(color: ConstantColor.secondaryTextColor, fontSize: ConstantFontSize.body),
          ),
          SizedBox(
            width: 100,
            child: RadioListTile<AccountType>(
              contentPadding: EdgeInsets.zero,
              title: const Text("独立"),
              value: AccountType.independent,
              groupValue: account.type,
              onChanged: _onClickRadio,
            ),
          ),
          SizedBox(
            width: 100,
            child: RadioListTile<AccountType>(
              title: const Text("共享"),
              contentPadding: EdgeInsets.zero,
              value: AccountType.share,
              groupValue: account.type,
              onChanged: _onClickRadio,
            ),
          ),
        ],
      ),
    );
  }

  void _onClickRadio(AccountType? value) {
    if (value == null) {
      return;
    }
    setState(() {
      account.type = value;
    });
  }

  void _onSelectIcon(IconData selectValue) {
    setState(() {
      account.icon = selectValue;
    });
  }

  void _onSave() {
    if (account.name.isEmpty) {
      CommonToast.tipToast("请填写账本名称");
      return;
    }
    BlocProvider.of<AccountBloc>(context).add(AccountSaveEvent(account));
  }
}

class TestAccountEdit extends StatelessWidget {
  const TestAccountEdit({super.key});

  @override
  Widget build(BuildContext context) {
    return const AccountEdit();
  }
}
