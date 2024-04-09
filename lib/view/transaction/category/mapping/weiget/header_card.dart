part of 'enter.dart';

class HeaderCard extends StatelessWidget {
  const HeaderCard(this.data, {super.key});
  final List<BaseTransactionCategoryModel> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ConstantDecoration.cardDecoration,
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

  Widget buildItem(BaseTransactionCategoryModel model) {
    return Chip(
        label: Text(
          model.name,
          style: const TextStyle(fontSize: ConstantFontSize.bodySmall),
        ),
        padding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        side: BorderSide.none,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero));
  }
}
