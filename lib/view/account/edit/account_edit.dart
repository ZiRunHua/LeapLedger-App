import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leap_ledger_app/bloc/account/account_bloc.dart';
import 'package:leap_ledger_app/common/global.dart';
import 'package:leap_ledger_app/model/account/model.dart';
import 'package:leap_ledger_app/routes/routes.dart';
import 'package:leap_ledger_app/widget/common/common.dart';
import 'package:leap_ledger_app/widget/form/form.dart';
import 'package:leap_ledger_app/widget/icon/enter.dart';
import 'package:timezone/src/env.dart' as tz;

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
  late AccountDetailModel account;
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
              var templatePage = TransactionCategoryRoutes.templateNavigator(context, account: state.account);
              await templatePage.push().then((value) => Navigator.pop<AccountDetailModel>(context, state.account));
            } else {
              Navigator.pop<AccountDetailModel>(context, state.account);
            }
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(mode == AccountEditMode.add ? "添加账本" : "编辑账本"),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.save, size: Constant.iconSize), onPressed: _onSave),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Constant.padding),
              child: buildForm(),
            ),
          ),
        ));
  }

  Widget buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: Constant.padding),
            child: CircularIcon(icon: account.icon),
          ),
          SizedBox(
            width: 250.w,
            child: FormInputField.string('名称', account.name, (text) => account.name = text),
          ),
          SizedBox(height: Constant.padding),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Constant.margin),
            child: FormSelecter.accountIcon(account.icon, onChanged: _onSelectIcon),
          ),
          if (mode == AccountEditMode.add) _buildTypeSelectRadio(),
          FormSelectField<String>(
            options: _options(),
            label: "地区",
            initialValue: account.location,
            onTap: (data) {
              account.location = data;
              Navigator.pop(context);
            },
            canEdit: mode == AccountEditMode.add,
            buildSelecter: ({required onTap, required options}) => FilterBottomSelecter(
              options: options,
              onTap: onTap,
              backgroundColor: Colors.white,
              listHeight: MediaQuery.of(context).size.height * 2 / 3,
            ),
          ),
        ],
      ),
    );
  }

  List<SelectOption<String>> _options() {
    List<SelectOption<String>> list = [];
    tz.timeZoneDatabase.locations.forEach((key, value) {
      list.add(SelectOption<String>(name: value.name, value: key));
    });
    return list;
  }

  Widget _buildTypeSelectRadio() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: Constant.margin, horizontal: Constant.padding),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(Constant.margin),
                  child: Text("类型", style: TextStyle(letterSpacing: Constant.margin / 2)),
                ),
                Padding(
                    padding: EdgeInsets.all(Constant.margin),
                    child: Row(children: [
                      SizedBox(
                        width: 100.sp,
                        child: RadioListTile<AccountType>(
                          contentPadding: EdgeInsets.zero,
                          title: const Text("独立"),
                          value: AccountType.independent,
                          groupValue: account.type,
                          onChanged: _onClickRadio,
                        ),
                      ),
                      SizedBox(
                        width: 100.sp,
                        child: RadioListTile<AccountType>(
                          title: const Text("共享"),
                          contentPadding: EdgeInsets.zero,
                          value: AccountType.share,
                          groupValue: account.type,
                          onChanged: _onClickRadio,
                        ),
                      )
                    ]))
              ]),
        ));
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
