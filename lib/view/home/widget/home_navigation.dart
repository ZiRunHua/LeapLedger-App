part of 'enter.dart';

class HomeNavigation extends StatelessWidget {
  HomeNavigation({required this.account});
  final AccountDetailModel account;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _navigatorButton(
            account.name,
            icon: Icons.sync_outlined,
            onTap: () => AccountRoutes.list(context, selectedCurrentAccount: true).push(),
          ),
          _navigatorButton(
            "交易类型",
            icon: Icons.settings_outlined,
            onTap: () => TransactionCategoryRoutes.settingNavigator(context, account: account).pushTree(),
          ),
          _navigatorButton(
            "图表分析",
            icon: Icons.pie_chart_outline_outlined,
            onTap: () => TransactionRoutes.chartNavigator(context, account: account).push(),
          ),
          _navigatorButton(
            "交易定时",
            icon: Icons.timer_outlined,
            onTap: () => TransactionRoutes.timingListNavigator(context, account: account).push(),
          ),
          Offstage(
            offstage: false == TransactionRouterGuard.import(account: account),
            child: _navigatorButton(
              "导入账单",
              icon: Icons.upload_outlined,
              onTap: () => TransactionRoutes.import(context, account: account).push(),
            ),
          )
        ],
      ),
    );
  }

  Widget _navigatorButton(String title, {IconData? icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: const EdgeInsets.only(left: Constant.margin / 2, right: Constant.margin / 2),
          padding: const EdgeInsets.symmetric(horizontal: Constant.padding),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(90)),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: ConstantColor.primaryColor,
                size: 24,
              ),
              const SizedBox(width: Constant.margin / 2),
              Text(title),
            ],
          )),
    );
  }
}
