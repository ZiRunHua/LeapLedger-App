part of 'enter.dart';

class AccountTotal extends StatelessWidget {
  final IncomeExpenseStatisticApiModel todayTransTotal, monthTransTotal;
  const AccountTotal({super.key, required this.todayTransTotal, required this.monthTransTotal});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        _buildTotal(Icons.today_outlined, "今日", todayTransTotal),
        _buildTotal(Icons.calendar_month_outlined, "本月", monthTransTotal),
      ],
    );
  }

  Widget _buildTotal(IconData icon, String text, IncomeExpenseStatisticApiModel data) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(Constant.padding),
        margin: const EdgeInsets.all(Constant.margin),
        decoration: const BoxDecoration(borderRadius: ConstantDecoration.borderRadius, color: Colors.white),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Icon(icon, size: 36, color: ConstantColor.primaryColor),
                Text(
                  text,
                  style: const TextStyle(
                      fontSize: ConstantFontSize.body,
                      color: ConstantColor.greyText,
                      letterSpacing: ConstantFontSize.letterSpacing),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                      style: const TextStyle(
                          fontSize: ConstantFontSize.largeHeadline,
                          fontWeight: FontWeight.bold,
                          color: ConstantColor.expenseAmount),
                      children: [
                        AmountTextSpan.sameHeight(data.expense.amount,
                            dollarSign: false,
                            displayModel: IncomeExpenseDisplayModel.color,
                            incomeExpense: IncomeExpense.expense),
                        const TextSpan(
                          text: "  支",
                          style: TextStyle(
                              fontSize: ConstantFontSize.body,
                              color: ConstantColor.greyText,
                              fontWeight: FontWeight.normal),
                        ),
                      ]),
                ),
                const SizedBox(height: Constant.margin / 2),
                Text.rich(
                  TextSpan(
                      style: const TextStyle(
                          fontSize: ConstantFontSize.largeHeadline,
                          fontWeight: FontWeight.bold,
                          color: ConstantColor.incomeAmount),
                      children: [
                        AmountTextSpan.sameHeight(data.income.amount,
                            dollarSign: false,
                            displayModel: IncomeExpenseDisplayModel.color,
                            incomeExpense: IncomeExpense.income),
                        const TextSpan(
                          text: "  收",
                          style: TextStyle(
                              fontSize: ConstantFontSize.body,
                              color: ConstantColor.greyText,
                              fontWeight: FontWeight.normal),
                        ),
                      ]),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
