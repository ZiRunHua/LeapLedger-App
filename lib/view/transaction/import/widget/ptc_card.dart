part of '../transaction_import.dart';

class PtcCard extends StatelessWidget {
  final List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>> categoryTree;
  const PtcCard(this.categoryTree, {super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PtcCardBloc, PtcCardState>(builder: ((context, state) {
      var account = BlocProvider.of<TransImportTabBloc>(context).account;
      var product = BlocProvider.of<PtcCardBloc>(context).product;
      if (state is PtcCardLoad) {
        return Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
          margin: EdgeInsets.zero,
          child: Column(children: [
            GridView.builder(
                shrinkWrap: true, // 让网格视图适应内容大小
                physics: const NeverScrollableScrollPhysics(), // 禁止滚动
                padding: EdgeInsets.zero,
                itemCount: state.ptcList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.5,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return buildItem(state.ptcList[index]);
                }),
            Padding(
              padding: const EdgeInsets.all(Constant.margin),
              child: Offstage(
                offstage: false ==
                    TransactionCategoryRouterGuard.productMapping(
                      account: account,
                      product: product,
                      categoryTree: categoryTree,
                      ptcList: state.ptcList,
                    ),
                child: ElevatedButton(
                    onPressed: () {
                      TransactionCategoryRoutes.productMappingNavigator(
                        context,
                        account: account,
                        product: product,
                        categoryTree: categoryTree,
                        ptcList: state.ptcList,
                      ).push();
                    },
                    child: const Text('设置交易类型关联', style: TextStyle(fontSize: ConstantFontSize.headline))),
              ),
            )
          ]),
        );
      }
      return const SizedBox(height: 300, child: Center(child: CircularProgressIndicator()));
    }));
  }

  Widget buildItem(ProductTransactionCategoryModel model) {
    return Chip(
      elevation: 0,
      label: Text(model.name, style: const TextStyle(fontSize: ConstantFontSize.bodySmall)),
      padding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      side: BorderSide.none,
    );
  }
}
