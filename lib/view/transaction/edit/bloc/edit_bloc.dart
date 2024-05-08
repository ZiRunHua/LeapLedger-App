import 'package:bloc/bloc.dart';
import 'package:keepaccount_app/api/api_server.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/model/account/model.dart';
import 'package:keepaccount_app/model/transaction/category/model.dart';
import 'package:keepaccount_app/model/transaction/model.dart';
import 'package:meta/meta.dart';

part 'edit_event.dart';
part 'edit_state.dart';

class EditBloc extends Bloc<EditEvent, EditState> {
  EditBloc({required this.account, required this.mode, TransactionModel? trans}) : super(EditInitial()) {
    assert((mode == TransactionEditMode.add) || mode == TransactionEditMode.update && trans != null);
    if (mode == TransactionEditMode.update) {
      _trans = trans!;
      this.trans = _trans!.editModel;
    } else {
      canAgain = true;
      this.trans = TransactionEditModel.init()..accountId = account.id;
    }
    on<EditDataFetch>(_fetchData);
    on<TransactionCategoryFetch>(_fetchTransactionCategory);
    on<AccountChange>(_changeAccount);
    on<TransactionSave>(_save);
  }
  late TransactionModel? _trans;
  TransactionEditMode mode;
  AccountDetailModel account;
  late TransactionEditModel trans;
  bool canAgain = false;
  _fetchData(EditDataFetch event, emit) async {}

  _fetchTransactionCategory(TransactionCategoryFetch event, emit) async {
    List<TransactionCategoryModel> list;
    list = await ApiServer.getData(
      () => TransactionCategoryApi.getTree(accountId: account.id, type: event.type),
      TransactionCategoryApi.dataFormatFunc.getCategoryListByTree,
    );
    if (trans.categoryId == 0 && list.isNotEmpty) {
      trans.categoryId = list.first.id;
    }
    if (event.type == IncomeExpense.expense) {
      emit(ExpenseCategoryPickLoaded(list));
    } else {
      emit(IncomeCategoryPickLoaded(list));
    }
  }

  _changeAccount(AccountChange event, emit) {
    if (account.id == event.account.id) {
      return;
    }
    account.copyWith(event.account);
    emit(AccountChanged(account));
  }

  _save(TransactionSave event, emit) {
    if (event.amount != null) {
      trans.amount = event.amount!;
    }
    if (mode == TransactionEditMode.add) {
      canAgain = event.isAgain;
      emit(AddNewTransaction(trans));
    } else {
      emit(UpdateTransaction(_trans!, trans));
    }
  }
}
