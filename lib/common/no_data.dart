part of 'global.dart';

class NoData {
  static Text transactionText(BuildContext context, {AccountDetailModel? account}) {
    // 鉴权不通过
    if (account == null || false == TransactionRouterGuard.edit(mode: TransactionEditMode.add, account: account)) {
      return commonText;
    }
    return Text.rich(
        textAlign: TextAlign.center,
        TextSpan(
          children: [
            const TextSpan(text: '没有收支记录，快去', style: TextStyle(color: Colors.black)),
            TextSpan(
                text: '记一笔',
                style: const TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    TransactionRoutes.editNavigator(context, mode: TransactionEditMode.add, account: account).push();
                  }),
            const TextSpan(text: '！', style: TextStyle(color: Colors.black)),
          ],
        ));
  }

  static Text accountText(BuildContext context) {
    return Text.rich(
        textAlign: TextAlign.center,
        TextSpan(
          children: [
            const TextSpan(text: '没有账本，快去', style: TextStyle(color: Colors.black)),
            TextSpan(
                text: '新建',
                style: const TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    AccountRoutes.pushEdit(context);
                  }),
          ],
        ));
  }

  static const Widget commonWidget = Text("无数据", style: TextStyle(color: Colors.black));
  static const Text commonText = Text("无数据", style: TextStyle(color: Colors.black));
}
