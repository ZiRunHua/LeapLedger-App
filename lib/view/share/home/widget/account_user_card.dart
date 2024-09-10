part of 'enter.dart';

class AccountUserCard extends StatefulWidget {
  const AccountUserCard({super.key});

  @override
  State<AccountUserCard> createState() => _AccountUserCardState();
}

class _AccountUserCardState extends State<AccountUserCard> {
  @override
  Widget build(BuildContext context) {
    return _Func._buildCard(
        title: "成员",
        child: BlocBuilder<ShareHomeBloc, ShareHomeState>(
          buildWhen: (_, state) {
            return state is AccountUserLoaded || state is AccountUserLoading;
          },
          builder: (context, state) {
            if (state is AccountUserLoaded) {
              return ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return CommonListTile.fromAccountUserModel(state.list[index],
                      ontap: () => AccountRoutes.userDetail(context,
                              accountUser: state.list[index],
                              accoount: ShareHomeBloc.account!, onEdit: (AccountUserModel newAccountUser) {
                            state.list[index] = newAccountUser;
                            setState(() {});
                          }).showModalBottomSheet());
                },
                separatorBuilder: (context, index) {
                  return ConstantWidget.divider.list;
                },
                itemCount: state.list.length,
              );
            }
            return const SizedBox(
              width: double.infinity,
              height: 50,
            );
          },
        ),
        action: Offstage(
          offstage: ShareHomeBloc.account == null
              ? true
              : false == AccountRouterGuard.userInvite(account: ShareHomeBloc.account!),
          child: GestureDetector(
            onTap: () => onPressedAdd(ShareHomeBloc.account!),
            child: const Icon(ConstantIcon.add),
          ),
        ));
  }

  onPressedAdd(AccountDetailModel account) {
    UserRoutes.pushSearch(context).then((userInfo) {
      if (userInfo == null) {
        return;
      }
      AccountRoutes.userInvite(context, account: account, userInfo: userInfo).showDialog();
    });
  }
}
