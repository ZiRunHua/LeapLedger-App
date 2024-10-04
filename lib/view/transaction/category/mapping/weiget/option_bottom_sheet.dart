part of 'enter.dart';

class OptionBottomSheet extends StatelessWidget {
  const OptionBottomSheet({super.key, required this.unmapped});
  final List<TransactionCategoryBaseModel> unmapped;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
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
          return Divider(color: Colors.grey, height: 0.5.sp, thickness: 0.5.sp, indent: 16.sp, endIndent: 16.sp);
        },
        itemCount: unmapped.length,
      )),
    );
  }
}
