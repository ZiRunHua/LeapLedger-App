import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leap_ledger_app/bloc/user/user_bloc.dart';
import 'package:leap_ledger_app/common/global.dart';
import 'package:leap_ledger_app/model/user/model.dart';
import 'package:leap_ledger_app/widget/common/common.dart';
import 'package:leap_ledger_app/widget/form/form.dart';

class UserSearch extends StatefulWidget {
  const UserSearch({super.key});

  @override
  State<UserSearch> createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
  late final CommonPageController<UserInfoModel> _pageController;
  late final UserBloc _userBloc;
  @override
  void initState() {
    _userBloc = UserBloc.of(context);
    _pageController = CommonPageController<UserInfoModel>(
        refreshListener: _onFetchData,
        loadMoreListener: _onFetchData,
        filter: (UserInfoModel data) {
          return realInputStr == null || data.username.startsWith(realInputStr!);
        });
    _onFetchData(offset: 0, limit: _pageController.limit);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onFetchData({required int offset, required int limit}) {
    if (inputStr == null) {
      _userBloc.add(UserFriendListFetch());
      return;
    }
    _userBloc.add(UserSearchEvent.formInputUsername(inputStr: inputStr!, offset: offset, limit: limit));
  }

  String? inputStr;
  String? realInputStr;
  _changeInputStr(String? value) {
    inputStr = value;
    if (inputStr != null) {
      int hashIndex = inputStr!.indexOf('#');
      if (hashIndex != -1) {
        realInputStr = inputStr!.substring(0, hashIndex);
        return;
      }
    }
    realInputStr = inputStr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DefaultTextStyle.merge(
          style: const TextStyle(fontSize: ConstantFontSize.largeHeadline),
          child: FormInputField.searchInput(
            onChanged: (String? value) {
              _changeInputStr(value);
              _pageController.notifyListeners();
            },
            onSubmitted: (String? value) {
              _changeInputStr(value);
              _pageController.refresh();
            },
          ),
        ),
      ),
      body: BlocListener<UserBloc, UserState>(
        listenWhen: (_, state) {
          if (state is UserSearchFinish || state is UserFriendLoaded) {
            return true;
          }
          return false;
        },
        listener: (context, state) {
          if (state is UserSearchFinish) {
            _pageController.addListData(state.list);
          } else if (state is UserFriendLoaded) {
            _pageController.setList(state.list);
          }
        },
        child: CommonPageList<UserInfoModel>(
          buildListOne: _buildListTile,
          prototypeData: UserInfoModel(email: "testtesttest@qq.com", username: "test", id: 1),
          initRefresh: true,
          controller: _pageController,
        ),
      ),
    );
  }

  Widget _buildListTile(UserInfoModel user) {
    return ListTile(
      leading: user.avatarPainterWidget,
      title: Text(user.username),
      subtitle: Text(user.email),
      onTap: () => Navigator.pop<UserInfoModel>(context, user),
    );
  }
}
