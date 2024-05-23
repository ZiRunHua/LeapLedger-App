part of 'enter.dart';

class FlowConditionCubit extends Cubit<FlowConditionState> {
  final TransactionQueryCondModel _defaultCondition = TransactionQueryCondModel(
    accountId: UserBloc.currentAccount.id,
    startTime: DateTime(DateTime.now().year, DateTime.now().month - 6),
    endTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59),
  );

  late TransactionQueryCondModel condition, _condition;
  late AccountDetailModel currentAccount;
  Map<int, List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>>> _categoryCache = {};
  List<AccountDetailModel> accountList = [];

  ///condition和currentAccount要么都传 要么都不传
  ///不传时会取默认值
  FlowConditionCubit({TransactionQueryCondModel? condition, required this.currentAccount})
      : assert(condition?.accountId == currentAccount.id),
        super(FlowConditionInitial()) {
    _condition = condition ?? _defaultCondition;
    this.condition = _condition.copyWith();
  }

  List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>> categorytree = [];
  fetchCategoryData({int? accountId}) async {
    accountId = accountId ?? condition.accountId;
    if (_categoryCache[accountId] == null) {
      _categoryCache[accountId] = await ApiServer.getData(
        () => TransactionCategoryApi.getTree(accountId: accountId),
        TransactionCategoryApi.dataFormatFunc.getTreeDataToList,
      );
    }
    categorytree = _categoryCache[accountId]!;
    emit(FlowConditionCategoryLoaded());
  }

  fetchAccountList() async {
    accountList = await AccountApi.getList();
    emit(FlowConditionAccountLoaded(accountList));
  }

  save() async {
    if (_condition == condition) {
      return;
    }

    _condition.accountId = condition.accountId;
    _condition.userIds = condition.userIds.toSet();
    _condition.categoryIds = condition.categoryIds.toSet();
    _condition.incomeExpense = condition.incomeExpense;
    _condition.minimumAmount = condition.minimumAmount;
    _condition.maximumAmount = condition.maximumAmount;
    _condition.startTime = condition.startTime;
    _condition.endTime = condition.endTime;
    emit(FlowConditionChanged(_condition));
  }

  setOptionalFieldsToEmpty() {
    condition.userIds = {};
    condition.categoryIds = {};
    condition.incomeExpense = null;
    condition.minimumAmount = null;
    condition.maximumAmount = null;
    emit(FlowEditingConditionUpdate());
  }

  sync() {
    if (_condition == condition) {
      return;
    }
    condition.accountId = _condition.accountId;
    condition.userIds = _condition.userIds.toSet();
    condition.categoryIds = _condition.categoryIds.toSet();
    condition.incomeExpense = _condition.incomeExpense;
    condition.minimumAmount = _condition.minimumAmount;
    condition.maximumAmount = _condition.maximumAmount;
    condition.startTime = _condition.startTime.copyWith();
    condition.endTime = _condition.endTime.copyWith();
  }

  updateAccount(AccountDetailModel account) async {
    if (condition.accountId == account.id) {
      return;
    }
    condition.accountId = account.id;
    _condition.accountId = account.id;
    currentAccount = account;
    emit(FlowConditionChanged(condition));
    emit(FlowCurrentAccountChanged());
    await fetchCategoryData(accountId: account.id);
  }

  resetTime() {
    condition.startTime = _condition.startTime;
    condition.endTime = _condition.endTime;
    emit(FlowEditingConditionUpdate());
  }

  updateTime({required DateTime startTime, required DateTime endTime}) {
    if (endTime.isAtSameMomentAs(condition.startTime) && endTime.isAtSameMomentAs(endTime)) {
      return;
    }
    condition.startTime = startTime;
    condition.endTime = endTime;
    _condition.startTime = startTime.copyWith();
    _condition.endTime = endTime.copyWith();
    emit(FlowConditionChanged(condition));
  }

  selectCategory({required TransactionCategoryModel category}) {
    if (condition.categoryIds.contains(category.id)) {
      condition.categoryIds.remove(category.id);
    } else {
      condition.categoryIds.add(category.id);
    }
    emit(FlowEditingConditionUpdate());
  }

  changeIncomeExpense({IncomeExpense? ie}) {
    condition.incomeExpense = ie;
    emit(FlowEditingConditionUpdate());
  }

  updateMinimumAmount({int? amount}) {
    condition.minimumAmount = amount;
  }

  updateMaximumAmount({int? amount}) {
    condition.maximumAmount = amount;
  }
}
