part of 'enter.dart';

class FlowConditionCubit extends Cubit<FlowConditionState> {
  final TransactionQueryConditionApiModel _defaultCondition = TransactionQueryConditionApiModel(
    accountId: UserBloc.currentAccount.id,
    startTime: DateTime(DateTime.now().year, DateTime.now().month - 6),
    endTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59),
  );

  late TransactionQueryConditionApiModel condition, _condition;
  late AccountDetailModel currentAccount;
  Map<int, List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>>> _categoryCache = {};
  List<AccountDetailModel> accountList = [];

  ///condition和currentAccount要么都传 要么都不传
  ///不传时会取默认值
  FlowConditionCubit({TransactionQueryConditionApiModel? condition, required this.currentAccount})
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
    emit(FlowConditionUpdate(_condition));
  }

  reset() {
    condition.userIds = {};
    condition.categoryIds = {};
    condition.incomeExpense = null;
    condition.minimumAmount = null;
    condition.maximumAmount = null;
    save();
  }

  updateAccount(AccountDetailModel account) async {
    if (condition.accountId == account.id) {
      return;
    }
    condition.accountId = account.id;
    save();
    await fetchCategoryData(accountId: account.id);
  }

  updateTime({required DateTime startTime, required DateTime endTime}) {
    if (startTime == condition.startTime && endTime == endTime) {
      return;
    }
    condition.startTime = startTime;
    condition.endTime = endTime;
    save();
  }

  selectCategory({required TransactionCategoryModel category}) {
    if (condition.categoryIds.contains(category.id)) {
      condition.categoryIds.remove(category.id);
    } else {
      condition.categoryIds.add(category.id);
    }
    save();
  }

  changeIncomeExpense({IncomeExpense? ie}) {
    condition.incomeExpense = ie;
    save();
  }

  updateMinimumAmount({int? amount}) {
    condition.minimumAmount = amount;
  }

  updateMaximumAmount({int? amount}) {
    condition.maximumAmount = amount;
  }
}
