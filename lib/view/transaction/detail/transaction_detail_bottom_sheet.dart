import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:keepaccount_app/bloc/transaction/transaction_bloc.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/model/account/model.dart';
import 'package:keepaccount_app/model/transaction/model.dart';
import 'package:keepaccount_app/routes/routes.dart';
import 'package:keepaccount_app/widget/amount/enter.dart';
import 'package:keepaccount_app/widget/common/common.dart';

class TransactionDetailBottomSheet extends StatefulWidget {
  const TransactionDetailBottomSheet({required this.account, this.transaction, this.transactionId, super.key})
      : assert(transaction != null || transactionId != null);
  final TransactionModel? transaction;
  final int? transactionId;
  final AccountDetailModel account;
  @override
  State<TransactionDetailBottomSheet> createState() => _TransactionDetailBottomSheetState();
}

class _TransactionDetailBottomSheetState extends State<TransactionDetailBottomSheet> {
  TransactionModel? transaction = TransactionModel();
  String title = "详情";
  @override
  void initState() {
    if (widget.transaction == null) {
      if (widget.transactionId != null) {
        BlocProvider.of<TransactionBloc>(context).add(TransactionDataFetch(widget.account, widget.transactionId!));
      }
    } else {
      setTransactionData(widget.transaction!);
    }
    super.initState();
  }

  void setTransactionData(TransactionModel trans) {
    transaction = trans;
    title = "${trans.incomeExpense.label}详情";
  }

  @override
  Widget build(BuildContext _) {
    Widget detailWidget;
    if (transaction != null) {
      detailWidget = _buildDetail(transaction!);
    } else {
      detailWidget = const Center(child: Center(child: CircularProgressIndicator()));
    }

    return BlocListener<TransactionBloc, TransactionState>(
      listener: (context, state) {
        if (state is TransactionLoaded) {
          setState(() {
            setTransactionData(state.transaction);
          });
        } else if (state is TransactionShareLoaded) {
          TransactionRoutes.showShareDialog(context, shareModel: state.shareModel);
        }
      },
      child: Container(
          decoration: ConstantDecoration.bottomSheet,
          child: Stack(children: [
            Positioned(
              top: Constant.margin,
              right: Constant.margin,
              child: _buildHeaderButtonGroup(),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [_buildHeader(), detailWidget, const SizedBox(height: Constant.padding)],
            ),
          ])),
    );
  }

  Widget _buildHeaderButtonGroup() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.share_outlined),
          onPressed: _onShare,
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Constant.padding),
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: ConstantFontSize.largeHeadline),
        ),
      ),
    );
  }

  Widget _buildDetail(TransactionModel data) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      _buildListTile(
          leading: "金额",
          trailingWidget: AmountText.sameHeight(
            data.amount,
            textStyle: const TextStyle(
              fontSize: ConstantFontSize.body,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          )),
      ConstantWidget.divider.list,
      _buildListTile(
        leading: "分类",
        trailing: data.categoryName,
      ),
      ConstantWidget.divider.list,
      _buildListTile(
        leading: "时间",
        trailing: DateFormat("yyyy-MM-dd").format(data.tradeTime),
      ),
      ConstantWidget.divider.list,
      _buildListTile(
        leading: "账本",
        trailing: data.accountName,
      ),
      ConstantWidget.divider.list,
      _buildListTile(
        leading: "备注",
        trailing: data.remark.isEmpty ? "无" : data.remark,
      ),
      _buildButtomButtonGroup(TransactionRouterGuard.edit(mode: TransactionEditMode.update, account: widget.account)),
    ]);
  }

  Widget _buildListTile({required String leading, String? trailing, Widget? trailingWidget}) {
    assert(trailing != null || trailingWidget != null);
    trailingWidget ??= Text(trailing!, style: const TextStyle(fontSize: ConstantFontSize.body));

    return ListTile(
      leading: Text(leading, style: const TextStyle(fontSize: ConstantFontSize.body)),
      trailing: trailingWidget,
    );
  }

  Widget _buildButtomButtonGroup(bool canEdit) {
    return Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Offstage(
          offstage: false == canEdit,
          child: OutlinedButton(
            onPressed: _onDelete,
            style: const ButtonStyle(
              side: MaterialStatePropertyAll<BorderSide>(BorderSide(color: ConstantColor.primaryColor)),
            ),
            child: const Text(
              "删除",
              style: TextStyle(letterSpacing: Constant.buttomLetterSpacing),
            ),
          )),
      Offstage(
          offstage: false == canEdit,
          child: FilledButton(
            onPressed: _onUpdate,
            child: const Text(
              "编辑",
              style: TextStyle(letterSpacing: Constant.buttomLetterSpacing),
            ),
          ))
    ]);
  }

  handleDelete() {
    if (transaction == null) {
      return;
    }
    BlocProvider.of<TransactionBloc>(context).add(TransactionDelete(widget.account, transaction!));
    Navigator.pop(context);
  }

  void _onDelete() {
    CommonDialog.showDeleteConfirmationDialog(context, handleDelete).then((bool isFinish) {
      if (isFinish) {
        Navigator.pop(context);
      }
    });
  }

  _onUpdate() async {
    var page = TransactionRoutes.editNavigator(context,
        mode: TransactionEditMode.update, account: widget.account, transaction: widget.transaction);
    await page.push();
    if (page.getReturn() && mounted) {
      Navigator.pop(context);
    }
  }

  void _onShare() {
    if (transaction != null) {
      BlocProvider.of<TransactionBloc>(context).add(TransactionShare(transaction!));
    }
  }
}
