part of "enter.dart";

class AccountListBottomSheet extends StatefulWidget {
  const AccountListBottomSheet({
    required this.selectedAccount,
    this.onSelectedAccount,
    this.type = ViewAccountListType.all,
    super.key,
  });
  final AccountDetailModel selectedAccount;
  final SelectAccountCallback? onSelectedAccount;
  final ViewAccountListType type;
  @override
  State<AccountListBottomSheet> createState() => _AccountListBottomSheetState();
}

class _AccountListBottomSheetState extends State<AccountListBottomSheet> {
  late AccountDetailModel selectedAccount;

  @override
  void initState() {
    _fetchData();
    selectedAccount = widget.selectedAccount;
    super.initState();
  }

  void _fetchData() {
    switch (widget.type) {
      case ViewAccountListType.onlyCanEdit:
        BlocProvider.of<AccountBloc>(context).add(CanEditAccountListFetchEvent());
      default:
        BlocProvider.of<AccountBloc>(context).add(AccountListFetchEvent());
    }
  }

  static const double elementHight = 72;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      buildWhen: (_, state) => state is CanEditAccountListLoaded || state is AccountListLoaded,
      builder: (context, state) {
        List<AccountDetailModel> list = [];
        if (state is CanEditAccountListLoaded) {
          list = state.list;
        } else if (state is AccountListLoaded) {
          list = state.list;
        }

        var maxHight = MediaQuery.of(context).size.height / 2;
        Widget listWidget;
        if (list.isEmpty) {
          listWidget = const SizedBox(
            height: elementHight,
            child: Center(
              child: ConstantWidget.activityIndicator,
            ),
          );
        } else if (maxHight > elementHight * list.length + Constant.margin * (list.length - 1)) {
          listWidget = Column(
            children: List.generate(list.length, (index) => _buildAccount(list[index])),
          );
        } else {
          listWidget = SizedBox(
              height: maxHight,
              child: ListView.separated(
                itemBuilder: (_, int index) => _buildAccount(list![index]),
                separatorBuilder: (BuildContext context, int index) {
                  return ConstantWidget.divider.list;
                },
                itemCount: list!.length,
              ));
        }

        return Container(
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
              listWidget
            ],
          ),
        );
      },
    );
  }

  Widget _buildAccount(AccountDetailModel account) {
    return ListTile(
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 4,
            height: double.infinity,
            color: account.id == selectedAccount.id ? Colors.blue : Colors.white,
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
  }

  void onSelectedAccount(AccountDetailModel account) {
    if (widget.onSelectedAccount == null) return;
    widget.onSelectedAccount!(account);
  }
}
