import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leap_ledger_app/api/api_server.dart';
import 'package:leap_ledger_app/api/model/model.dart';
import 'package:leap_ledger_app/bloc/account/account_bloc.dart';
import 'package:leap_ledger_app/bloc/captcha/captcha_bloc.dart';
import 'package:leap_ledger_app/common/current.dart';
import 'package:leap_ledger_app/common/global.dart';
import 'package:leap_ledger_app/model/account/model.dart';
import 'package:leap_ledger_app/model/user/model.dart';
import 'package:leap_ledger_app/routes/routes.dart';
import 'package:leap_ledger_app/widget/common/common.dart';
part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  static UserModel user = UserModel.fromJson({});
  static AccountDetailModel currentAccount = AccountDetailModel.fromJson({});
  static AccountDetailModel currentShareAccount = AccountDetailModel.fromJson({});
  static String token = '';

  static bool get isLogin => token != "" && user.isValid;

  UserBloc(this._accountBloc) : super(UserInitial()) {
    getToCache();
    parentBlocSubscription = _accountBloc.stream.listen(_accountBlocListen);
    on<SetCurrentAccount>((event, emit) async {
      await _setCurrentAccount(event.account, emit);
    });
    on<SetCurrentShareAccount>((event, emit) async {
      await _setCurrentShareAccount(event.account, emit);
    });
    on<UserLoginEvent>(_login);
    on<UserLogoutEvent>(_logout);
    on<UserRegisterEvent>(_register);
    on<UserRequestTourEvent>(_requestTour);
    on<UserPasswordUpdateEvent>(_updatePassword);
    on<UserInfoUpdateEvent>(_updateInfo);
    on<UpdateCurrentInfoEvent>((event, emit) async {
      await _updateCurrentInfo(event.data, emit);
    });
    on<UserFriendListFetch>(_fetchFriendList);
    on<UserSearchEvent>(_searchUser);
  }

  static UserBloc of(BuildContext context) {
    return BlocProvider.of<UserBloc>(context);
  }

  final AccountBloc _accountBloc;
  late final StreamSubscription parentBlocSubscription;
  _accountBlocListen(AccountState state) {
    if (state is AccountDeleteSuccess) {
      this.add(UpdateCurrentInfoEvent(state.currentInfo));
    } else if (state is AccountSaveSuccess) {
      this.add(SetCurrentAccount(state.account));
      if (state.account.type == AccountType.independent) {
      } else if (state.account.type == AccountType.share) {
        this.add(SetCurrentShareAccount(state.account));
      }
    }
  }

  @override
  Future<void> close() async {
    parentBlocSubscription.cancel();
    await super.close();
  }

  void _login(UserLoginEvent event, Emitter<UserState> emit) async {
    var userAccount = event.userAccount.trim();
    var password = event.password.trim();
    var captcha = event.captcha.trim();
    if (userAccount.isEmpty || password.isEmpty || captcha.isEmpty) {
      emit(UserLoginFailState("请输入"));
    }
    var bytes = utf8.encode(userAccount + password);
    password = sha256.convert(bytes).toString();
    var response = await UserApi.login(
      userAccount,
      password,
      CaptchaBloc.currentCaptchaId,
      captcha,
    );
    if (response.isSuccess) {
      UserBloc.currentAccount = AccountDetailModel.fromJson(response.data['CurrentAccount']);
      UserBloc.currentShareAccount = AccountDetailModel.fromJson(response.data['CurrentShareAccount']);
      token = response.data['Token'];
      user = UserModel.fromJson(response.data['User']);
      UserBloc.saveToCache();
      emit(UserLoginedState());
      emit(CurrentAccountChanged());
      emit(CurrentShareAccountChanged());
    } else {
      emit(UserLoginFailState(response.msg));
    }
  }

  void _logout(UserLogoutEvent event, Emitter<UserState> emit) async {
    UserBloc.user = UserModel.fromJson({});
    UserBloc.currentAccount = AccountDetailModel.fromJson({});
    UserBloc.currentShareAccount = AccountDetailModel.fromJson({});
    token = "";
    await UserBloc.saveToCache();
    emit(CurrentAccountChanged());
    emit(CurrentShareAccountChanged());
  }

  void _register(UserRegisterEvent event, Emitter<UserState> emit) async {
    var bytes = utf8.encode(event.email + event.password);
    var password = sha256.convert(bytes).toString();
    var response = await UserApi.register(event.username, password, event.email, event.captcha);
    if (response.isSuccess) {
      token = response.data['Token'];
      user = UserModel.fromJson(response.data['User']);
      UserBloc.saveToCache();
      emit(UserRegisterSuccessState());
    } else {
      emit(UserRegisterFailState());
    }
  }

  void _requestTour(UserRequestTourEvent event, Emitter<UserState> emit) async {
    if (Current.deviceId == null) {
      return;
    }
    var response = await UserApi.requestTour(deviceNumber: Current.deviceId!);
    if (false == response.isSuccess) {
      CommonToast.tipToast(response.msg);
      return;
    };
    UserBloc.currentAccount = AccountDetailModel.fromJson(response.data['CurrentAccount']);
    UserBloc.currentShareAccount = AccountDetailModel.fromJson(response.data['CurrentShareAccount']);
    token = response.data['Token'];
    user = UserModel.fromJson(response.data['User']);
    UserBloc.saveToCache();
    emit(UserLoginedState());
    emit(CurrentAccountChanged());
    emit(CurrentShareAccountChanged());
  }

  void _updatePassword(UserPasswordUpdateEvent event, Emitter<UserState> emit) async {
    ResponseBody response;
    switch (event.type) {
      case UserAction.forgetPassword:
        var bytes = utf8.encode(event.email + event.password);
        var password = sha256.convert(bytes).toString();
        response = await UserApi.forgetPassword(event.email, password, event.captcha);
      default:
        var bytes = utf8.encode(user.email + event.password);
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
    if (event.model.username == null) {
      emit(UserUpdateInfoFail());
      return;
    }
    var responseBody = await UserApi.updateInfo(event.model);
    if (responseBody.isSuccess) {
      user.username = event.model.username!;
      UserBloc.saveToCache();
      emit(UserUpdateInfoSuccess());
    } else {
      emit(UserUpdateInfoFail());
    }
  }

  _updateCurrentInfo(UserCurrentModel data, Emitter<UserState> emit) async {
    var needSaveCache = false;
    var isUpdateCurrent = data.currentAccount.isValid;
    if (isUpdateCurrent && false == data.currentAccount.isSame(currentAccount)) {
      UserBloc.currentAccount = data.currentAccount.copy();
      emit(CurrentAccountChanged());
      needSaveCache = true;
    }

    if (false == data.currentShareAccount.isSame(currentShareAccount)) {
      UserBloc.currentShareAccount = data.currentShareAccount.copy();
      emit(CurrentShareAccountChanged());
      needSaveCache = true;
    }

    if (needSaveCache) {
      UserBloc.saveToCache();
    }
  }

  _setCurrentAccount(AccountDetailModel account, Emitter<UserState> emit) async {
    if (UserBloc.currentAccount.isSame(account)) {
      return;
    }
    UserBloc.currentAccount = account.copy();
    emit(CurrentAccountChanged());
    UserBloc.saveToCache();
    await UserApi.setCurrentAccount(account.id);
  }

  _setCurrentShareAccount(AccountDetailModel account, Emitter<UserState> emit) async {
    if (UserBloc.currentShareAccount.isSame(account)) {
      return;
    }
    UserBloc.currentShareAccount = account.copy();
    emit(CurrentShareAccountChanged());
    saveToCache();
    await UserApi.setCurrentShareAccount(account.id);
  }

  /// 用户搜索
  _searchUser(UserSearchEvent event, emit) async {
    _friendList =
        await UserApi.search(offset: event.offset, limit: event.limit, id: event.id, username: event.username);
    emit(UserSearchFinish(_friendList));
  }

  /* 好友 */
  List<UserInfoModel> _friendList = [];
  Future<void> _fetchFriendList(UserFriendListFetch event, emit) async {
    _friendList = await UserApi.getFriendList();

    emit(UserFriendLoaded(_friendList));
  }

  static saveToCache() => Global.cache.save('User', {
        'User': user.toJson(),
        'CurrentShareAccount': UserBloc.currentShareAccount.toJson(),
        'CurrentAccount': UserBloc.currentAccount.toJson(),
        'Token': token,
      });

  static getToCache() {
    Map<String, dynamic> prefsData = Global.cache.getData('User');
    user = UserModel.fromJson(prefsData['User'] ?? {});
    UserBloc.currentShareAccount = AccountDetailModel.fromJson(prefsData['CurrentShareAccount'] ?? {});
    UserBloc.currentAccount = AccountDetailModel.fromJson(prefsData['CurrentAccount'] ?? {});

    token = prefsData['Token'] ?? '';
  }

  static Widget listenerCurrentAccountIdUpdate(Function func, Widget widget) {
    return BlocListener<UserBloc, UserState>(
        listener: (_, state) {
          if (state is CurrentAccountChanged) {
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
    } else if (false == currentAccount.isValid) {
      //初始化账本
      Future.delayed(Duration.zero, () {
        Navigator.pushNamed(context, AccountRoutes.templateList);
      });
      return false;
    }
    return true;
  }

  static bool checkAccount() {
    return currentAccount.isValid;
  }
}
