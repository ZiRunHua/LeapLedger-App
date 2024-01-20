import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keepaccount_app/bloc/account/account_bloc.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/model/account/model.dart';
import 'package:keepaccount_app/model/user/model.dart';

class ShareHome extends StatefulWidget {
  const ShareHome({super.key});

  @override
  State<ShareHome> createState() => _ShareHomeState();
}

class _ShareHomeState extends State<ShareHome> {
  @override
  void initState() {
    BlocProvider.of<AccountBloc>(context).add(ShareAccountListFetchEvent());
    super.initState();
  }

  List<AccountModel>? _shareList;
  Widget listener(Widget child) {
    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state is ShareAccountListLoaded) {
          setState(() {
            _shareList = state.list;
            if (state.list.isNotEmpty && currentAccount == null) {
              currentAccount = state.list.first;
            }
          });
        }
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return listener(Scaffold(
      appBar: AppBar(
        title: _shareList != null && _shareList!.isNotEmpty ? _buildTitle() : SizedBox(),
        centerTitle: true,
      ),
      body: Container(
          child: Column(
        children: [_buildUserList(), Text("data")],
      )),
    ));
  }

  AccountModel? currentAccount;
  Widget _buildTitle() {
    print(currentAccount!.id);
    return PopupMenuButton<AccountModel>(
      itemBuilder: (context) {
        return List.generate(
          _shareList!.length,
          (index) => PopupMenuItem(
            child: _buildAccount(_shareList![index]),
            value: _shareList![index],
          ),
        );
      },
      initialValue: currentAccount,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [_buildAccount(currentAccount!), const Icon(Icons.arrow_drop_down_rounded)],
      ),
    );
  }

  Widget _buildAccount(AccountModel account) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Icon(
          account.icon,
        ),
        Text(
          account.name,
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  UserModel testUser = UserModel.fromJson({"Username": "测试"});
  Widget _buildUserList() {
    return Wrap(
      children: [
        _buildUser(testUser),
        _buildUser(testUser),
        _buildUser(testUser),
        _buildUser(testUser),
        _buildUser(testUser),
        _buildUser(testUser),
        _buildUser(testUser),
        _buildCircular(Center(
          child: Icon(Icons.add_outlined),
        ))
      ],
    );
  }

  Widget _buildUser(UserModel userModel) {
    return _buildCircular(Center(child: Text(userModel.username)));
  }

  Widget _buildCircular(Widget child) {
    return Container(
      decoration: BoxDecoration(color: ConstantColor.greyBackground, borderRadius: BorderRadius.circular(90)),
      height: 64,
      width: 64,
      margin: const EdgeInsets.all(Constant.margin / 2),
      child: child,
    );
  }
}
