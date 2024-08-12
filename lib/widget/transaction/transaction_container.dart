part of "enter.dart";

class TransactionContainer extends StatelessWidget {
  const TransactionContainer(this.trans, {super.key});
  final TransactionInfoModel trans;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ConstantDecoration.cardDecoration,
      child: Padding(
        padding: const EdgeInsets.all(Constant.padding),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(Constant.padding),
              child: Icon(
                trans.categoryIcon,
                color: ConstantColor.primaryColor,
                size: Constant.iconlargeSize,
              ),
            ),
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DefaultTextStyle.merge(
                    style: TextStyle(fontSize: ConstantFontSize.body, height: 1.5),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(trans.categoryFatherName + " · " + trans.categoryName),
                        Text(trans.userName + " · " + DateFormat('yyyy-MM-dd').format(trans.tradeTime))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(Constant.padding),
                    child: Text.rich(
                      AmountTextSpan.sameHeight(
                        trans.amount,
                        textStyle: TextStyle(
                          fontSize: ConstantFontSize.largeHeadline,
                        ),
                        incomeExpense: trans.incomeExpense,
                        displayModel: IncomeExpenseDisplayModel.symbols,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TransactionTimingContainer extends StatelessWidget {
  const TransactionTimingContainer({super.key, required this.trans, required this.config});
  final TransactionInfoModel trans;
  final TransactionTimingModel config;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ConstantDecoration.cardDecoration,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Constant.margin, horizontal: Constant.margin),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(Constant.padding),
              child: Icon(
                trans.categoryIcon,
                color: ConstantColor.primaryColor,
                size: Constant.iconlargeSize,
              ),
            ),
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DefaultTextStyle.merge(
                    style: TextStyle(fontSize: ConstantFontSize.body, height: 1.5),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(trans.categoryFatherName + " · " + trans.categoryName),
                        Text(trans.userName + " · " + DateFormat('yyyy-MM-dd').format(trans.tradeTime))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(Constant.margin),
                    child: Text.rich(
                      AmountTextSpan.sameHeight(
                        trans.amount,
                        textStyle: TextStyle(
                          fontSize: ConstantFontSize.largeHeadline,
                        ),
                        incomeExpense: trans.incomeExpense,
                        displayModel: IncomeExpenseDisplayModel.symbols,
                      ),
                    ),
                  ),
                  _buildTailing()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTailing() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const VerticalDivider(color: ConstantColor.greyText, width: Constant.margin, thickness: 1),
        Center(
          child: SizedBox(width: 64, child: Text(config.toDisplay(), textAlign: TextAlign.center)),
        )
      ],
    );
  }
}
