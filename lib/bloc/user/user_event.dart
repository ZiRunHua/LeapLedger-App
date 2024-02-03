part of 'user_bloc.dart';

abstract class UserEvent {}

class UserLoginEvent extends UserEvent {
  final String userAccount, password, captcha;
  UserLoginEvent(this.userAccount, this.password, this.captcha);
}

class UserRegisterEvent extends UserEvent {
  final String email, username, password, captcha;
  UserRegisterEvent(this.email, this.username, this.password, this.captcha);
}

// 忘记密码与修改密码当作同一种事件 通过type以区分二者来调用不同的接口
class UserPasswordUpdateEvent extends UserEvent {
  final String email, password, captcha;
  final UserAction type;
  UserPasswordUpdateEvent(this.email, this.password, this.captcha, this.type);
}

class UserInfoUpdateEvent extends UserEvent {
  final UserInfoUpdateModel model;
  UserInfoUpdateEvent(this.model);
}

class SetCurrentAccount extends UserEvent {
  final AccountModel account;
  SetCurrentAccount(this.account);
}

class UserFriendListFetch extends UserEvent {
  UserFriendListFetch();
}

class UserSearchEvent extends UserEvent {
  final String searchStr;
  UserSearchEvent(this.searchStr);
}
