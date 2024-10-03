import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leap_ledger_app/common/global.dart';
import 'package:leap_ledger_app/model/account/model.dart';
import 'package:leap_ledger_app/model/transaction/model.dart';
import 'package:leap_ledger_app/routes/routes.dart';
import 'package:leap_ledger_app/view/transaction/timing/cubit/transaction_timing_cubit.dart';
import 'package:leap_ledger_app/widget/transaction/enter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TransactionTimingList extends StatefulWidget {
  const TransactionTimingList({super.key, required this.account});
  final AccountDetailModel account;
  @override
  State<TransactionTimingList> createState() => _TransactionTimingListState();
}

class _TransactionTimingListState extends State<TransactionTimingList> {
  late final TransactionTimingCubit _cubit;

  @override
  void initState() {
    _cubit = TransactionTimingCubit(account: widget.account)..loadList();
    super.initState();
  }

  @override
  void dispose() {
    _cubit.close();
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
              child: IconButton(onPressed: onTapAdd, icon: Icon(ConstantIcon.add)),
            )
          ],
        ),
        backgroundColor: ConstantColor.greyBackground,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Constant.padding),
          child: BlocBuilder<TransactionTimingCubit, TransactionTimingState>(
            buildWhen: (context, state) => state is TransactionTimingListLoaded,
            builder: (context, state) {
              if (state is TransactionTimingListLoaded && _cubit.list.isNotEmpty) {
                return ListView.builder(
                  itemCount: _cubit.list.length,
                  itemBuilder: (context, index) => _buildListOne(_cubit.list[index]),
                );
              } else {
                return SizedBox(height: 64, child: Center(child: NoData.commonWidget));
              }
            },
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
    return Padding(
      padding: const EdgeInsets.only(top: Constant.margin),
      child: Slidable(
          key: Key("trans_config_slidable:" + record.config.id.toString()),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              record.config.close
                  ? _buildBotton(
                      name: "开启",
                      color: Colors.blue,
                      icon: Icons.start_rounded,
                      onTap: () => _cubit.openeTiming(record.config))
                  : _buildBotton(
                      name: "关闭",
                      color: Colors.blue,
                      icon: Icons.close_rounded,
                      onTap: () => _cubit.closeTiming(record.config)),
              _buildBotton(
                  name: "删除",
                  color: Colors.red,
                  icon: Icons.delete_outline_outlined,
                  onTap: () => _cubit.deleteTiming(record.config)),
            ],
          ),
          child: GestureDetector(
            onTap: () => TransactionRoutes.timingNavigator(
              context,
              account: _cubit.account,
              trans: record.trans,
              config: record.config,
              cubit: _cubit,
            ).push(),
            child: TransactionTimingContainer(
              trans: record.trans,
              config: record.config,
              setAsh: record.config.close,
            ),
          )),
    );
  }

  SlidableAction _buildBotton(
      {required Color color, required IconData icon, required String name, required VoidCallback onTap}) {
    return SlidableAction(
      onPressed: (context) => onTap(),
      backgroundColor: color,
      foregroundColor: Colors.white,
      icon: icon,
      label: name,
    );
  }
}
