part of '../transaction_category_mapping.dart';

class HeaderCard extends StatelessWidget {
  const HeaderCard(this.data, {super.key});
  final List<ProductTransactionCategoryModel> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
      margin: EdgeInsets.zero,
      child: GridView.builder(
          shrinkWrap: true, // 让网格视图适应内容大小
          physics: const NeverScrollableScrollPhysics(), // 禁止滚动
          padding: EdgeInsets.zero,
          itemCount: data.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, mainAxisSpacing: 0, crossAxisSpacing: 12, childAspectRatio: 2.5),
          itemBuilder: (BuildContext context, int index) {
            return buildItem(data[index]);
          }),
    );
  }

  Widget buildItem(ProductTransactionCategoryModel model) {
    return Chip(
        label: Text(
          model.name,
          style: const TextStyle(fontSize: 12),
        ),
        padding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero));
  }
}