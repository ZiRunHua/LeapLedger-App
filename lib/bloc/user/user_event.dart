part of 'user_bloc.dart';

abstract class UserEvent {}

class UserLoginEvent extends UserEvent {
  final String userAccount, password, captcha;
  UserLoginEvent(this.userAccount, this.password, this.captcha);
}

class UserLogoutEvent extends UserEvent {
  UserLogoutEvent();
}

class UserRegisterEvent extends UserEvent {
  final String email, username, password, captcha;
  UserRegisterEvent(this.email, this.username, this.password, this.captcha);
}

class UserRequestTourEvent extends UserEvent {
  UserRequestTourEvent();
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

class UpdateCurrentInfoEvent extends UserEvent {
  final UserCurrentModel data;
  UpdateCurrentInfoEvent(this.data);
}

class SetCurrentAccount extends UserEvent {
  final AccountDetailModel account;
  SetCurrentAccount(this.account);
}

class SetCurrentShareAccount extends UserEvent {
  final AccountDetailModel account;
  SetCurrentShareAccount(this.account);
}

class UserFriendListFetch extends UserEvent {
  UserFriendListFetch();
}

class UserSearchEvent extends UserEvent {
  final int offset, limit;
  late final int? id;
  late final String username;
  UserSearchEvent({required this.offset, required this.limit, this.id, required this.username});
  UserSearchEvent.formInputUsername({this.offset = 0, this.limit = 20, required String inputStr}) {
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
