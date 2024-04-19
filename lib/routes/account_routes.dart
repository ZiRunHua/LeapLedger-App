part of 'routes.dart';

class AccountRoutes {
  static String baseUrl = 'account';
  static String list = '$baseUrl/list';
  static String detail = '$baseUrl/detail';
  static String templateList = '$baseUrl/template/list';
  static String userInvitation = '$baseUrl/user/invitation';

  static get accountUser => null;
  static void init() {
    Routes.routes.addAll({
      list: (context) => Routes.buildloginPermissionRoute(context, const AccountList()),
      detail: (context) => const AccountDetail(),
      templateList: (context) => const AccountTemplateList(),
    });
  }

  static Future<T?> pushNamed<T extends Object?>(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.of(context).pushNamed<T>(routeName, arguments: arguments);
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
      isScrollControlled: true,
      context: context,
      builder: (_) => AccountListBottomSheet(currentAccount: currentAccount),
    ).then((value) {
      if (value is AccountModel) {
        result = value;
      }
    });
    return result;
  }

  static void showOperationBottomSheet(
    BuildContext context, {
    required AccountDetailModel account,
  }) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => AccountOperationBottomSheet(
        account: account,
      ),
    );
  }

  static Future<AccountUserInvitationModle?> pushAccountUserInvitation(
    BuildContext context, {
    required AccountModel account,
  }) async {
    AccountUserInvitationModle? result;
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AccountUserInvitation(account: account)),
    ).then((value) {
      if (value is AccountUserInvitationModle) {
        result = value;
      }
    });
    return result;
  }

  static AccountUserDetailNavigator userDetail(BuildContext context,
      {required AccountUserModel accountUser,
      required AccountDetailModel accoount,
      void Function(AccountUserModel)? onEdit}) {
    return AccountUserDetailNavigator(
      context,
      account: accoount,
      accountUser: accountUser,
      onEdit: onEdit,
    );
  }

  static AccountListNavigator list(BuildContext context, {required AccountDetailModel account}) {
    return AccountListNavigator(context, account: account);
  }

  static AccountListNavigator operationList(BuildContext context, {required AccountDetailModel account}) {
    return AccountListNavigator(context, account: account);
  }

  static AccountUserEditNavigator userEdit(BuildContext context,
      {required AccountUserModel accountUser, required AccountDetailModel accoount}) {
    return AccountUserEditNavigator(context, account: accoount, accountUser: accountUser);
  }

  static AccountUserInviteNavigator userInvite(BuildContext context,
      {required AccountDetailModel account, required UserInfoModel userInfo}) {
    return AccountUserInviteNavigator(context, account: account, userInfo: userInfo);
  }

  static AccountMappingNavigator mapping(BuildContext context,
      {required AccountDetailModel mainAccount, AccountMappingModel? mapping, MappingChangeCallback? onMappingChange}) {
    return AccountMappingNavigator(context,
        mainAccount: mainAccount, mapping: mapping, onMappingChange: onMappingChange);
  }
}

class AccountRouterGuard {
  static bool userInvite({required AccountDetailModel account, UserInfoModel? userInfo}) {
    if (account.isReader) {
      return false;
    }
    return true;
  }

  static bool userEdit({required AccountDetailModel account, AccountUserModel? accountUser}) {
    if (account.isCreator) {
      return true;
    }
    return false;
  }

  static bool mapping({required AccountDetailModel mainAccount, AccountMappingModel? mapping}) {
    return !mainAccount.isReader;
  }
}

class AccountListNavigator extends RouterNavigator {
  final AccountDetailModel account;
  final void Function(AccountUserModel)? onEdit;
  AccountListNavigator(BuildContext context, {required this.account, this.onEdit}) : super(context: context);

  Future<bool> showModalBottomSheet() async {
    return await _modalBottomSheetShow(context, AccountListBottomSheet(currentAccount: account));
  }

  Future<bool> push() async {
    return await _push(context, AccountList(account: account));
  }

  @override
  _then(value) {
    if (value is AccountDetailModel) {
      result = value;
    }
  }

  AccountDetailModel? result;
  AccountDetailModel? getReturn() {
    return result;
  }
}

class AccountOperationListNavigator extends RouterNavigator {
  final AccountDetailModel account;
  AccountOperationListNavigator(BuildContext context, {required this.account}) : super(context: context);

  Future<bool> showModalBottomSheet() async {
    return await _modalBottomSheetShow(context, AccountOperationBottomSheet(account: account));
  }

  @override
  _then(value) {
    if (value is AccountDetailModel) {
      result = value;
    }
  }

  AccountDetailModel? result;
  AccountDetailModel? getReturn() {
    return result;
  }
}

class AccountUserDetailNavigator extends RouterNavigator {
  final AccountUserModel accountUser;
  final AccountDetailModel account;
  final void Function(AccountUserModel)? onEdit;
  AccountUserDetailNavigator(BuildContext context, {required this.accountUser, required this.account, this.onEdit})
      : super(context: context);

  Future<bool> showModalBottomSheet() async {
    return await _modalBottomSheetShow(
        context, AccountUserDetailButtomSheet(accountUser: accountUser, account: account));
  }
}

class AccountUserEditNavigator extends RouterNavigator {
  final AccountDetailModel account;
  final AccountUserModel accountUser;

  AccountUserEditNavigator(BuildContext context, {required this.account, required this.accountUser})
      : super(context: context);

  @override
  bool get guard => AccountRouterGuard.userEdit(account: account, accountUser: accountUser);

  Future<bool> showDialog() async {
    return await _showDialog(context, AccountUserEditDialog(account: account, accountUser: accountUser));
  }

  @override
  _then(value) {
    if (value is AccountUserModel) {
      result = value;
    }
  }

  AccountUserModel? result;
  AccountUserModel? getResult() {
    return result;
  }
}

class AccountUserInviteNavigator extends RouterNavigator {
  final AccountDetailModel account;
  final UserInfoModel userInfo;

  AccountUserInviteNavigator(BuildContext context, {required this.account, required this.userInfo})
      : super(context: context);
  @override
  bool get guard => AccountRouterGuard.userInvite(account: account, userInfo: userInfo);

  Future<bool> showDialog() async {
    return await _showDialog(context, AccountUserInviteDialog(account: account, userInfo: userInfo));
  }
}

class AccountMappingNavigator extends RouterNavigator {
  final AccountDetailModel mainAccount;
  final AccountMappingModel? mapping;
  final MappingChangeCallback? onMappingChange;
  AccountMappingNavigator(BuildContext context,
      {required this.mainAccount, required this.mapping, this.onMappingChange})
      : super(context: context);
  @override
  bool get guard => AccountRouterGuard.mapping(mainAccount: mainAccount, mapping: mapping);

  Future<bool> showModalBottomSheet() async {
    return await _modalBottomSheetShow(
        context,
        AccountMappingBottomSheet(
          mainAccount: mainAccount,
          mapping: mapping,
          onMappingChange: onMappingChange,
        ));
  }
}
