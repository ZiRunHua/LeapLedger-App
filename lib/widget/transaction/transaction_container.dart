part of "enter.dart";

class TransactionContainer extends StatelessWidget {
  const TransactionContainer(this.trans, {super.key});
  final TransactionInfoModel trans;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ConstantDecoration.cardDecoration,
      child: Padding(
        padding: EdgeInsets.all(Constant.padding),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(Constant.margin),
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
                    style: TextStyle(fontSize: ConstantFontSize.body, height: 1.5.sp),
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
                    padding: EdgeInsets.all(Constant.padding),
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
  const TransactionTimingContainer({
    super.key,
    required this.trans,
    required this.config,
    this.setAsh = false,
  });
  final TransactionInfoModel trans;
  final TransactionTimingModel config;
  final bool setAsh;
  @override
  Widget build(BuildContext context) {
    Widget child = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(right: Constant.margin),
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
                style: TextStyle(fontSize: ConstantFontSize.body, height: 1.5.sp),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(trans.categoryFatherName + " · " + trans.categoryName + " · " +trans.userName),
                    Text(DateFormat.yMd().format(trans.tradeTime)+ " · " +config.toDisplay())
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: Constant.margin),
                child:  Text.rich(
                    AmountTextSpan.sameHeight(
                      trans.amount,
                      textStyle: TextStyle(fontSize: ConstantFontSize.largeHeadline),
                      incomeExpense: trans.incomeExpense,
                      displayModel: IncomeExpenseDisplayModel.symbols,
                    ),
                  ),
              ),
            ],
          ),
        )
      ],
    );
    if (setAsh) {
      return ClipRRect(
        borderRadius: ConstantDecoration.borderRadius,
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(Colors.grey, BlendMode.saturation),
          child: DecoratedBox(
            decoration: BoxDecoration(color: Colors.white),
            child: Padding(
              padding: EdgeInsets.all(Constant.padding),
              child: child,
            ),
          ),
        ),
      );
    }
    return DecoratedBox(
      decoration: ConstantDecoration.cardDecoration,
      child: Padding(
        padding: EdgeInsets.all(Constant.padding),
        child: child,
      ),
    );
  }
}
