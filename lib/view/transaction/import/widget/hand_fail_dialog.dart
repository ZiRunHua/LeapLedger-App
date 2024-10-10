part of '../transaction_import.dart';

class HandFailDialog extends StatefulWidget {
  HandFailDialog(this.cubit);
  final ImportCubit cubit;
  @override
  _HandFailDialogState createState() => _HandFailDialogState();
}

class _HandFailDialogState extends State<HandFailDialog> {
  late final ImportCubit _cubit;

  @override
  void initState() {
    _cubit = widget.cubit;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: _cubit.currentFailTrans == null,
        child: BlocProvider.value(
          value: _cubit,
          child: AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BlocListener<ImportCubit, ImportState>(
                  listener: (context, state) {
                    if (state is ProgressingFailTransChanged)
                      setState(() {});
                    else if (state is FailTransProgressFinished) Navigator.pop(context);
                  },
                  child: _buildContent(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => _cubit.ignoreFailTrans(id: _cubit.currentId!),
                child: Text('忽略'),
              ),
              TextButton(
                onPressed: () async {
                  var page = TransactionRoutes.editNavigator(context,
                      mode: TransactionEditMode.popTrans, account: _cubit.account, transInfo: _cubit.currentFailTrans);
                  await page.push();
                  var transInfo = page.getPopTransInfo();
                  if (transInfo == null) {
                    _cubit.ignoreFailTrans(id: _cubit.currentId!);
                  }
                  _cubit.retryCreateTrans(id: _cubit.currentId!, transInfo: transInfo!);
                },
                child: Text('修改'),
              ),
            ],
          ),
        ));
  }

  Widget _buildContent() {
    if (_cubit.currentFailTrans == null) {
      return SizedBox();
    }
    final trans = _cubit.currentFailTrans!;
    final tip = _cubit.currentFailTip;
    return Padding(
      padding: EdgeInsets.all(Constant.padding),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: Constant.margin),
            child: LargeCategoryIconAndName(trans.categoryBaseModel),
          ),
          Padding(
              padding: EdgeInsets.all(Constant.margin),
              child: AmountText.sameHeight(
                trans.amount,
                textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              )),
          _buildInfoWidget(labal: "时间", content: DateFormat.yMd().add_Hms().format(trans.tradeTime)),
          _buildInfoWidget(labal: "备注", content: trans.remark.isEmpty ? "无" : trans.remark),
          if (tip != null)
            Padding(
              padding: EdgeInsets.only(top: Constant.margin),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline_rounded),
                  Expanded(
                    child: Text(
                      tip,
                      style: TextStyle(fontSize: ConstantFontSize.body),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            )
        ],
      ),
    );
  }

  Widget _buildInfoWidget({required String labal, required String content}) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(labal), Text(content)],
    );
  }
}
