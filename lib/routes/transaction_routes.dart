part of 'routes.dart';

class TransactionRoutes {
  static void init() {}
  static TransactionEditNavigator editNavigator(BuildContext context,
      {required TransactionEditMode mode, required AccountDetailModel account, TransactionModel? transaction}) {
    return TransactionEditNavigator(context, mode: mode, transaction: transaction, account: account);
  }

  static pushFlow(
    BuildContext context, {
    TransactionQueryConditionApiModel? condition,
    AccountDetailModel? account,
  }) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TransactionFlow(
            condition: condition,
            account: account,
          ),
        ));
  }

  static pushDetailBottomSheet(BuildContext context,
      {required AccountDetailModel account, TransactionModel? transaction, int? transactionId}) {
    showModalBottomSheet(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => TransactionBloc(),
        child: TransactionDetailBottomSheet(
          account: account,
          transaction: transaction,
          transactionId: transactionId,
        ),
      ),
    );
  }

  static void showShareDialog(BuildContext context, {required TransactionShareModel shareModel}) {
    showDialog(
      context: context,
      builder: (context) => TransactionShareDialog(
        data: shareModel,
      ),
    );
  }

  static TransactionImportNavigator import(BuildContext context, {required AccountDetailModel account}) {
    return TransactionImportNavigator(context, account: account);
  }
}

class TransactionRouterGuard {
  /// [TransactionEditNavigator]的鉴权方法
  static bool edit(
      {required TransactionEditMode mode, required AccountDetailModel account, TransactionModel? transaction}) {
    if (transaction != null) {
      if (transaction.accountId != account.id) {
        return false;
      }
    }
    if (account.isReader) {
      return false;
    }
    return true;
  }

  static bool import({required AccountDetailModel account}) {
    return !account.isReader;
  }
}

class TransactionEditNavigator extends RouterNavigator {
  final TransactionEditMode mode;
  final TransactionModel? transaction;
  final AccountDetailModel account;
  TransactionEditNavigator(BuildContext context, {required this.account, required this.mode, this.transaction})
      : super(context: context);

  @override
  bool get guard => TransactionRouterGuard.edit(mode: mode, transaction: transaction, account: account);
  Future<bool> push() async {
    return await _leftSlidePush(context, TransactionEdit(mode: mode, model: transaction, account: account));
  }

  @override
  _then(value) {
    isFinish = value is bool ? value : false;
  }

  bool isFinish = false;
  bool getReturn() {
    return isFinish;
  }
}

class TransactionImportNavigator extends RouterNavigator {
  final AccountDetailModel account;
  TransactionImportNavigator(BuildContext context, {required this.account}) : super(context: context);

  @override
  bool get guard => TransactionRouterGuard.import(account: account);
  Future<bool> push() async {
    return await _push(context, TransactionImport(account: account));
  }
}
