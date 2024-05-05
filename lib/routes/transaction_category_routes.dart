part of 'routes.dart';

class TransactionCategoryRoutes {
  static const String _base = 'transactionCategory';
  static String edit = '$_base/edit';
  static String mapping = '$_base/mapping';
  static void init() {}
  static TransactionCategoryEditNavigator editNavigator(BuildContext context,
      {required AccountDetailModel account, required TransactionCategoryModel transactionCategory}) {
    return TransactionCategoryEditNavigator(context, transactionCategory: transactionCategory, account: account);
  }

  static TransactionCategoryFatherEditNavigator fatherEditNavigator(BuildContext context,
      {required AccountDetailModel account, required TransactionCategoryFatherModel father}) {
    return TransactionCategoryFatherEditNavigator(context, father: father, account: account);
  }

  static TransactionCategorySettingNavigator setting(BuildContext context,
      {required AccountDetailModel account, AccountDetailModel? relatedAccount}) {
    return TransactionCategorySettingNavigator(context, account: account, relatedAccount: relatedAccount);
  }

  static Route<TransactionCategoryTemplate> getTemplateRoute(BuildContext context, {required AccountModel account}) {
    return MaterialPageRoute(
      builder: (context) => TransactionCategoryTemplate(
        account: account,
      ),
    );
  }

  static AccountTransactionCategoryMappingNavigator accountMapping(BuildContext context,
      {required AccountDetailModel parentAccount,
      required AccountDetailModel childAccount,
      List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>>? parentCategoryTree,
      List<TransactionCategoryModel>? childCategoryList}) {
    return AccountTransactionCategoryMappingNavigator(context,
        parentAccount: parentAccount,
        childAccount: childAccount,
        parentCategoryTree: parentCategoryTree,
        childCategoryList: childCategoryList);
  }

  static ProductTransactionCategoryMappingNavigator productMapping(
    BuildContext context, {
    required AccountDetailModel account,
    required ProductModel product,
    required List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>> categoryTree,
    required List<ProductTransactionCategoryModel>? ptcList,
  }) {
    return ProductTransactionCategoryMappingNavigator(context,
        account: account, product: product, categoryTree: categoryTree, ptcList: ptcList);
  }
}

class TransactionCategoryRouterGuard {
  static bool edit({required AccountDetailModel account}) {
    return account.isCreator;
  }

  static bool accountMapping(
      {required AccountDetailModel parentAccount,
      required AccountDetailModel childAccount,
      List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>>? parentCategoryTree,
      List<TransactionCategoryModel>? childCategoryList}) {
    return !parentAccount.isReader && childAccount.isCreator;
  }

  static bool productMapping({
    required AccountDetailModel account,
    required ProductModel product,
    required List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>> categoryTree,
    required List<ProductTransactionCategoryModel>? ptcList,
  }) {
    return !account.isReader;
  }
}

class TransactionCategoryEditNavigator extends RouterNavigator {
  final AccountDetailModel account;
  final TransactionCategoryModel transactionCategory;
  TransactionCategoryEditNavigator(BuildContext context, {required this.account, required this.transactionCategory})
      : super(context: context);

  @override
  bool get guard => TransactionCategoryRouterGuard.edit(account: account);
  Future<bool> push() async {
    return await _push(context, TransactionCategoryEdit(account: account, transactionCategory: transactionCategory));
  }

  @override
  _then(value) {
    result = value is TransactionCategoryModel && value.isValid ? value : null;
  }

  TransactionCategoryModel? result;
}

class TransactionCategoryFatherEditNavigator extends RouterNavigator {
  final AccountDetailModel account;
  final TransactionCategoryFatherModel father;
  TransactionCategoryFatherEditNavigator(BuildContext context, {required this.account, required this.father})
      : super(context: context);

  @override
  bool get guard => TransactionCategoryRouterGuard.edit(account: account);
  Future<bool> showDialog() async {
    return await _showDialog(context, TransactionCategoryFatherEditDialog(account: account, model: father));
  }

  @override
  _then(value) {
    result = value is TransactionCategoryFatherModel && value.isValid ? value : null;
  }

  TransactionCategoryFatherModel? result;
  TransactionCategoryFatherModel? getReturn() {
    return result;
  }
}

class TransactionCategorySettingNavigator extends RouterNavigator {
  final AccountDetailModel account;

  /// 设置交易关联时是需要用到
  final AccountDetailModel? relatedAccount;
  TransactionCategorySettingNavigator(BuildContext context, {required this.account, this.relatedAccount})
      : super(context: context);

  @override
  bool get guard => true;
  Future<bool> pushTree() async {
    return await _push(context, TransactionCategoryTree(account: account, relatedAccount: relatedAccount));
  }
}

class AccountTransactionCategoryMappingNavigator extends RouterNavigator {
  final AccountDetailModel parentAccount, childAccount;
  final List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>>? parentCategoryTree;
  final List<TransactionCategoryModel>? childCategoryList;

  @override
  bool get guard => TransactionCategoryRouterGuard.accountMapping(
      parentAccount: parentAccount, childAccount: childAccount, parentCategoryTree: parentCategoryTree);

  AccountTransactionCategoryMappingNavigator(
    BuildContext context, {
    required this.parentAccount,
    required this.childAccount,
    required this.parentCategoryTree,
    required this.childCategoryList,
  }) : super(context: context);

  Future<bool> push() async {
    return await _push(
        context,
        AccountTransactionCategoryMapping(
          parentAccount: parentAccount,
          childAccount: childAccount,
          parentCategoryTree: parentCategoryTree,
          childCategoryList: childCategoryList,
        ));
  }
}

class ProductTransactionCategoryMappingNavigator extends RouterNavigator {
  final AccountDetailModel account;
  final ProductModel product;
  final List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>> categoryTree;
  final List<ProductTransactionCategoryModel>? ptcList;
  ProductTransactionCategoryMappingNavigator(
    BuildContext context, {
    required this.account,
    required this.product,
    required this.categoryTree,
    required this.ptcList,
  }) : super(context: context);

  @override
  bool get guard => TransactionCategoryRouterGuard.productMapping(
      account: account, product: product, categoryTree: categoryTree, ptcList: ptcList);

  Future<bool> push() async {
    return await _push(
        context,
        ProductTransactionCategoryMapping(
            account: account, product: product, categoryTree: categoryTree, ptcList: ptcList));
  }

  static TransactionCategoryFatherEditNavigator fatherEditNavigator(BuildContext context,
      {required AccountDetailModel account, required TransactionCategoryFatherModel father}) {
    return TransactionCategoryFatherEditNavigator(context, father: father, account: account);
  }

  static TransactionCategorySettingNavigator setting(BuildContext context, {required AccountDetailModel account}) {
    return TransactionCategorySettingNavigator(context, account: account);
  }
}
