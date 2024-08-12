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

  @override
  void didUpdateWidget(covariant AccountListBottomSheet oldWidget) {
    if (widget.selectedAccount != oldWidget.selectedAccount) {
      selectedAccount = widget.selectedAccount;
    }
    super.didUpdateWidget(oldWidget);
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
            children: List.generate(list.length * 2 - 1, (index) {
              if (index % 2 == 0) {
                return _buildAccount(list[index ~/ 2]);
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: Constant.margin),
                  child: ConstantWidget.divider.indented,
                );
              }
            }),
          );
        } else {
          listWidget = SizedBox(
              height: maxHight,
              child: ListView.separated(
                itemBuilder: (_, int index) => _buildAccount(list[index]),
                separatorBuilder: (BuildContext context, int index) {
                  return ConstantWidget.divider.list;
                },
                itemCount: list.length,
              ));
        }

        return DecoratedBox(
          decoration: ConstantDecoration.bottomSheet,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(Constant.margin),
                  child: Text(
                    '选择账本',
                    style: TextStyle(fontSize: ConstantFontSize.largeHeadline, fontWeight: FontWeight.bold),
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
      horizontalTitleGap: 0,
      contentPadding: const EdgeInsets.only(left: Constant.padding, right: Constant.smallPadding),
      leading: _buildLeading(account, selectedAccount.id),
      title: Row(
        children: [
          Text(account.name),
          Visibility(visible: account.type == AccountType.share, child: const ShareLabel()),
        ],
      ),
      onTap: () => onSelectedAccount(account),
    );
  }

  void onSelectedAccount(AccountDetailModel account) {
    if (widget.onSelectedAccount == null) return;
    widget.onSelectedAccount!(account);
  }
}
