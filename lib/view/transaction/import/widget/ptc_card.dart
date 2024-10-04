part of '../transaction_import.dart';

class PtcCard extends StatelessWidget {
  final List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>> categoryTree;
  final AccountDetailModel account;
  final ProductModel product;
  final List<ProductTransactionCategoryModel> ptcList;
  const PtcCard(this.ptcList, {required this.categoryTree, super.key, required this.account, required this.product});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _Func._buildCard(
            child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: ptcList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 0,
            crossAxisSpacing: 12,
            childAspectRatio: 2.5,
          ),
          itemBuilder: (BuildContext context, int index) {
            return buildItem(ptcList[index]);
          },
        )),
        BlocBuilder<ImportCubit, ImportState>(
          builder: (context, state) {
            if (state is Importing) {
              return SizedBox();
            }
            return Padding(
              padding: EdgeInsets.all(Constant.margin),
              child: Offstage(
                offstage: ptcList.length == 0 ||
                    false ==
                        TransactionCategoryRouterGuard.productMapping(
                          account: account,
                          product: product,
                          categoryTree: categoryTree,
                          ptcList: ptcList,
                        ),
                child: ElevatedButton(
                    onPressed: () {
                      TransactionCategoryRoutes.productMappingNavigator(
                        context,
                        account: account,
                        product: product,
                        categoryTree: categoryTree,
                        ptcList: ptcList,
                      ).push();
                    },
                    child: Text('设置交易类型关联', style: TextStyle(fontSize: ConstantFontSize.headline))),
              ),
            );
          },
        )
      ],
    );
  }

  Widget buildItem(ProductTransactionCategoryModel model) {
    return Chip(
      elevation: 0,
      label: Text(model.name, style: TextStyle(fontSize: ConstantFontSize.bodySmall)),
      padding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      side: BorderSide.none,
    );
  }
}
