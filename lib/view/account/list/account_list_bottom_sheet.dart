part of "enter.dart";

class AccountListBottomSheet extends StatefulWidget {
  const AccountListBottomSheet({required this.selectedAccount, this.onSelectedAccount, super.key});
  final AccountDetailModel selectedAccount;
  final SelectAccountCallback? onSelectedAccount;
  @override
  State<AccountListBottomSheet> createState() => _AccountListBottomSheetState();
}

class _AccountListBottomSheetState extends State<AccountListBottomSheet> {
  late AccountDetailModel currentAccount;

  List<AccountDetailModel> list = [];
  @override
  void initState() {
    BlocProvider.of<AccountBloc>(context).add(AccountListFetchEvent());
    currentAccount = widget.selectedAccount;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state is AccountListLoaded) {
          setState(() {
            list = state.list;
          });
        }
      },
      child: Container(
        decoration: ConstantDecoration.bottomSheet,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(Constant.margin, Constant.margin, Constant.margin, 0),
                child: Text(
                  '选择账本',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: ConstantFontSize.largeHeadline,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2.0,
              child: ListView.separated(
                itemBuilder: (_, int index) {
                  var account = list[index];
                  return ListTile(
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 4,
                          height: double.infinity,
                          color: account.id == currentAccount.id ? Colors.blue : Colors.white,
                        ),
                        Icon(account.icon),
                      ],
                    ),
                    title: Row(children: [
                      Text(account.name),
                      Visibility(visible: account.type == AccountType.share, child: const ShareLabel()),
                    ]),
                    contentPadding: const EdgeInsets.symmetric(vertical: Constant.margin),
                    onTap: () => onSelectedAccount(account),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return ConstantWidget.divider.list;
                },
                itemCount: list.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSelectedAccount(AccountDetailModel account) {
    if (widget.onSelectedAccount == null) return;
    widget.onSelectedAccount!(account);
  }
}
