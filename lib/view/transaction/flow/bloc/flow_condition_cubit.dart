part of 'enter.dart';

class FlowConditionCubit extends AccountBasedCubit<FlowConditionState> {
  late TransactionQueryCondModel condition, _condition;
  Map<int, List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>>> _categoryCache = {};
  List<AccountDetailModel> accountList = [];

  ///condition和currentAccount要么都传 要么都不传
  ///不传时会取默认值
  FlowConditionCubit({TransactionQueryCondModel? condition, required super.account})
      : assert(condition?.accountId == account.id),
        super(FlowConditionInitial()) {
    if (condition == null) {
      var nowTime = UserBloc.currentAccount.getNowTime();
      _condition = TransactionQueryCondModel(
        accountId: UserBloc.currentAccount.id,
        startTime: TZDateTime(nowTime.location, nowTime.year, nowTime.month - 6),
        endTime: TZDateTime(nowTime.location, nowTime.year, nowTime.month, nowTime.day, 23, 59, 59),
      );
    } else {
      _condition = condition;
    }
    this.condition = _condition.copyWith();
  }

  List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>> categorytree = [];
  fetchCategoryData({int? accountId}) async {
    accountId = accountId ?? condition.accountId;
    if (_categoryCache[accountId] == null) {
      _categoryCache[accountId] = await ApiServer.getData(
        () => CategoryApi.getTree(accountId: accountId!),
        CategoryApi.dataFormatFunc.getTreeDataToList,
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
    condition.startTime = Tz.copy(_condition.startTime);
    condition.endTime = Tz.copy(_condition.endTime);
  }

  updateAccount(AccountDetailModel account) async {
    if (condition.accountId == account.id) {
      return;
    }
    this.account = account;
    condition.accountId = account.id;
    _condition.accountId = account.id;
    condition.categoryIds.clear();
    _condition.categoryIds.clear();
    account = account;
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
    var tzStartTime = Tz.getNewByDate(startTime, location);
    var tzEndTime = Tz.getNewByDate(endTime, location);
    if (tzEndTime.isAtSameMomentAs(condition.startTime) && endTime.isAtSameMomentAs(tzStartTime)) {
      return;
    }
    condition.startTime = tzStartTime;
    condition.endTime = tzEndTime;
    _condition.startTime = Tz.copy(tzStartTime);
    _condition.endTime = Tz.copy(tzEndTime);
    emit(FlowConditionChanged(condition));
  }

  selectCategory({required TransactionCategoryBaseModel category}) {
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
