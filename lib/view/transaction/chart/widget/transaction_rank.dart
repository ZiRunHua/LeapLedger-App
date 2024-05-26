part of 'enter.dart';

class TransactionRank extends StatelessWidget {
  const TransactionRank({super.key, required this.transLsit});
  final List<TransactionModel> transLsit;
  @override
  Widget build(BuildContext context) {
    return ExpandedView(
        children: List.generate(transLsit.length, (index) => CommonListTile.fromTransModel(transLsit[index])));
  }
}
