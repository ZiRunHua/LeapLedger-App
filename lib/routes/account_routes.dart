part of 'routes.dart';

class AccountRoutes {
  static String baseUrl = 'account';
  static String list = '$baseUrl/list';
  static String edit = '$baseUrl/edit';
  static String detail = '$baseUrl/detail';
  static String templateList = '$baseUrl/template/list';
  static void init() {
    Routes.routes.addAll({
      list: (context) => Routes.buildloginPermissionRoute(context, const AccountList()),
      edit: (context) => const AccountEdit(),
      detail: (context) => const AccountDetail(),
      templateList: (context) => const AccountTemplateList(),
    });
  }

  static Future<AccountModel?> pushEdit(BuildContext context, {AccountModel? account}) async {
    AccountModel? result;
    await Navigator.of(context).push(RightSlideRoute(page: AccountEdit(account: account))).then((value) {
      if (value is AccountModel) {
        result = value;
      }
    });
    return result;
  }

  static Future<AccountModel?> showAccountListButtomSheet(
    BuildContext context, {
    required AccountModel currentAccount,
  }) async {
    AccountModel? result;
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (_) => AccountListBottomSheet(
        currentAccount: currentAccount,
      ),
    ).then((value) {
      if (value is AccountModel) {
        result = value;
      }
    });
    return result;
  }

  static void showOperationBottomSheet(
    BuildContext context, {
    required AccountModel account,
  }) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (_) => AccountOperationBottomSheet(
        account: account,
      ),
    );
  }
}
