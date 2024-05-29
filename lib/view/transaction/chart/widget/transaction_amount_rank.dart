part of 'enter.dart';

class TransactionAmountRank extends StatelessWidget {
  const TransactionAmountRank({super.key, required this.transLsit});
  final List<TransactionModel> transLsit;
  @override
  Widget build(BuildContext context) {
    return CommonExpandedView(
        children: List.generate(
      transLsit.length,
      (index) => CommonListTile.fromTransModel(transLsit[index]),
    ));
  }
}
