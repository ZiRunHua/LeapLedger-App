part of 'routes.dart';

class AccountRoutes {
  static String baseUrl = 'account';
  static String detail = '$baseUrl/detail';
  static String templateList = '$baseUrl/template/list';
  static String userInvitation = '$baseUrl/user/invitation';

  static void init() {
    Routes.routes.addAll({
      detail: (context) => const AccountDetail(),
      templateList: (context) => const AccountTemplateList(),
    });
  }

  static Future<T?> pushNamed<T extends Object?>(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.of(context).pushNamed<T>(routeName, arguments: arguments);
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

  static AccountEditNavigator edit(BuildContext context, {AccountDetailModel? account}) =>
      AccountEditNavigator(context, account: account);

  static AccountListNavigator list(
    BuildContext context, {
    AccountDetailModel? selectedAccount,
    bool selectedCurrentAccount = false,
  }) {
    return AccountListNavigator(
      context,
      selectedAccount: selectedAccount,
      selectedCurrentAccount: selectedCurrentAccount,
    );
  }

  static AccountOperationListNavigator operationList(BuildContext context, {required AccountDetailModel account}) =>
      AccountOperationListNavigator(context, account: account);

  static AccountUserConfigNavigator userConfig(BuildContext context, {required AccountDetailModel accoount}) =>
      AccountUserConfigNavigator(context, account: accoount);

  static AccountUserEditNavigator userEdit(
    BuildContext context, {
    required AccountUserModel accountUser,
    required AccountDetailModel accoount,
  }) =>
      AccountUserEditNavigator(context, account: accoount, accountUser: accountUser);

  static AccountUserInviteNavigator userInvite(
    BuildContext context, {
    required AccountDetailModel account,
    required UserInfoModel userInfo,
  }) =>
      AccountUserInviteNavigator(context, account: account, userInfo: userInfo);

  static AccountMappingNavigator mapping(
    BuildContext context, {
    required AccountDetailModel mainAccount,
    AccountMappingModel? mapping,
    MappingChangeCallback? onMappingChange,
  }) =>
      AccountMappingNavigator(context, mainAccount: mainAccount, mapping: mapping, onMappingChange: onMappingChange);
}

class AccountRouterGuard {
  static bool edit({required AccountDetailModel? account}) {
    if (account != null && account.isValid && account.isReader) {
      return false;
    }
    return true;
  }

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

class AccountEditNavigator extends RouterNavigator {
  final AccountDetailModel? account;
  AccountEditNavigator(BuildContext context, {this.account}) : super(context: context);
  @override
  bool get guard => AccountRouterGuard.edit(account: account);
  Future<bool> push() async => await _push(context, AccountEdit(account: account));

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

class AccountListNavigator extends RouterNavigator {
  final AccountDetailModel? selectedAccount;
  final SelectAccountCallback? onSelectedAccount;
  final bool selectedCurrentAccount;
  AccountListNavigator(
    BuildContext context, {
    this.selectedAccount,
    this.onSelectedAccount,
    required this.selectedCurrentAccount,
  }) : super(context: context);
  Future<AccountDetailModel?> _defaultOnSelectedAccount(AccountDetailModel account) async {
    Navigator.pop<AccountDetailModel>(context, account);
    return account;
  }

  Widget _listenCurrentAccountChanged(
      Widget Function(AccountDetailModel account, SelectAccountCallback onSelectedAccount) page) {
    if (selectedCurrentAccount)
      return BlocBuilder<UserBloc, UserState>(
        buildWhen: (_, state) => state is CurrentAccountChanged,
        builder: (context, state) {
          return page(
            UserBloc.currentAccount,
            (AccountDetailModel account) async {
              var page = AccountRoutes.operationList(context, account: account);
              await page.showModalBottomSheet();
              return UserBloc.currentAccount;
            },
          );
        },
      );
    assert(selectedAccount != null);
    return page(selectedAccount!, onSelectedAccount ?? _defaultOnSelectedAccount);
  }

  Future<bool> showModalBottomSheet({bool onlyCanEdit = false}) async => await _modalBottomSheetShow(
        context,
        _listenCurrentAccountChanged(
          (account, onSelectedAccount) => AccountListBottomSheet(
            selectedAccount: account,
            onSelectedAccount: onSelectedAccount,
            type: onlyCanEdit ? ViewAccountListType.onlyCanEdit : ViewAccountListType.all,
          ),
        ),
      );

  Future<bool> push() async => await _push(
        context,
        _listenCurrentAccountChanged(
          (account, onSelectedAccount) => AccountList(
            selectedAccount: account,
            onSelectedAccount: onSelectedAccount,
          ),
        ),
      );

  AccountDetailModel? retrunAccount;
  @override
  _then(value) {
    if (value is AccountDetailModel) {
      retrunAccount = value;
    }
  }
}

class AccountOperationListNavigator extends RouterNavigator {
  final AccountDetailModel account;
  AccountOperationListNavigator(BuildContext context, {required this.account}) : super(context: context);

  Future<bool> showModalBottomSheet() async =>
      await _modalBottomSheetShow(context, AccountOperationBottomSheet(account: account));

  @override
  _then(value) {
    if (value is AccountDetailModel) {
      updatedAccount = value;
    } else if (value is bool) {
      accountDelated = value;
    }
  }

  AccountDetailModel? updatedAccount;
  bool? accountDelated;
}

class AccountUserDetailNavigator extends RouterNavigator {
  final AccountUserModel accountUser;
  final AccountDetailModel account;
  final void Function(AccountUserModel)? onEdit;
  AccountUserDetailNavigator(BuildContext context, {required this.accountUser, required this.account, this.onEdit})
      : super(context: context);

  Future<bool> showModalBottomSheet() async => await _modalBottomSheetShow(
        context,
        AccountUserDetailButtomSheet(accountUser: accountUser, account: account, onEdit: onEdit),
      );
}

class AccountUserEditNavigator extends RouterNavigator {
  final AccountDetailModel account;
  final AccountUserModel accountUser;

  AccountUserEditNavigator(BuildContext context, {required this.account, required this.accountUser})
      : super(context: context);

  @override
  bool get guard => AccountRouterGuard.userEdit(account: account, accountUser: accountUser);

  Future<bool> showDialog() async =>
      await _showDialog(context, AccountUserEditDialog(account: account, accountUser: accountUser));

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

  Future<bool> showDialog() async =>
      await _showDialog(context, AccountUserInviteDialog(account: account, userInfo: userInfo));
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

class AccountUserConfigNavigator extends RouterNavigator {
  final AccountDetailModel account;
  AccountUserConfigNavigator(BuildContext context, {required this.account}) : super(context: context);

  Future<bool> showDialog() async => await _showDialog(context, AccountUserConfigDialog(account: account));
}
