part of '../transaction_import.dart';

class FailDialog extends StatefulWidget {
  FailDialog(this.cubit);
  final ImportCubit cubit;
  @override
  _FailDialogState createState() => _FailDialogState();
}

class _FailDialogState extends State<FailDialog> {
  late final ImportCubit _cubit;

  @override
  void initState() {
    _cubit = widget.cubit;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
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
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 200),
                child: _buildContent(),
              ),
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
    );
  }

  Widget _buildContent() {
    if (_cubit.currentFailTrans == null) {
      return SizedBox();
    }
    final trans = _cubit.currentFailTrans!;
    final tip = _cubit.currentFailTip;
    return Padding(
      padding: const EdgeInsets.all(Constant.padding),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: Constant.margin),
            child: LargeCategoryIconAndName(trans.categoryBaseModel),
          ),
          Padding(
              padding: const EdgeInsets.all(Constant.margin),
              child: AmountText.sameHeight(
                trans.amount,
                textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              )),
          _buildInfoWidget(labal: "时间", content: DateFormat.yMd().add_Hms().format(trans.tradeTime)),
          _buildInfoWidget(labal: "备注", content: trans.remark.isEmpty ? "无" : trans.remark),
          if (tip != null)
            Padding(
              padding: const EdgeInsets.only(top: Constant.margin),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline_rounded),
                  Text(
                    tip,
                    style: TextStyle(fontSize: ConstantFontSize.bodyLarge),
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
