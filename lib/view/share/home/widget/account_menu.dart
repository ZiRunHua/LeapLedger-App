part of 'enter.dart';

class AccountMenu extends StatefulWidget {
  const AccountMenu({super.key});

  @override
  State<AccountMenu> createState() => _AccountMenuState();
}

class _AccountMenuState extends State<AccountMenu> {
  late final ShareHomeBloc _bloc;
  @override
  void initState() {
    _bloc = ShareHomeBloc.of(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ShareHomeBloc, ShareHomeState>(
          listenWhen: (context, state) {
            return state is AccountHaveChanged;
          },
          listener: (context, state) {
            setState(() {});
          },
        ),
        BlocListener<UserBloc, UserState>(
          listenWhen: (context, state) {
            return state is CurrentShareAccountChanged;
          },
          listener: (context, state) {
            _bloc.add(ChangeAccountEvent(UserBloc.currentShareAccount));
          },
        ),
      ],
      child: BlocBuilder<ShareHomeBloc, ShareHomeState>(
        buildWhen: (context, state) {
          return state is AccountListLoaded || state is NoShareAccount;
        },
        builder: (context, state) {
          if (state is AccountListLoaded && state.list.isEmpty || state is NoShareAccount) {
            return _buildCreateBox();
          } else if (state is AccountListLoaded) {
            return DefaultTextStyle.merge(
                style: const TextStyle(fontSize: ConstantFontSize.largeHeadline),
                child: PopupMenuButton<AccountDetailModel>(
                  itemBuilder: (context) {
                    return List.generate(
                      state.list.length,
                      (index) => PopupMenuItem(
                        value: state.list[index],
                        child: _buildAccount(state.list[index]),
                      ),
                    );
                  },
                  initialValue: ShareHomeBloc.account,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [_buildAccount(ShareHomeBloc.account!), const Icon(Icons.arrow_drop_down_rounded)],
                  ),
                  onSelected: (AccountDetailModel account) {
                    _bloc.add(ChangeAccountEvent(account));
                    UserBloc.of(context).add(SetCurrentShareAccount(account));
                  },
                ));
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildAccount(AccountModel account) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(account.icon, size: ConstantFontSize.largeHeadline),
        const SizedBox(width: Constant.margin / 2),
        Text(account.name, textAlign: TextAlign.center)
      ],
    );
  }

  Widget _buildCreateBox() {
    return Container(
        margin: const EdgeInsets.all(Constant.margin),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: ConstantDecoration.borderRadius,
        ),
        child: const Padding(
          padding: EdgeInsets.all(Constant.padding),
          child: Column(
            children: [Text("新建共享账本"), Icon(ConstantIcon.add)],
          ),
        ));
  }
}
