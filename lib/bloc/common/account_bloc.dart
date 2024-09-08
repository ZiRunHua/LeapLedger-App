part of 'enter.dart';

class AccountBasedBloc<Event, State> extends Bloc<Event, State> {
  AccountBasedBloc(State initialState, {required this.account}) : super(initialState) {}
  late AccountDetailModel account;
  Location get location => account.timeLocation;
  TZDateTime getTZDateTime(DateTime time) => account.getTZDateTime(time);
  TZDateTime get nowTime => account.getNowTime();
}

class AccountBasedCubit<State> extends Cubit<State> {
  AccountBasedCubit(State initialState, {required this.account}) : super(initialState);
  late AccountDetailModel account;

  Location get location => account.timeLocation;
  TZDateTime getTZDateTime(DateTime time) => account.getTZDateTime(time);
  TZDateTime get nowTime => account.getNowTime();
}
