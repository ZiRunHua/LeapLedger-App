part of 'enter.dart';

class FlowListBloc extends Bloc<FlowListEvent, FlowListState> {
  FlowListBloc() : super(FlowListLoading()) {
    on<FlowListDataFetchEvent>(_fetchData);
    on<FlowListMoreDataFetchEvent>(_fetchMoreData);

    on<FlowListTransactionAddEvent>(_addTrans);
    on<FlowListTransactionUpdateEvent>(_updateTrans);
    on<FlowListTransactionDeleteEvent>(_deleteTrans);
  }

  /// 月统计
  List<IncomeExpenseStatisticWithTimeApiModel> monthStatistic = [];

  /// 列表
  Map<IncomeExpenseStatisticWithTimeApiModel, List<TransactionModel>> list = {};

  /// 合计数据
  IncomeExpenseStatisticApiModel total = IncomeExpenseStatisticApiModel();

  /// 条件
  TransactionQueryConditionApiModel condition = TransactionQueryConditionApiModel(
      accountId: UserBloc.currentAccount.id,
      startTime: DateTime(DateTime.now().year, DateTime.now().month - 6),
      endTime: DateTime.now());
  bool hasMore = true;
  int offset = 0, limit = 10;
  _initList() {
    list = {};
    for (var element in monthStatistic) {
      list[element] = [];
    }
  }

  _fetchData(FlowListDataFetchEvent event, emit) async {
    emit(FlowListLoading());
    condition = event.condition;
    offset = 0;
    List<TransactionModel> result = [];
    await Future.wait([
      Future(() async {
        monthStatistic = await TransactionApi.getMonthStatistic(condition);
      }),
      Future(() async {
        result = await TransactionApi.getList(condition, limit, offset);
      })
    ]);
    // 处理列表数据
    offset = result.length;
    _initList();
    for (var element in result) {
      _setListData(element);
    }
    bool hasMore = list.isNotEmpty;
    emit(FlowListLoaded(list, hasMore));
    // 处理合计数据
    total = IncomeExpenseStatisticApiModel();
    if (monthStatistic.isNotEmpty) {
      for (var element in monthStatistic) {
        total.income.add(element.income);
        total.expense.add(element.expense);
      }
    }
    emit(FlowListTotalDataFetched(total));
  }

  _setListData(TransactionModel data) {
    var key = list.keys.firstWhere((element) {
      bool notInThisMonth = data.tradeTime.isBefore(element.startTime) || element.endTime.isBefore(data.tradeTime);
      return false == notInThisMonth;
    }, orElse: () {
      return IncomeExpenseStatisticWithTimeApiModel(
          expense: AmountCountApiModel(0, 0),
          income: AmountCountApiModel(0, 0),
          startTime: DateTime.now(),
          endTime: DateTime.now());
    });
    if (list[key] == null) {
      return;
    }
    list[key]!.add(data);
  }

  _fetchMoreData(FlowListMoreDataFetchEvent event, emit) async {
    var result = await TransactionApi.getList(condition, limit, offset);
    offset += result.length;
    hasMore = result.isNotEmpty;
    for (var element in result) {
      _setListData(element);
    }
    emit(FlowListMoreDataFetched(list, hasMore));
  }

  /* 单笔交易处理 */

  _addTrans(FlowListTransactionAddEvent event, emit) {
    if (false == condition.checkTrans(event.trans)) {
      return;
    }
    _handleTransAdd(event.trans, emit);
  }

  _deleteTrans(FlowListTransactionDeleteEvent event, emit) {
    if (false == condition.checkTrans(event.trans)) {
      return;
    }
    _handleTransDel(event.trans, emit);
  }

  _updateTrans(FlowListTransactionUpdateEvent event, emit) {
    _deleteTrans(FlowListTransactionDeleteEvent(event.oldTrans), emit);
    _addTrans(FlowListTransactionAddEvent(event.newTrans), emit);
  }

  _handleTransAdd(TransactionModel trans, emit) {
    _handleTransInTotal(trans, emit, isAdd: true);
    var editModel = trans.editModel;
    bool needToUpdate = false;
    IncomeExpenseStatisticWithTimeApiModel? statistic;
    for (var element in monthStatistic) {
      if (true == element.handleTransEditModel(editModel: editModel, isAdd: true)) {
        statistic = element;
      }
    }
    if (statistic == null) {
      return needToUpdate;
    }
    if (list[statistic] == null) {
      list[statistic] = [trans];
    } else {
      var index = list[statistic]!.indexWhere((element) {
        return element.tradeTime.isBefore(editModel.tradeTime);
      });
      if (index >= 0) {
        list[statistic]!.insert(index, trans);
      } else {
        list[statistic]!.add(trans);
      }
    }
    needToUpdate = true;
    emit(FlowListLoaded(list, hasMore));
    return needToUpdate;
  }

  _handleTransDel(TransactionModel trans, emit) {
    _handleTransInTotal(trans, emit, isAdd: false);
    var editModel = trans.editModel;
    bool needToUpdate = false;
    IncomeExpenseStatisticWithTimeApiModel? statistic;
    for (var element in monthStatistic) {
      if (true == element.handleTransEditModel(editModel: editModel, isAdd: false)) {
        statistic = element;
      }
    }
    if (statistic != null) {
      needToUpdate = true;
      if (list[statistic] != null) {
        list[statistic]!.removeWhere((element) => element.id == trans.id);
      }
      emit(FlowListLoaded(list, hasMore));
    }
    return needToUpdate;
  }

  _handleTransInTotal(TransactionModel trans, emit, {bool isAdd = true}) {
    if (total.handleTransEditModel(trans: trans.editModel, isAdd: isAdd)) {
      emit(FlowListTotalDataFetched(total));
    }
  }
}
