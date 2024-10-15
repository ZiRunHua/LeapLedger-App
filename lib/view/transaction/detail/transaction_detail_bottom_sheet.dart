import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:leap_ledger_app/bloc/transaction/transaction_bloc.dart';
import 'package:leap_ledger_app/common/global.dart';
import 'package:leap_ledger_app/model/account/model.dart';
import 'package:leap_ledger_app/model/transaction/model.dart';
import 'package:leap_ledger_app/routes/routes.dart';
import 'package:leap_ledger_app/widget/amount/enter.dart';
import 'package:leap_ledger_app/widget/common/common.dart';

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
  TransactionModel transaction = TransactionModel.prototypeData();
  String title = "详情";
  @override
  void initState() {
    super.initState();
    if (widget.transaction == null) {
      if (widget.transactionId != null) {
        BlocProvider.of<TransactionBloc>(context).add(TransactionDataFetch(widget.account, widget.transactionId!));
      }
    } else {
      setTransactionData(widget.transaction!);
    }
  }

  void setTransactionData(TransactionModel trans) {
    transaction = trans;
    title = "${trans.incomeExpense.label}详情";
  }

  @override
  Widget build(BuildContext _) {
    Widget detailWidget;
    detailWidget = _buildDetail(transaction);

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
              children: [_buildHeader(), detailWidget, SizedBox(height: Constant.padding)],
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
        padding: EdgeInsets.all(Constant.padding),
        child: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: ConstantFontSize.largeHeadline),
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
            textStyle: TextStyle(
              fontSize: ConstantFontSize.body,
              fontWeight: FontWeight.w500,
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
        trailing: DateFormat.yMd().format(data.tradeTime),
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
      ConstantWidget.divider.list,
      _buildListTile(
        leading: "新建时间",
        trailing: DateFormat.yMd().add_Hms().format(data.createTime),
      ),
      _buildButtomButtonGroup(TransactionRouterGuard.edit(mode: TransactionEditMode.update, account: widget.account)),
    ]);
  }

  Widget _buildListTile({required String leading, String? trailing, Widget? trailingWidget}) {
    assert(trailing != null || trailingWidget != null);
    trailingWidget ??= Text(trailing!, style: TextStyle(fontSize: ConstantFontSize.body));

    return ListTile(
      leading: Text(leading, style: TextStyle(fontSize: ConstantFontSize.body)),
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
              side: WidgetStatePropertyAll<BorderSide>(BorderSide(color: ConstantColor.primaryColor)),
            ),
            child: Text(
              "删除",
              style: TextStyle(letterSpacing: Constant.buttomLetterSpacing),
            ),
          )),
      Offstage(
          offstage: false == canEdit,
          child: FilledButton(
            onPressed: _onUpdate,
            child: Text(
              "编辑",
              style: TextStyle(letterSpacing: Constant.buttomLetterSpacing),
            ),
          ))
    ]);
  }

  _handleDelete() {
    if (!transaction.isValid) {
      return;
    }
    BlocProvider.of<TransactionBloc>(context).add(TransactionDelete(widget.account, transaction));
  }

  void _onDelete() {
    CommonDialog.showDeleteConfirmationDialog(context, _handleDelete).then((bool isFinish) {
      if (isFinish) {
        Navigator.pop(context);
      }
    });
  }

  _onUpdate() async {
    var page = TransactionRoutes.editNavigator(context,
        mode: TransactionEditMode.update, account: widget.account, originalTrans: widget.transaction);
    await page.push();
    if (page.finish() && mounted) {
      Navigator.pop(context);
    }
  }

  void _onShare() {
    BlocProvider.of<TransactionBloc>(context).add(TransactionShare(transaction));
  }
}
