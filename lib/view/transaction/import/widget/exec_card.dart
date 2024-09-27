part of '../transaction_import.dart';

class ExecCard extends StatefulWidget {
  const ExecCard({super.key, required this.product, required this.categoryTree});
  final ProductModel product;
  final List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>> categoryTree;
  @override
  State<ExecCard> createState() => _ExecCardState();
}

class _ExecCardState extends State<ExecCard> {
  late final ImportCubit _cubit;
  @override
  void initState() {
    var account = BlocProvider.of<TransImportTabBloc>(context).account;
    _cubit = ImportCubit(widget.product, account: account)..fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ImportCubit>.value(
      value: _cubit,
      child: BlocListener<ImportCubit, ImportState>(
        listenWhen: (_, state) => state is FailTransProgressing,
        listener: (context, state) {
          showDialog(context: context, builder: (context) => FailDialog(_cubit));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BlocBuilder<ImportCubit, ImportState>(
              buildWhen: (_, state) => state is PtcDataLoad,
              builder: (_, state) {
                return PtcCard(
                  _cubit.ptcList,
                  categoryTree: widget.categoryTree,
                  account: _cubit.account,
                  product: _cubit.product,
                );
              },
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BlocBuilder<ImportCubit, ImportState>(
                    builder: (context, state) {
                      if (!_cubit.importing) return _buildImportButtom();
                      return SizedBox();
                    },
                  ),
                  _buildImportingCard(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildImportingCard() {
    return _Func._buildCard(
        child: BlocBuilder<ImportCubit, ImportState>(
      buildWhen: (_, state) => state is ProgressChanged || state is ImportFinished,
      builder: (context, state) {
        if (state is! Importing && state is! ImportFinished) {
          return SizedBox();
        }
        List<Widget> children = [];
        if (state is ProgressChanged || state is ImportFinished) {
          children.add(DefaultTextStyle.merge(
              style: const TextStyle(fontSize: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text.rich(TextSpan(children: [
                    TextSpan(text: "支："),
                    AmountTextSpan.sameHeight(_cubit.expenseAmount,
                        incomeExpense: IncomeExpense.expense, displayModel: IncomeExpenseDisplayModel.symbols),
                    TextSpan(text: "(${_cubit.expenseCount}笔)")
                  ])),
                  Text.rich(TextSpan(children: [
                    TextSpan(text: "收："),
                    AmountTextSpan.sameHeight(_cubit.incomseAmount,
                        incomeExpense: IncomeExpense.income, displayModel: IncomeExpenseDisplayModel.symbols),
                    TextSpan(text: "(${_cubit.incomeCount}笔)")
                  ])),
                ],
              )));
        }
        List<Widget> header = [];
        if (state is ImportFinished)
          header.add(
              Center(child: Icon(Icons.done_rounded, color: ConstantColor.primaryColor, size: Constant.iconlargeSize)));
        if (_cubit.importing) header.add(Center(child: CircularProgressIndicator()));
        if (_cubit.ignoreCount > 0) {
          header.add(Text("忽略${_cubit.ignoreCount}笔"));
        }
        return Padding(
          padding: const EdgeInsets.all(Constant.padding),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (header.length > 0)
                Padding(
                  padding: const EdgeInsets.only(bottom: Constant.margin),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: header,
                  ),
                ),
              ...children,
            ],
          ),
        );
      },
    ));
  }

  Widget _buildImportButtom() {
    return SizedBox(
      width: 250,
      child: ElevatedButton(
        style:
            ButtonStyle(shape: WidgetStateProperty.all(const StadiumBorder(side: BorderSide(style: BorderStyle.none)))),
        onPressed: () {
          _uploadBillFile(_cubit.product, context);
        },
        child: Text(
          "导入",
          style: TextStyle(
            letterSpacing: Constant.padding * 2,
            fontSize: Theme.of(context).primaryTextTheme.titleMedium!.fontSize,
          ),
        ),
      ),
    );
  }

  void _uploadBillFile(ProductModel product, BuildContext context) async {
    Throttle().call('uploadBillFile', () async {
      await FileOperation.selectFile(FileType.custom, ['xls', 'xlsx', 'csv']).then((value) {
        if (value != null) {
          _cubit.doImport(value);
        }
      });
    });
  }
}
