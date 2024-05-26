part of 'enter.dart';

class CategoryRanks {
  CategoryRanks({required List<TransactionCategoryAmountRankApiModel> data}) {
    int totalAmount = 0;
    for (var element in data) {
      totalAmount += element.amount;
    }
    this.totalAmount = totalAmount;
    this.data = List.generate(
      data.length,
      (index) => CategoryRank(data: data[index])..setAmountProportion(totalAmount),
    ).toList();
  }

  late int totalAmount;
  late List<CategoryRank> data;

  bool get isEmpty => data.isEmpty;
  bool get isNotEmpty => data.isNotEmpty;
}

class CategoryRank {
  CategoryRank({required TransactionCategoryAmountRankApiModel data}) : _data = data;
  late final TransactionCategoryAmountRankApiModel _data;

  String get name => _data.category.name;
  IconData get icon => _data.category.icon;

  int get amount => _data.amount;
  int get count => _data.count;
  late int amountProportion;
  setAmountProportion(int totalAmount) {
    amountProportion = (amount * 10000 / totalAmount).round();
  }

  String amountProportiontoString() {
    return "${(amountProportion / 100).toStringAsFixed(2)}%";
  }
}
