part of 'user_bloc.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UpdateCurrentAccount extends UserState {}

//登录
class UserLoginedState extends UserState {}

class UserLoginFailState extends UserState {
  final String msg;
  UserLoginFailState(this.msg);
}

//注册
class UserRegisterSuccessState extends UserState {}

class UserRegisterFailState extends UserState {}

//验证码
class UserGetCaptchaSuccess extends UserState {}

class UserSendEmailCaptchaSuccess extends UserState {}

//修改密码
class UserUpdatePasswordSuccess extends UserState {}

class UserUpdatePasswordFail extends UserState {}

//修改个人信息
class UserUpdateInfoSuccess extends UserState {}

class UserUpdateInfoFail extends UserState {}

/*好友*/
class UserFriendLoaded extends UserState {
  List<UserInfoModel> list;
  UserFriendLoaded(this.list);
}

class UserSearchFinish extends UserState {
  List<UserInfoModel> list;
  UserSearchFinish(this.list);
}
