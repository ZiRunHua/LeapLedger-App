part of 'enter.dart';

class TransactionListTile extends CommonListTile {
  final TransactionModel trans;
  final Key? key;
  final bool displayUser;
  final bool displayTime;
  final VoidCallback? onTap;
  final IncomeExpenseDisplayModel? displayModel;
  TransactionListTile(this.trans,
      {required this.key,
      required this.onTap,
      this.displayModel = IncomeExpenseDisplayModel.symbols,
      this.displayTime = true,
      this.displayUser = false})
      : super.fromTransModel(trans,
            key: key, onTap: onTap, displayModel: displayModel, displayTime: displayTime, displayUser: displayUser);
}
