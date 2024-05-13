part of "enter.dart";

class AccountListBottomSheet extends StatefulWidget {
  const AccountListBottomSheet(
      {required this.selectedAccount, this.onSelectedAccount, this.type = ViewAccountListType.all, super.key});
  final AccountDetailModel selectedAccount;
  final SelectAccountCallback? onSelectedAccount;
  final ViewAccountListType type;
  @override
  State<AccountListBottomSheet> createState() => _AccountListBottomSheetState();
}

class _AccountListBottomSheetState extends State<AccountListBottomSheet> {
  late AccountDetailModel currentAccount;

  @override
  void initState() {
    _fetchData();
    currentAccount = widget.selectedAccount;
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

  List<AccountDetailModel>? list;
  Widget _bloclistener(Widget child) {
    switch (widget.type) {
      case ViewAccountListType.onlyCanEdit:
        return BlocListener<AccountBloc, AccountState>(
            listener: (context, state) {
              if (state is CanEditAccountListLoaded) {
                setState(() => list = state.list);
              }
            },
            child: child);
      default:
        return BlocListener<AccountBloc, AccountState>(
            listener: (context, state) {
              if (state is AccountListLoaded) {
                setState(() => list = state.list);
              }
            },
            child: child);
    }
  }

  static const double elementHight = 72;
  @override
  Widget build(BuildContext context) {
    var maxHight = MediaQuery.of(context).size.height / 2;
    Widget listWidget;
    if (list == null) {
      listWidget = const SizedBox(
        height: elementHight,
        child: Center(
          child: ConstantWidget.activityIndicator,
        ),
      );
    } else if (maxHight > elementHight * list!.length + Constant.margin * (list!.length - 1)) {
      listWidget = Column(
        children: List.generate(list!.length, (index) => _buildAccount(list![index])),
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

    return _bloclistener(
      Container(
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
      ),
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
  }

  void onSelectedAccount(AccountDetailModel account) {
    if (widget.onSelectedAccount == null) return;
    widget.onSelectedAccount!(account);
  }
}

typedef void OnWidgetSizeChange(Size size);

class MeasureSizeRenderObject extends RenderProxyBox {
  Size? oldSize;
  OnWidgetSizeChange onChange;

  MeasureSizeRenderObject(this.onChange);

  @override
  void performLayout() {
    super.performLayout();

    Size newSize = child!.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      onChange(newSize);
    });
  }
}

class MeasureSize extends SingleChildRenderObjectWidget {
  final OnWidgetSizeChange onChange;

  const MeasureSize({
    Key? key,
    required this.onChange,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MeasureSizeRenderObject(onChange);
  }

  @override
  void updateRenderObject(BuildContext context, covariant MeasureSizeRenderObject renderObject) {
    renderObject.onChange = onChange;
  }
}
