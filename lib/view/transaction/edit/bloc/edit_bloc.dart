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
    on<TransactionCategoryFetch>((TransactionCategoryFetch event, emit) async {
      await _fetchTransactionCategory(event.type, emit);
    });
    on<AccountChange>(_changeAccount);
    on<TransactionSave>(_save);
  }
  late TransactionModel? _trans;
  TransactionEditMode mode;
  AccountDetailModel account;
  late TransactionEditModel trans;
  bool canAgain = false;
  _fetchData(EditDataFetch event, emit) async {}

  Future<void> _fetchTransactionCategory(IncomeExpense ie, emit) async {
    List<TransactionCategoryModel> list;
    list = await ApiServer.getData(
      () => TransactionCategoryApi.getTree(accountId: account.id, type: ie),
      TransactionCategoryApi.dataFormatFunc.getCategoryListByTree,
    );
    if (trans.categoryId == 0 && list.isNotEmpty) {
      trans.categoryId = list.first.id;
    }
    if (ie == IncomeExpense.expense) {
      emit(ExpenseCategoryPickLoaded(list));
    } else {
      emit(IncomeCategoryPickLoaded(list));
    }
  }

  _changeAccount(AccountChange event, emit) async {
    if (account.id == event.account.id) {
      return;
    }
    trans.accountId = account.id;
    account = event.account;
    await Future.wait([
      _fetchTransactionCategory(IncomeExpense.expense, emit),
      _fetchTransactionCategory(IncomeExpense.income, emit),
    ]);
    emit(AccountChanged());
  }

  _save(TransactionSave event, emit) {
    if (event.amount != null) {
      trans.amount = event.amount!;
    }
    var newTrans = trans.copy();
    if (mode == TransactionEditMode.add) {
      canAgain = event.isAgain;
      if (canAgain) {
        trans.amount = 0;
      }
      emit(AddNewTransaction(newTrans));
    } else {
      emit(UpdateTransaction(_trans!, newTrans));
    }
  }
}
