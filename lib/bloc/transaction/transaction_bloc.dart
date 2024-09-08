import 'package:bloc/bloc.dart';
import 'package:leap_ledger_app/api/api_server.dart';
import 'package:leap_ledger_app/bloc/user/config/user_config_bloc.dart';
import 'package:leap_ledger_app/common/global.dart';
import 'package:leap_ledger_app/model/account/model.dart';
import 'package:leap_ledger_app/model/transaction/model.dart';
import 'package:leap_ledger_app/widget/common/common.dart';
import 'package:meta/meta.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitial()) {
    on<TransactionAdd>(_handleAdd);
    on<TransactionUpdate>(_handleUpdate);
    on<TransactionDelete>(_handleDelete);
    on<TransactionShare>(_handleShare);
  }
  _handleAdd(TransactionAdd event, emit) async {
    var editModel = event.editModel;
    if (false == _verificationData(editModel, emit)) {
      return;
    }
    var trans = await TransactionApi.add(editModel);
    if (trans == null) {
      return;
    }
    emit(TransactionAddSuccess(trans));
    _handleStatisticUpdate(emit, newTrans: trans);
  }

  _handleUpdate(TransactionUpdate event, emit) async {
    assert(event.editModel.id != 0);
    if (event.editModel.id == 0) {
      return;
    }
    var editModel = event.editModel;
    if (false == _verificationData(editModel, emit)) {
      return;
    }
    TransactionModel? newTrans = await TransactionApi.update(editModel);
    if (newTrans == null) {
      return;
    }
    CommonToast.tipToast("编辑成功");
    if (event.oldTrans.accountId != newTrans.accountId) {
      emit(TransactionUpdateSuccess(event.oldTrans, newTrans));
    } else {
      emit(TransactionDeleteSuccess(event.oldTrans));
      emit(TransactionAddSuccess(newTrans));
    }
    _handleStatisticUpdate(emit, oldTrans: event.oldTrans, newTrans: newTrans);
  }

  _handleDelete(TransactionDelete event, emit) async {
    assert(event.trans.id != 0);
    if (event.trans.id == 0) {
      return;
    }
    var response = await TransactionApi.delete(event.trans.id, accountId: event.trans.accountId);
    if (response.isSuccess == false) {
      return;
    }
    CommonToast.tipToast("删除成功");
    emit(TransactionDeleteSuccess(event.trans));
    _handleStatisticUpdate(emit, oldTrans: event.trans);
  }

  _handleStatisticUpdate(emit, {TransactionEditModel? oldTrans, TransactionEditModel? newTrans}) {
    if (oldTrans == null && newTrans == null) {
      return;
    }
    emit(TransactionStatisticUpdate(oldTrans, newTrans));
  }

  bool _verificationData(TransactionEditModel data, emit) {
    if (data.categoryId == 0) {
      emit(TransactionDataVerificationFails("请选择交易类型"));
      return false;
    }
    if (data.accountId == 0) {
      emit(TransactionDataVerificationFails("请选择账本"));
      return false;
    }
    if (data.amount <= 0) {
      emit(TransactionDataVerificationFails("金额需大于0"));
      return false;
    }
    if (data.amount > Constant.maxAmount) {
      emit(TransactionDataVerificationFails("金额过大"));
      return false;
    }
    if (data.tradeTime.year > Constant.maxYear || data.tradeTime.year < Constant.minYear) {
      emit(TransactionDataVerificationFails("时间超过范围"));
      return false;
    }
    emit(TransactionDataVerificationSuccess());
    return true;
  }

  _handleShare(TransactionShare event, emit) async {
    if (UserConfigBloc.transShareConfig == null) {
      await UserConfigBloc.loadTransShareConfig();
    }
    var shareConfig = UserConfigBloc.transShareConfig;
    if (shareConfig == null) {
      return;
    }
    emit(TransactionShareLoaded(event.trans.getShareModelByConfig(shareConfig)));
  }
}
