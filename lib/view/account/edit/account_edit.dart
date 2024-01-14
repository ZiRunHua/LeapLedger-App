import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/model/account/model.dart';
import 'package:keepaccount_app/view/account/bloc/account_bloc.dart';
import 'package:keepaccount_app/widget/form/form.dart';

class AccountEdit extends StatelessWidget {
  const AccountEdit({super.key, this.account});
  final AccountModel? account;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountBloc>(
      create: (context) => AccountBloc(),
      child: _AccountEdit(account: account),
    );
  }
}

class _AccountEdit extends StatefulWidget {
  const _AccountEdit({this.account});
  final AccountModel? account;
  @override
  _AccountEditState createState() => _AccountEditState();
}

class _AccountEditState extends State<_AccountEdit> {
  final _formKey = GlobalKey<FormState>();
  late AccountModel account;

  @override
  void initState() {
    if (widget.account == null) {
      account = AccountModel.fromJson({});
    } else {
      account = widget.account!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountBloc, AccountState>(
        listener: (context, state) {
          if (state is AccountSaveSuccessState) {
            Navigator.pop(context, state.accountModel);
          }
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text('编辑账本'),
              actions: <Widget>[
                IconButton(
                    icon: const Icon(
                      Icons.save,
                      size: 24,
                    ),
                    onPressed: _onSave),
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
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(90),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            width: 64,
            height: 64,
            child: Icon(
              account.icon,
              size: 32,
              color: Colors.black87,
            ),
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
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
    BlocProvider.of<AccountBloc>(context).add(AccountSaveEvent(account));
  }
}

class TestAccountEdit extends StatelessWidget {
  const TestAccountEdit({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AccountEdit();
  }
}
