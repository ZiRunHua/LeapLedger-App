part of 'enter.dart';

class NoAccountPage extends StatelessWidget {
  const NoAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, BoxConstraints constraints) {
        var padding = constraints.maxWidth * 0.1;
        if (constraints.minWidth > padding * 2) {
          padding = 0;
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(
                ConstantIcon.add,
                "新建共享账本",
                () {
                  var page =
                      AccountRoutes.edit(context, account: AccountDetailModel.fromJson({})..type = AccountType.share);
                  page.push();
                  if (page.getReturn() != null) {
                    BlocProvider.of<UserBloc>(context).add(SetCurrentShareAccount(page.getReturn()!));
                  }
                },
              ),
              _buildButton(Icons.send_outlined, "查看邀请", () {
                UserRoutes.pushNamed(context, UserRoutes.accountInvitation)
                    .then((value) => BlocProvider.of<ShareHomeBloc>(context).add(LoadAccountListEvent()));
              })
            ],
          ),
        );
      },
    );
  }

  Widget _buildButton(IconData icons, String text, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(Constant.margin),
        child: GestureDetector(
            onTap: () => onTap(),
            child: DecoratedBox(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200), borderRadius: ConstantDecoration.borderRadius),
              child: Padding(
                padding: EdgeInsets.all(Constant.padding),
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [Icon(icons), Text(text)]),
              ),
            )),
      ),
    );
  }
}
