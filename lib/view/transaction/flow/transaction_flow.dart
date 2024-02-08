import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:keepaccount_app/api/model/model.dart';
import 'package:keepaccount_app/bloc/transaction/transaction_bloc.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/model/account/model.dart';
import 'package:keepaccount_app/model/transaction/category/model.dart';
import 'package:keepaccount_app/model/transaction/model.dart';
import 'package:keepaccount_app/routes/routes.dart';
import 'package:keepaccount_app/util/enter.dart';
import 'package:keepaccount_app/view/transaction/flow/bloc/enter.dart';
import 'package:keepaccount_app/view/transaction/flow/widget/enter.dart';
import 'package:keepaccount_app/widget/amount/enter.dart';
import 'package:shimmer/shimmer.dart';

class TransactionFlow extends StatelessWidget {
  final TransactionQueryConditionApiModel? condition;
  final AccountModel? account;
  const TransactionFlow({this.condition, this.account, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<FlowListBloc>(create: (context) => FlowListBloc()),
      BlocProvider<FlowConditionBloc>(
          create: (context) => FlowConditionBloc(condition: condition, currentAccount: account)),
    ], child: _TransactionFlow(condition: condition, account: account));
  }
}

class _TransactionFlow extends StatefulWidget {
  final TransactionQueryConditionApiModel? condition;
  final AccountModel? account;
  const _TransactionFlow({this.condition, this.account, super.key});

  @override
  State<_TransactionFlow> createState() => _TransactionFlowState();
}

enum PageStatus { loading, loaded, refreshing, moreDataFetching, noMoreData }

class _TransactionFlowState extends State<_TransactionFlow> {
  late final FlowConditionBloc conditionBloc;
  late final FlowListBloc flowListBloc;
  PageStatus currentState = PageStatus.loading;
  late final ScrollController _scrollController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    flowListBloc = BlocProvider.of<FlowListBloc>(context);
    conditionBloc = BlocProvider.of<FlowConditionBloc>(context);
    flowListBloc.add(FlowListDataFetchEvent(conditionBloc.condition));
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _onFetchMoreData();
      }
    });
    data = shimmerData;
  }

  @override
  void dispose() {
    flowListBloc.close();
    conditionBloc.close();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    flowListBloc.add(FlowListDataFetchEvent(conditionBloc.condition));
    _changeState(PageStatus.refreshing);
  }

  void _onFetchMoreData() {
    if (currentState != PageStatus.noMoreData) {
      flowListBloc.add(FlowListMoreDataFetchEvent());
      _changeState(PageStatus.moreDataFetching);
    }
  }

  void _changeState(PageStatus status) {
    setState(() {
      currentState = status;
    });
  }

  Map<IncomeExpenseStatisticWithTimeApiModel, List<TransactionModel>> data = {};

  Widget listener(Widget child) {
    // 列表bloc
    child = BlocListener<FlowListBloc, FlowListState>(
      listener: (context, state) {
        if (state is FlowListLoading) {
          data = shimmerData;
          _changeState(PageStatus.loading);
        } else if (state is FlowListLoaded) {
          data = state.data;
          if (false == state.hasMore) {
            _changeState(PageStatus.noMoreData);
          } else {
            _changeState(PageStatus.loaded);
          }
        } else if (state is FlowListMoreDataFetched) {
          data = state.data;
          if (false == state.hasMore) {
            _changeState(PageStatus.noMoreData);
          } else {
            _changeState(PageStatus.loaded);
          }
        }
      },
      child: child,
    );
    // 条件bloc
    child = BlocListener<FlowConditionBloc, FlowConditionState>(
      listener: (context, state) {
        if (state is FlowConditionUpdate) {
          flowListBloc.add(FlowListDataFetchEvent(state.condition));
        }
      },
      child: child,
    );
    // 交易bloc
    child = BlocListener<TransactionBloc, TransactionState>(
      listener: (context, state) {
        print(state);
        if (state is TransactionAddSuccess) {
          flowListBloc.add(FlowListTransactionAddEvent(state.trans));
        } else if (state is TransactionUpdateSuccess) {
          flowListBloc.add(FlowListTransactionUpdateEvent(state.oldTrans, state.newTrans));
        } else if (state is TransactionDeleteSuccess) {
          flowListBloc.add(FlowListTransactionDeleteEvent(state.delTrans));
        }
      },
      child: child,
    );
    return child;
  }

  @override
  Widget build(BuildContext context) {
    return listener(
      Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text("流水"),
          actions: _buildActions(),
        ),
        backgroundColor: Colors.grey.shade200,
        body: RefreshIndicator(
            onRefresh: _onRefresh,
            child: NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollEndNotification && _scrollController.position.extentAfter == 0) {
                    _onFetchMoreData();
                  }
                  return false;
                },
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    const SliverToBoxAdapter(
                      child: HeaderCard(),
                    ),
                    ...buildMonthStatisticGroupList()
                  ],
                ))),

        /// 获取更多 加载中
        bottomNavigationBar: Visibility(
          visible: currentState == PageStatus.moreDataFetching,
          child: Container(
            height: 64,
            alignment: Alignment.center,
            child: const CupertinoActivityIndicator(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildActions() {
    return [
      BlocProvider.value(
        value: conditionBloc,
        child: const AccountListBottomSheet(),
      ),
      const SizedBox(
        width: Constant.margin,
      ),
      Builder(builder: (context) {
        return TextButton(
          style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.white)),
          onPressed: () {
            showModalBottomSheet(
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return BlocProvider.value(
                    value: conditionBloc,
                    child: const ConditionBottomSheet(),
                  );
                });
          },
          child: const Row(
            children: [Text("筛选"), Icon(Icons.filter_alt_outlined)],
          ),
        );
      })
    ];
  }

  List<Widget> buildMonthStatisticGroupList() {
    List<SliverMainAxisGroup> result = [];
    print(data);
    data.forEach((key, value) {
      if (value.isNotEmpty) {
        result.add(buildMonthStatisticGroup(key, value));
      }
    });
    print(result);
    if (result.isEmpty) {
      return [
        SliverToBoxAdapter(
          child: Center(child: TransactionRoutes.getNoDataRichText(context)),
        ),
      ];
    }
    return result;
  }

  /// 月统计和交易列表
  SliverMainAxisGroup buildMonthStatisticGroup(
      IncomeExpenseStatisticWithTimeApiModel apiModel, List<TransactionModel> list) {
    final fonstScale = MediaQuery.of(context).textScaler.scale(MonthStatisticHeaderDelegate.baseFontHeight);
    return SliverMainAxisGroup(slivers: [
      SliverPersistentHeader(
        pinned: true,
        delegate: MonthStatisticHeaderDelegate(apiModel, fonstScale),
      ),
      _buildSliverList(list),
    ]);
  }

  TransactionModel? lastTrans, currentTrans;

  /// 交易列表
  Widget _buildSliverList(List<TransactionModel> list) {
    return SliverPadding(
      padding: const EdgeInsets.only(bottom: Constant.margin),
      sliver: DecoratedSliver(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(Constant.radius), bottomRight: Radius.circular(Constant.radius))),
        sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
          (_, int index) {
            if (index % 2 == 1) {
              return _buildShimmer(_buildListTile(list[index ~/ 2]));
            } else {
              lastTrans = currentTrans;
              currentTrans = list[(index + 1) ~/ 2];
              return _buildShimmer(_buildDivider());
            }
          },
          childCount: list.length * 2,
        )),
      ),
    );
  }

  /// 单条交易
  Widget _buildListTile(TransactionModel model) {
    return ListTile(
      onTap: () =>
          TransactionRoutes.pushDetailBottomSheet(context, account: conditionBloc.currentAccount, transaction: model),
      dense: true,
      titleAlignment: ListTileTitleAlignment.center,
      leading: Icon(model.categoryIcon),
      title: Text(
        model.categoryName,
      ),
      subtitle: Text("${model.categoryFatherName}  ${DateFormat('HH:mm:ss').format(model.tradeTime)}"),
      trailing: SameHightAmount(
        amount: model.amount,
        incomeExpense: model.incomeExpense,
        textStyle: const TextStyle(fontSize: 18, color: Colors.black),
        displayModel: IncomeExpenseDisplayModel.symbols,
      ),
    );
  }

  /// 列表分割线
  Widget _buildDivider() {
    if (currentTrans != null &&
        lastTrans != null &&
        Time.isSameDayComparison(currentTrans!.tradeTime, lastTrans!.tradeTime)) {
      return ConstantWidget.divider.list;
    } else {
      return Padding(
          padding: const EdgeInsets.only(left: Constant.padding),
          child: currentTrans != null
              ? Text(DateFormat("dd日").format(currentTrans!.tradeTime))
              : ConstantWidget.divider.list);
    }
  }

  /// Shimmer
  final List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>> categoryShimmerData = [];
  final Map<IncomeExpenseStatisticWithTimeApiModel, List<TransactionModel>> shimmerData = {
    IncomeExpenseStatisticWithTimeApiModel(startTime: Time.getLastMonth(), endTime: Time.getLastMonth()): [
      TransactionModel.fromJson({}),
      TransactionModel.fromJson({}),
      TransactionModel.fromJson({}),
      TransactionModel.fromJson({})
    ],
    IncomeExpenseStatisticWithTimeApiModel(
      startTime: Time.getFirstSecondOfPreviousMonths(numberOfMonths: 1),
      endTime: Time.getFirstSecondOfPreviousMonths(numberOfMonths: 1),
    ): [
      TransactionModel.fromJson({}),
      TransactionModel.fromJson({}),
      TransactionModel.fromJson({}),
      TransactionModel.fromJson({})
    ]
  };
  Widget _buildShimmer(Widget child) {
    if (currentState != PageStatus.loading && currentState != PageStatus.refreshing) {
      return child;
    }
    return Shimmer.fromColors(
      baseColor: ConstantColor.shimmerBaseColor,
      highlightColor: ConstantColor.shimmerHighlightColor,
      child: child,
    );
  }
}
