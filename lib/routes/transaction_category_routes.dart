part of 'routes.dart';

class TransactionCategoryRoutes {
  static const String _base = 'transactionCategory';
  static String setting = '$_base/setting';
  static String edit = '$_base/edit';
  static String fatherEdit = '$_base/father/edit';
  static String mapping = '$_base/mapping';
  static String template = '$_base/template';
  static void init() {
    Routes.routes[setting] = (context) => const TransactionCategoryTree();
    Routes.routes[edit] = (context) => TransactionCategoryEdit(
        transactionCategory: Routes.argument<TransactionCategoryModel>(context, 'transactionCategory'));
    Routes.routes[fatherEdit] = (context) => TransactionCategoryFatherEdit(
        Routes.argument<TransactionCategoryFatherModel>(context, 'transactionCategoryFather'));
    Routes.routes[mapping] = (context) {
      var product = Routes.argument<ProductModel>(context, 'product');
      var categoryTree =
          Routes.argument<List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>>>(
              context, 'categoryTree');
      var ptcList = Routes.argument<List<ProductTransactionCategoryModel>>(context, 'ptcList');
      if (product == null || categoryTree == null) {
        return Routes.errorWight("product和categoryTree必填");
      }
      return TransactionCategoryMapping(
        product,
        categoryTree,
        ptcList: ptcList,
      );
    };

    Routes.routes[template] = (context) => const TransactionCategoryTemplate();
  }

  static RichText getNoDataRichText(BuildContext context) {
    return RichText(
      textScaler: MediaQuery.of(context).textScaler,
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          const TextSpan(
              text: '交易类型未设置!\n\n',
              style: TextStyle(
                color: Colors.black,
              )),
          TextSpan(
              text: '点击设置',
              style: const TextStyle(
                color: Colors.blue,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pushNamed(context, TransactionCategoryRoutes.setting);
                }),
        ],
      ),
    );
  }

  static getMappingPushArguments(
    ProductModel product,
    List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>> categoryTree, {
    List<ProductTransactionCategoryModel>? ptcList,
  }) {
    return {'product': product, 'categoryTree': categoryTree, 'ptcList': ptcList};
  }

  static Future<AccountModel?> pushTemplate(BuildContext context) async {
    AccountModel? result;
    await Navigator.pushNamed(context, template).then((value) {
      if (value is AccountModel) {
        result = value;
      }
    });
    return result;
  }
}
