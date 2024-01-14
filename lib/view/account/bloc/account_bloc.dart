import 'package:bloc/bloc.dart';
import 'package:keepaccount_app/api/api_server.dart';
import 'package:keepaccount_app/model/account/model.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(AccountInitial()) {
    on<AccountSaveEvent>(_mapAccountSaveEventToState);
    on<AccountDeleteEvent>(_deleteAccount);
  }

  _deleteAccount(AccountDeleteEvent event, Emitter<AccountState> emit) async {
    if ((await AccountApi.delete(event.accountModel.id)).isSuccess) {
      emit(AccountDeleteSuccessState());
    } else {
      emit(AccountDeleteFailState());
    }
  }

  _mapAccountSaveEventToState(AccountSaveEvent event, Emitter<AccountState> emit) async {
    if (event.accountModel.id > 0) {
      if ((await AccountApi.update(event.accountModel)).isSuccess) {
        emit(AccountSaveSuccessState(event.accountModel));
      } else {
        emit(AccountSaveFailState(event.accountModel));
      }
    } else {
      if ((await AccountApi.add(event.accountModel)).isSuccess) {
        emit(AccountSaveSuccessState(event.accountModel));
      } else {
        emit(AccountSaveFailState(event.accountModel));
      }
    }
  }

  getOne(int id) async {
    await AccountApi.getOne(id);
  }
}
