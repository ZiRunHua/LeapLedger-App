part of 'enter.dart';

class CategoryRankingList {
  CategoryRankingList({required List<TransactionCategoryAmountRankApiModel> data}) {
    data = data.where((e) => e.amount > 0).toList();
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
  CategoryRankingList.empty({int amount = 1})
      : this(data: [
          TransactionCategoryAmountRankApiModel(
            amount: amount,
            count: 0,
            category: TransactionCategoryModel.prototypeData(),
          ),
        ]);
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
    amountProportion = amount == 0 ? 0 : (amount * 10000 / totalAmount).round();
  }

  String amountProportiontoString() {
    return "${(amountProportion / 100).toStringAsFixed(2)}%";
  }

  factory CategoryRank.empty({int amount = 1}) {
    var rank = CategoryRank(
        data: TransactionCategoryAmountRankApiModel(
      amount: amount,
      count: 1,
      category: TransactionCategoryModel.prototypeData(),
    ));
    return rank;
  }
}
