part of 'routes.dart';

class TransactionRoutes {
  static void init() {}

  /// param:
  /// - `user`: not required, default [UserBloc.user].
  /// - `originalTrans`: required when edit mode.
  /// - `infoTrans`: not required, initial data for add and popTran mode.
  static TransactionEditNavigator editNavigator(
    BuildContext context, {
    required TransactionEditMode mode,
    UserModel? user,
    required AccountDetailModel account,
    TransactionModel? originalTrans,
    TransactionInfoModel? transInfo,
  }) {
    return TransactionEditNavigator(context,
        mode: mode, originalTrans: originalTrans, account: account, user: user ?? UserBloc.user, transInfo: transInfo);
  }

  static TransactionChartNavigator chartNavigator(
    BuildContext context, {
    required AccountDetailModel account,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return TransactionChartNavigator(context, account: account, startDate: startDate, endDate: endDate);
  }

  static pushFlow(
    BuildContext context, {
    TransactionQueryCondModel? condition,
    required AccountDetailModel account,
  }) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TransactionFlow(condition: condition, account: account),
        ));
  }

  static TransactionDetailNavigator detailNavigator(BuildContext context,
      {required AccountDetailModel account, TransactionModel? transaction}) {
    return TransactionDetailNavigator(context, account: account, transaction: transaction);
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

  static TransactionTimingListNavigator timingListNavigator(BuildContext context,
      {required AccountDetailModel account}) {
    return TransactionTimingListNavigator(context, account: account);
  }

  static TransactionTimingNavigator timingNavigator(
    BuildContext context, {
    required AccountDetailModel account,
    required TransactionInfoModel trans,
    TransactionTimingModel? config,
    TransactionTimingCubit? cubit,
  }) {
    return TransactionTimingNavigator(context, account: account, trans: trans, config: config, cubit: cubit);
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

class TransactionDetailNavigator extends RouterNavigator {
  final TransactionModel? transaction;
  final AccountDetailModel account;
  TransactionDetailNavigator(BuildContext context, {required this.account, this.transaction}) : super(context: context);
  Future<bool> showModalBottomSheet() async {
    return await _modalBottomSheetShow(
      context,
      TransactionDetailBottomSheet(account: account, transaction: transaction),
    );
  }
}

class TransactionEditNavigator extends RouterNavigator {
  final UserModel user;
  final AccountDetailModel account;
  final TransactionEditMode mode;
  final TransactionModel? originalTrans;
  final TransactionInfoModel? transInfo;
  TransactionEditNavigator(BuildContext context,
      {required this.user, required this.account, required this.mode, this.originalTrans, this.transInfo})
      : super(context: context);

  @override
  bool get guard => TransactionRouterGuard.edit(mode: mode, transaction: originalTrans, account: account);
  Future<bool> push() async {
    return await _leftSlidePush(
        context, TransactionEdit(user: user, mode: mode, model: originalTrans, account: account, transInfo: transInfo));
  }

  @override
  _then(value) {
    if (value is TransactionInfoModel) {
      _popTransInfo = value;
      _finish = true;
    } else if (value is bool) {
      _popTransInfo = null;
      _finish = true;
    }
  }

  TransactionInfoModel? _popTransInfo;
  bool _finish = false;
  TransactionInfoModel? getPopTransInfo() {
    return _popTransInfo;
  }

  bool finish() {
    return _finish;
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

class TransactionChartNavigator extends RouterNavigator {
  final AccountDetailModel account;
  final DateTime? startDate, endDate;
  TransactionChartNavigator(
    BuildContext context, {
    required this.account,
    this.startDate,
    this.endDate,
  }) : super(context: context);

  Future<bool> push() async {
    return await _push(context, TransactionChart(account: account, startDate: startDate, endDate: endDate));
  }
}

class TransactionTimingListNavigator extends RouterNavigator {
  final AccountDetailModel account;
  TransactionTimingListNavigator(BuildContext context, {required this.account}) : super(context: context);

  Future<bool> push() async {
    return await _push(context, TransactionTimingList(account: account));
  }
}

class TransactionTimingNavigator extends RouterNavigator {
  final AccountDetailModel account;
  final TransactionInfoModel trans;
  final TransactionTimingModel? config;
  final TransactionTimingCubit? cubit;
  TransactionTimingNavigator(BuildContext context,
      {required this.account, required this.trans, this.config, this.cubit})
      : super(context: context);

  bool get guard => account.isAdministrator || account.isCreator;
  Future<bool> push() async {
    return await _push(context, TransactionTiming(account: account, trans: trans, config: config, cubit: cubit));
  }

  ({TransactionInfoModel trans, TransactionTimingModel config})? _return;
  @override
  _then(value) {
    if (value is ({TransactionInfoModel trans, TransactionTimingModel config})) {
      _return == value;
    }
    return super._then(value);
  }
}
