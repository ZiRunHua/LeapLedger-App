import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keepaccount_app/api/api_server.dart';
import 'package:keepaccount_app/api/model/model.dart';
import 'package:keepaccount_app/bloc/captcha/captcha_bloc.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/model/account/model.dart';
import 'package:keepaccount_app/model/user/model.dart';
import 'package:keepaccount_app/routes/routes.dart';
part 'user_event.dart';
part 'user_state.dart';

class CaptchaData {
  String pic = "", email = "";
}

class UserBloc extends Bloc<UserEvent, UserState> {
  bool isLogin = false;
  static UserModel user = UserModel.fromJson({});
  static AccountModel currentAccount = AccountModel.fromJson({});
  static String username = '', email = '', token = '';
  static CaptchaData captcha = CaptchaData();

  UserBloc() : super(UserInitial()) {
    getToCache();
    on<SetCurrentAccount>(_setCurrentAccountId);
    on<UserLoginEvent>(_login);
    on<UserRegisterEvent>(_register);
    on<UserPasswordUpdateEvent>(_updatePassword);
    on<UserInfoUpdateEvent>(_updateInfo);

    on<UserFriendListFetch>(_fetchFriendList);
    on<UserSearchEvent>(_searchUser);
  }

  static UserBloc of(BuildContext context) {
    return BlocProvider.of<UserBloc>(context);
  }

  void _login(UserLoginEvent event, Emitter<UserState> emit) async {
    var bytes = utf8.encode(event.userAccount + event.password);
    var password = sha256.convert(bytes).toString();
    var response = await UserApi.login(
      event.userAccount,
      password,
      CaptchaBloc.currentCaptchaId,
      event.captcha,
    );
    if (response.isSuccess) {
      currentAccount = AccountModel.fromJson(response.data['CurrentAccount']);
      token = response.data['Token'];
      user = UserModel.fromJson(response.data['User']);
      username = user.username;
      email = user.email;
      UserBloc.saveToCache();
      emit(UserLoginedState());
      emit(UpdateCurrentAccount());
    } else {
      emit(UserLoginFailState(response.msg));
    }
  }

  void _register(UserRegisterEvent event, Emitter<UserState> emit) async {
    var bytes = utf8.encode(event.email + event.password);
    var password = sha256.convert(bytes).toString();
    var response = await UserApi.register(event.username, password, event.email, event.captcha);
    if (response.isSuccess) {
      username = event.username;
      email = event.email;
      token = response.data['Token'];
      UserBloc.saveToCache();
      emit(UserRegisterSuccessState());
    } else {
      emit(UserRegisterFailState());
    }
  }

  void _updatePassword(UserPasswordUpdateEvent event, Emitter<UserState> emit) async {
    ResponseBody response;
    switch (event.type) {
      case UserAction.forgetPassword:
        var bytes = utf8.encode(event.email + event.password);
        var password = sha256.convert(bytes).toString();
        response = await UserApi.forgetPassword(event.email, password, event.captcha);
      default:
        var bytes = utf8.encode(email + event.password);
        var password = sha256.convert(bytes).toString();
        response = await UserApi.updatePassword(password, event.captcha);
    }

    if (response.isSuccess) {
      UserBloc.saveToCache();
      emit(UserUpdatePasswordSuccess());
    } else {
      emit(UserUpdatePasswordFail());
    }
  }

  void _updateInfo(UserInfoUpdateEvent event, Emitter<UserState> emit) async {
    var responseBody = await UserApi.updateInfo(event.model);
    String oldUserName = username;
    if (event.model.username != null) {
      username = event.model.username!;
    }
    if (responseBody.isSuccess) {
      saveToCache();
      emit(UserUpdateInfoSuccess());
    } else {
      username = oldUserName;
      emit(UserUpdateInfoFail());
    }
  }

  void _setCurrentAccountId(SetCurrentAccount event, Emitter<UserState> emit) async {
    UserBloc.currentAccount = event.account;
    emit(UpdateCurrentAccount());
    UserBloc.saveToCache();
    await UserApi.setCurrentAccount(event.account.id);
  }

  /// 用户搜索
  _searchUser(UserSearchEvent event, emit) async {
    _friendList = await UserApi.getFriendList();
    emit(UserSearchFinish(_friendList));
  }

  /* 好友 */
  List<UserInfoModel> _friendList = [];
  Future<void> _fetchFriendList(UserFriendListFetch event, emit) async {
    _friendList = await UserApi.getFriendList();

    emit(UserFriendLoaded(_friendList));
  }

  static saveToCache() => Global.cache.save('User', {
        'Username': username,
        'Token': token,
        'Email': email,
        'CurrentAccount': currentAccount.toJson(),
      });

  static getToCache() {
    Map<String, dynamic> prefsData = Global.cache.getData('User');
    username = prefsData['Username'] ?? '';
    token = prefsData['Token'] ?? '';
    email = prefsData['Email'] ?? '';
    currentAccount = AccountModel.fromJson(prefsData['CurrentAccount'] ?? {});
  }

  static Widget listenerCurrentAccountIdUpdate(Function func, Widget widget) {
    return BlocListener<UserBloc, UserState>(
        listener: (_, state) {
          if (state is UpdateCurrentAccount) {
            func();
          }
        },
        child: widget);
  }

  static checkUserState(BuildContext context) {
    if (token == '') {
      Future.delayed(Duration.zero, () {
        Navigator.pushNamed(context, UserRoutes.login);
      });
      return false;
    } else if (currentAccount.id == 0) {
      //初始化账本
      Future.delayed(Duration.zero, () {
        Navigator.pushNamed(context, AccountRoutes.templateList);
      });
      return false;
    }
    return true;
  }

  static bool checkAccount() {
    return currentAccount.id > 0;
  }
}
