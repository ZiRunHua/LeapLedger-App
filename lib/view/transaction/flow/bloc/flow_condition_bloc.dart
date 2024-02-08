part of 'enter.dart';

class FlowConditionBloc extends Bloc<FlowConditionEvent, FlowConditionState> {
  final TransactionQueryConditionApiModel _defaultCondition = TransactionQueryConditionApiModel(
    accountId: UserBloc.currentAccount.id,
    startTime: DateTime(DateTime.now().year, DateTime.now().month - 6),
    endTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59),
  );

  late TransactionQueryConditionApiModel condition;
  late AccountModel currentAccount;
  Map<int, List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>>> _categoryCache = {};
  List<AccountModel> accountList = [];

  ///condition和currentAccount要么都传 要么都不传
  ///不传时会取默认值
  FlowConditionBloc({TransactionQueryConditionApiModel? condition, AccountModel? currentAccount})
      : assert(condition == null && currentAccount == null || condition != null && currentAccount != null),
        assert(condition?.accountId == currentAccount?.id),
        super(FlowConditionInitial()) {
    this.condition = condition ?? _defaultCondition;
    print(this.condition.startTime);
    this.currentAccount = currentAccount ?? UserBloc.currentAccount;
    on<FlowConditionAccountDataFetchEvent>(_fetchAccountList);
    on<FlowConditionCategoryDataFetchEvent>(_fetchCategoryData);
    on<FlowConditionDataUpdateEvent>(_updateCondition);
    on<FlowConditionAccountUpdateEvent>(_updateAccount);
    on<FlowConditionTimeUpdateEvent>(_updateTime);
  }

  Future<void> _fetchCategoryData(FlowConditionCategoryDataFetchEvent event, emit) async {
    var accountId = event.accountId ?? condition.accountId;
    if (_categoryCache[accountId] == null) {
      _categoryCache[accountId] = await ApiServer.getData(
        () => TransactionCategoryApi.getTree(),
        TransactionCategoryApi.dataFormatFunc.getTreeDataToList,
      );
    }
    emit(FlowConditionCategoryLoaded(_categoryCache[accountId]!));
  }

  Future<void> _fetchAccountList(FlowConditionAccountDataFetchEvent event, emit) async {
    accountList = await AccountApi.getList();
    emit(FlowConditionAccountLoaded(accountList));
  }

  Future<void> _updateCondition(FlowConditionDataUpdateEvent event, emit) async {
    var newCondition = event.condition;
    if (newCondition == condition) {
      return;
    }
    condition = newCondition;
    emit(FlowConditionUpdate(newCondition));
  }

  Future<void> _updateAccount(FlowConditionAccountUpdateEvent event, emit) async {
    if (event.account.id == condition.accountId) {
      return;
    }
    condition.accountId = event.account.id;
    currentAccount = event.account;
    await _fetchCategoryData(FlowConditionCategoryDataFetchEvent(accountId: event.account.id), emit);
    emit(FlowConditionUpdate(condition));
  }

  Future<void> _updateTime(FlowConditionTimeUpdateEvent event, emit) async {
    if (event.startTime == condition.startTime && event.endTime == event.endTime) {
      return;
    }
    condition.startTime = event.startTime;
    condition.endTime = event.endTime;
    emit(FlowConditionUpdate(condition));
  }
}
