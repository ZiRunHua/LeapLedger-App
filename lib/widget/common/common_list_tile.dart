part of 'common.dart';

class CommonListTile extends ListTile {
  const CommonListTile({
    super.key,
    super.leading,
    super.title,
    super.subtitle,
    super.trailing,
    super.isThreeLine = false,
    super.dense,
    super.visualDensity,
    super.shape,
    super.style,
    super.selectedColor,
    super.iconColor,
    super.textColor,
    super.titleTextStyle,
    super.subtitleTextStyle,
    super.leadingAndTrailingTextStyle,
    super.contentPadding,
    super.enabled = true,
    super.onTap,
    super.onLongPress,
    super.onFocusChange,
    super.mouseCursor,
    super.selected = false,
    super.focusColor,
    super.hoverColor,
    super.splashColor,
    super.focusNode,
    super.autofocus = false,
    super.tileColor,
    super.selectedTileColor,
    super.enableFeedback,
    super.horizontalTitleGap,
    super.minVerticalPadding,
    super.minLeadingWidth,
    super.titleAlignment,
  });

  CommonListTile.fromTransModel(
    TransactionModel model, {
    Key? key,
    bool displayUser = false,
    bool displayTime = true,
    VoidCallback? onTap,
  }) : this(
            key: key,
            dense: true,
            leading: Icon(
              model.categoryIcon,
              color: ConstantColor.primaryColor,
            ),
            title: Text(model.categoryName),
            subtitle: displayTime
                ? Text("${model.categoryFatherName}  ${DateFormat('yyyy-MM-dd').format(model.tradeTime)}")
                : Text(model.categoryFatherName),
            trailing: Text.rich(
              style: const TextStyle(fontSize: ConstantFontSize.headline, fontWeight: FontWeight.normal),
              TextSpan(
                children: displayUser
                    ? [
                        AmountTextSpan.sameHeight(
                          model.amount,
                          textStyle: const TextStyle(fontSize: ConstantFontSize.headline, fontWeight: FontWeight.w500),
                          incomeExpense: model.incomeExpense,
                          displayModel: IncomeExpenseDisplayModel.symbols,
                        ),
                        TextSpan(
                          text: "\n${model.userName}",
                          style: const TextStyle(fontSize: ConstantFontSize.body, fontWeight: FontWeight.normal),
                        )
                      ]
                    : [
                        AmountTextSpan.sameHeight(
                          model.amount,
                          textStyle: const TextStyle(fontSize: ConstantFontSize.headline, fontWeight: FontWeight.w500),
                          incomeExpense: model.incomeExpense,
                          displayModel: IncomeExpenseDisplayModel.symbols,
                        )
                      ],
              ),
              textAlign: TextAlign.right,
            ),
            onTap: onTap);

  CommonListTile.fromAccountUserModel(
    AccountUserModel model, {
    Key? key,
    VoidCallback? ontap,
    bool displayeCreatedAt = false,
  }) : this(
          key: key,
          leading: model.info.avatarPainterWidget,
          title: _UserName(
            model.info.username,
            showMinelabel: model.info.id == UserBloc.user.id,
          ),
          subtitle: Text(model.info.email),
          trailing: displayeCreatedAt
              ? Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CommonLabel(text: model.role.name),
                    Text("${DateFormat('yyyy-MM-dd').format(model.createTime)}加入")
                  ],
                )
              : CommonLabel(text: model.role.name),
          onTap: ontap,
        );

  /// 返回有编辑按钮的ListTile 可否显示编辑按钮由 [AccountRouterGuard.userEdit] 鉴权决定
  CommonListTile.canEditAccountUser(
    BuildContext context, {
    required AccountUserModel accountUser,
    required AccountDetailModel account,
    required void Function(AccountUserModel) onEdit,
    Key? key,
  }) : this(
            key: key,
            leading: accountUser.info.avatarPainterWidget,
            title: _UserName(
              accountUser.info.username,
              showMinelabel: accountUser.info.id == UserBloc.user.id,
            ),
            subtitle: Text(accountUser.info.email),
            trailing: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CommonLabel(text: accountUser.role.name),
                    Offstage(
                      offstage: false == AccountRouterGuard.userEdit(account: account) ||
                          accountUser.info.id == UserBloc.user.id,
                      child: GestureDetector(
                        onTap: () async {
                          var page = AccountRoutes.userEdit(context, accountUser: accountUser, accoount: account);
                          await page.showDialog();
                          var result = page.getResult();
                          if (result == null) {
                            return;
                          }
                          onEdit(result);
                        },
                        child: const Icon(Icons.edit_sharp, color: Colors.black54),
                      ),
                    )
                  ],
                ),
                Text("${DateFormat('yyyy-MM-dd').format(accountUser.createTime)}加入")
              ],
            ));
  CommonListTile.fromAccountDetailModel(
    AccountDetailModel model, {
    Key? key,
    VoidCallback? ontap,
    bool onSelect = false,
  }) : this(
          key: key,
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 4,
                height: double.infinity,
                color: onSelect ? Colors.blue : Colors.white,
              ),
              Icon(model.icon),
            ],
          ),
          title: Text(model.name),
          subtitle: Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(model.createTime)),
          onTap: ontap,
        );
}

class _UserName extends StatelessWidget {
  const _UserName(this.text, {required this.showMinelabel});
  final String text;
  final bool showMinelabel;
  @override
  Widget build(BuildContext context) {
    if (showMinelabel) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text),
          const Padding(padding: EdgeInsets.only(left: Constant.margin / 2), child: CommonLabel(text: "我"))
        ],
      );
    }
    return Text(text);
  }
}
