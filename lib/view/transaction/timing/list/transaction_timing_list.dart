import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/model/account/model.dart';
import 'package:keepaccount_app/model/transaction/model.dart';
import 'package:keepaccount_app/routes/routes.dart';
import 'package:keepaccount_app/view/transaction/timing/cubit/transaction_timing_cubit.dart';
import 'package:keepaccount_app/widget/common/common.dart';
import 'package:keepaccount_app/widget/transaction/enter.dart';

class TransactionTimingList extends StatefulWidget {
  const TransactionTimingList({super.key, required this.account});
  final AccountDetailModel account;
  @override
  State<TransactionTimingList> createState() => _TransactionTimingListState();
}

class _TransactionTimingListState extends State<TransactionTimingList> {
  late final TransactionTimingCubit _cubit;
  late final CommonPageController<({TransactionInfoModel trans, TransactionTimingModel config})> _pageController;
  @override
  void initState() {
    _cubit = TransactionTimingCubit(account: widget.account);
    _pageController = CommonPageController<({TransactionInfoModel trans, TransactionTimingModel config})>(
      refreshListener: _cubit.loadList,
      loadMoreListener: _cubit.loadList,
    );

    super.initState();
  }

  @override
  void didUpdateWidget(covariant TransactionTimingList oldWidget) {
    _pageController.refresh();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text("交易定时"),
          actions: [
            Visibility(
                visible: _cubit.canEdit,
                child: IconButton(
                  onPressed: onTapAdd,
                  icon: Icon(ConstantIcon.add),
                ))
          ],
        ),
        backgroundColor: ConstantColor.greyBackground,
        body: BlocListener<TransactionTimingCubit, TransactionTimingState>(
          listener: (context, state) {
            if (state is TransactionTimingListLoaded && state.isCurrent(_cubit.account)) {
              _pageController.addListData(state.list);
            } else if (state is TransactionTimingConfigSaved && state.isCurrent(_cubit.account)) {
              var result =
                  _pageController.updateListItemWhere((item) => item.config.id == state.config.id, state.record);
              if (!result) _pageController.addNewItemInHeader(state.record);
            }
          },
          child: CommonPageList<({TransactionInfoModel trans, TransactionTimingModel config})>(
            buildListOne: _buildListOne,
            prototypeData: (
              trans: TransactionInfoModel.prototypeData(),
              config: TransactionTimingModel.prototypeData()
            ),
            initRefresh: true,
            controller: _pageController,
          ),
        ),
      ),
    );
  }

  onTapAdd() async {
    var page = TransactionRoutes.editNavigator(context, mode: TransactionEditMode.popTrans, account: _cubit.account);
    await page.push();
    var transInfo = page.getPopTransInfo();
    if (transInfo == null) return;
    TransactionRoutes.timingNavigator(context, account: _cubit.account, trans: transInfo, cubit: _cubit).push();
  }

  Widget _buildListOne(({TransactionInfoModel trans, TransactionTimingModel config}) record) {
    return GestureDetector(
      onTap: () => TransactionRoutes.timingNavigator(
        context,
        account: _cubit.account,
        trans: record.trans,
        config: record.config,
        cubit: _cubit,
      ).push(),
      child: Padding(
        padding: const EdgeInsets.only(top: Constant.margin),
        child: TransactionTimingContainer(trans: record.trans, config: record.config),
      ),
    );
  }
}
