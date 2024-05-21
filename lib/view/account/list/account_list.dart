part of "enter.dart";

class AccountList extends StatefulWidget {
  const AccountList({Key? key, required this.selectedAccount, this.onSelectedAccount}) : super(key: key);
  final AccountDetailModel selectedAccount;
  final SelectAccountCallback? onSelectedAccount;

  @override
  AccountListState createState() => AccountListState();
}

class AccountListState extends State<AccountList> {
  late AccountDetailModel selectedAccount;
  late List<AccountDetailModel> list;
  @override
  void initState() {
    selectedAccount = widget.selectedAccount;
    list = [];
    BlocProvider.of<AccountBloc>(context).add(AccountListFetchEvent());
    super.initState();
  }

  Widget listener(Widget widget) {
    return BlocListener<AccountBloc, AccountState>(
      listener: (_, state) {
        if (state is AccountListLoaded) {
          setState(() {
            list = state.list;
          });
        }
      },
      child: widget,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (list.isEmpty) {
      child = const ShimmerList();
    } else {
      child = _listView();
    }
    return listener(
      Scaffold(
        appBar: AppBar(title: const Text('我的账本'), actions: [
          IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => AccountRoutes.edit(context).push())
        ]),
        body: child,
      ),
    );
  }

  _listView() {
    return ListView.separated(
      itemCount: list.length,
      itemBuilder: (_, index) {
        final account = list[index];
        return ListTile(
          leading: _buildLeading(account, selectedAccount.id),
          contentPadding: const EdgeInsets.only(left: Constant.padding, right: Constant.smallPadding),
          horizontalTitleGap: 0,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                account.name,
                style: const TextStyle(fontSize: ConstantFontSize.largeHeadline),
              ),
              Visibility(visible: account.type == AccountType.share, child: const ShareLabel()),
            ],
          ),
          subtitle: Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(account.createTime)),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            Offstage(
              offstage: account.type != AccountType.share,
              child: CommonLabel(text: account.role.name),
            ),
            IconButton(
              onPressed: () async => _onClickAccount(list[index]),
              icon: const Icon(Icons.more_vert, size: 32),
            )
          ]),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return ConstantWidget.divider.indented;
      },
    );
  }

  _onClickAccount(AccountDetailModel account) async {
    if (widget.onSelectedAccount == null) return;
    var newAccount = await widget.onSelectedAccount!(account);
    if (mounted && newAccount != null) {
      selectedAccount = newAccount;
      setState(() {});
    }
  }
}
