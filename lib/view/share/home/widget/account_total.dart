part of 'enter.dart';

class AccountTotal extends StatelessWidget {
  final InExStatisticModel todayTransTotal, monthTransTotal;
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

  Widget _buildTotal(IconData icon, String text, InExStatisticModel data) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(Constant.padding),
        margin: const EdgeInsets.all(Constant.margin),
        decoration: const BoxDecoration(borderRadius: ConstantDecoration.borderRadius, color: Colors.white),
        child: Row(
          mainAxisSize: MainAxisSize.max,
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
                    letterSpacing: ConstantFontSize.letterSpacing,
                  ),
                ),
              ],
            ),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildAmount(data.expense.amount, IncomeExpense.expense),
                        const SizedBox(height: Constant.margin / 2),
                        _buildAmount(data.income.amount, IncomeExpense.income),
                      ],
                    ),
                    _buildIe()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmount(int amount, IncomeExpense ie) {
    return AmountText.sameHeight(
      amount,
      textStyle: TextStyle(
        fontSize: ConstantFontSize.largeHeadline,
        fontWeight: FontWeight.w500,
      ),
      dollarSign: false,
      displayModel: IncomeExpenseDisplayModel.color,
      incomeExpense: ie,
    );
  }

  Widget _buildIe() {
    return const Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "  支",
          style: TextStyle(
            fontSize: ConstantFontSize.body,
            color: ConstantColor.greyText,
            fontWeight: FontWeight.normal,
          ),
        ),
        SizedBox(height: Constant.margin / 2),
        Text(
          "  收",
          style: TextStyle(
            fontSize: ConstantFontSize.body,
            color: ConstantColor.greyText,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
