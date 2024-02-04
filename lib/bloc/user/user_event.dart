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
  final int offset, limit;
  late final int? id;
  late final String username;
  UserSearchEvent({required this.offset, required this.limit, this.id, required this.username});
  UserSearchEvent.formInputUsername({required this.offset, required this.limit, required String inputStr}) {
    List<String> parts = inputStr.split("#");
    if (parts.length == 2) {
      id = int.tryParse(parts[1]);
      if (id != null) {
        username = parts[0];
      } else {
        username = inputStr;
      }
    } else {
      username = inputStr;
      id = null;
    }
  }
}
