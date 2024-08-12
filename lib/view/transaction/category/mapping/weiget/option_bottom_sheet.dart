part of 'enter.dart';

class OptionBottomSheet extends StatelessWidget {
  const OptionBottomSheet({super.key, required this.unmapped});
  final List<TransactionCategoryBaseModel> unmapped;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: ConstantDecoration.bottomSheetBorderRadius,
      ),
      height: MediaQuery.of(context).size.height / 2.0,
      child: Scrollbar(
          child: ListView.separated(
        itemBuilder: (_, int index) {
          return ListTile(
            title: Center(
              child: Text(unmapped[index].name),
            ),
            onTap: () => Navigator.pop<TransactionCategoryBaseModel>(context, unmapped[index]),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(color: Colors.grey, height: 0.5, thickness: 0.5, indent: 16, endIndent: 16);
        },
        itemCount: unmapped.length,
      )),
    );
  }
}
