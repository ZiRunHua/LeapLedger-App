import 'package:leap_ledger_app/bloc/common/enter.dart';
import 'package:leap_ledger_app/common/global.dart';
import 'package:leap_ledger_app/model/account/model.dart';
import 'package:leap_ledger_app/model/transaction/category/model.dart';
import 'package:leap_ledger_app/model/transaction/model.dart';
import 'package:leap_ledger_app/model/user/model.dart';
import 'package:leap_ledger_app/widget/toast.dart';
import 'package:meta/meta.dart';

part 'edit_event.dart';
part 'edit_state.dart';

class EditBloc extends AccountBasedBloc<EditEvent, EditState> {
  EditBloc(
      {required this.user,
      required super.account,
      required this.mode,
      TransactionModel? trans,
      TransactionInfoModel? transInfo})
      : super(EditInitial()) {
    switch (mode) {
      case TransactionEditMode.add:
        canAgain = true;
        this.transInfo = transInfo ?? TransactionInfoModel.prototypeData()
          ..setUser(user)
          ..setAccount(account);
        break;
      case TransactionEditMode.update:
        assert(mode == TransactionEditMode.update && trans != null);
        canAgain = false;
        _originalTrans = trans!;
        this.transInfo = _originalTrans!.copy();
        break;
      case TransactionEditMode.popTrans:
        canAgain = false;
        this.transInfo = transInfo ?? TransactionInfoModel.prototypeData()
          ..setUser(user)
          ..setAccount(account);
        break;
    }

    on<AccountChange>(_changeAccount);
    on<TransactionSave>(_save);
  }
  UserModel user;
  late TransactionInfoModel transInfo;
  late TransactionModel? _originalTrans;

  TransactionEditMode mode;
  bool canAgain = false;

  _changeAccount(AccountChange event, emit) async {
    if (mode == TransactionEditMode.popTrans || account.id == event.account.id) {
      return;
    }
    account = event.account;
    transInfo.setAccount(account);
    emit(AccountChanged());
  }

  _save(TransactionSave event, emit) {
    if (event.amount != null) transInfo.amount = event.amount!;
    if (event.ie != null) transInfo.incomeExpense = event.ie!;
    var newTrans = transInfo.copy();
    var checkTip = newTrans.check();
    if (checkTip != null) {
      tipToast(checkTip);
      return;
    }
    switch (mode) {
      case TransactionEditMode.update:
        emit(UpdateTransaction(_originalTrans!, newTrans));
        break;
      case TransactionEditMode.add:
        canAgain = event.isAgain;
        if (canAgain) {
          transInfo.amount = 0;
        }
        emit(AddNewTransaction(newTrans));
        break;
      case TransactionEditMode.popTrans:
        emit(PopTransaction(newTrans));
        break;
    }
  }
}
