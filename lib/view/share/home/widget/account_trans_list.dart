part of 'enter.dart';

class AccountTransList extends StatefulWidget {
  const AccountTransList({super.key});

  @override
  State<AccountTransList> createState() => _AccountTransListState();
}

class _AccountTransListState extends State<AccountTransList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShareHomeBloc, ShareHomeState>(
        buildWhen: (_, current) => current is AccountRecentTransLoaded,
        builder: (context, state) {
          if (state is AccountRecentTransLoaded) {
            var account = ShareHomeBloc.account!;
            return _Func._buildCard(
                title: "收支",
                child: Column(
                  children: [
                    ..._buildList(account, state.list),
                    ListTile(
                      title: const Text("查看更多交易", textAlign: TextAlign.right),
                      trailing: const Icon(Icons.chevron_right_outlined),
                      onTap: () => _onLookMore(account, state.list.lastOrNull),
                    ),
                  ],
                ));
          } else {
            return const SizedBox(width: double.infinity, height: 200);
          }
        });
  }

  List<Widget> _buildList(AccountDetailModel account, List<TransactionModel> list) {
    if (list.isNotEmpty) {
      return List.generate(
        list.length * 2,
        (index) => index % 2 > 0
            ? ConstantWidget.divider.indented
            : CommonListTile.fromTransModel(
                list[index ~/ 2],
                displayUser: true,
                onTap: () => TransactionRoutes.detailNavigator(context, account: account, transaction: list[index ~/ 2])
                    .showModalBottomSheet(),
              ),
      );
    } else {
      return [NoData.transactionText(context, account: ShareHomeBloc.account)];
    }
  }

  void _onLookMore(AccountDetailModel account, TransactionModel? trans) {
    TZDateTime startTime, endTime;
    if (trans == null) {
      startTime = account.getNowTime().add(const Duration(days: -7));
    } else {
      startTime = account.getTZDateTime(trans.tradeTime).add(const Duration(days: -7));
    }
    endTime = startTime.add(const Duration(days: 7));
    TransactionRoutes.pushFlow(context,
        account: account,
        condition: TransactionQueryCondModel(accountId: account.id, startTime: startTime, endTime: endTime));
  }
}
