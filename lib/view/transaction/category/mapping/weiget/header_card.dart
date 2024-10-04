part of 'enter.dart';

class HeaderCard extends StatelessWidget {
  const HeaderCard(this.data, {super.key});
  final List<TransactionCategoryBaseModel> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ConstantDecoration.cardDecoration,
      margin: EdgeInsets.zero,
      child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: data.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, mainAxisSpacing: 0, crossAxisSpacing: 12, childAspectRatio: 2.5),
          itemBuilder: (BuildContext context, int index) {
            return buildItem(data[index]);
          }),
    );
  }

  Widget buildItem(TransactionCategoryBaseModel model) {
    return Chip(
        label: Text(
          model.name,
          style: TextStyle(fontSize: ConstantFontSize.bodySmall),
        ),
        padding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        side: BorderSide.none,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero));
  }
}
