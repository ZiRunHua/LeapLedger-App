part of 'enter.dart';

class HomeNavigation extends StatefulWidget {
  const HomeNavigation({super.key});

  @override
  HomeNavigationState createState() => HomeNavigationState();
}

class HomeNavigationState extends State<HomeNavigation> {
  AccountDetailModel account = UserBloc.currentAccount;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: Constant.smallPadding / 2),
        child: UserBloc.listenerCurrentAccountIdUpdate(
          () {
            setState(() {
              account = UserBloc.currentAccount;
            });
          },
          SizedBox(
            height: 48,
            width: MediaQuery.of(context).size.width,
            child: _buidlButtonGroup(),
          ),
        ));
  }

  Widget _buidlButtonGroup() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        navigatorButton(
          account.name,
          icon: Icons.sync_outlined,
          onTap: () => Navigator.pushNamed(context, AccountRoutes.list),
        ),
        navigatorButton(
          "交易类型",
          icon: Icons.settings_outlined,
          onTap: () => TransactionCategoryRoutes.setting(context, account: account).pushTree(),
        ),
        Offstage(
          offstage: false == TransactionRouterGuard.import(account: account),
          child: navigatorButton(
            "导入账单",
            icon: Icons.upload_outlined,
            onTap: () => TransactionRoutes.import(context, account: account).push(),
          ),
        ),
        navigatorButton(
          "导出账单",
          icon: Icons.download_outlined,
          onTap: () => Navigator.pushNamed(context, AccountRoutes.list),
        )
      ],
    );
  }

  Widget navigatorButton(String title,
      {IconData? titleIcon, String? subTitle, IconData? icon, required VoidCallback onTap}) {
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
              const SizedBox(
                width: Constant.margin / 2,
              ),
              Text(title),
            ],
          )),
    );
  }
}
