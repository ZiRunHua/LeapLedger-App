import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leap_ledger_app/common/global.dart';
import 'package:leap_ledger_app/model/account/model.dart';
import 'package:leap_ledger_app/widget/common/common.dart';

import 'cubit/user_account_invitation_cubit.dart';

class UserAccountInvitation extends StatefulWidget {
  const UserAccountInvitation({super.key});

  @override
  State<UserAccountInvitation> createState() => _UserAccountInvitationState();
}

class _UserAccountInvitationState extends State<UserAccountInvitation> {
  late final CommonPageController<AccountUserInvitationModle> _pageController;
  late final UserAccountInvitationCubit _cubit;

  @override
  void initState() {
    _pageController = CommonPageController<AccountUserInvitationModle>(
      refreshListener: _fetchData,
      loadMoreListener: _fetchData,
    );
    _cubit = UserAccountInvitationCubit();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _fetchData({required int offset, required int limit}) {
    _cubit.fetchData(limit, offset);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("邀请")),
      body: BlocProvider.value(
        value: _cubit,
        child: BlocListener<UserAccountInvitationCubit, UserAccountInvitationState>(
          listener: (context, state) {
            if (state is UserAccountInvitationLoaded) {
              _pageController.addListData(state.list);
            } else if (state is UserAccountInvitationUpdated) {
              _pageController.updateListItemWhere((element) => element.id == state.item.id, state.item);
            }
          },
          child: CommonPageList<AccountUserInvitationModle>(
            buildListOne: _buildListTile,
            prototypeData: AccountUserInvitationModle.prototypeData(DateTime.now()),
            initRefresh: true,
            controller: _pageController,
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(AccountUserInvitationModle invitation) {
    return ListTile(
      leading: Icon(invitation.account.icon, size: Constant.iconlargeSize, color: ConstantColor.primaryColor),
      title: Text(invitation.account.name),
      subtitle: Text(
        "来自${invitation.inviter.username}的邀请",
        style: const TextStyle(color: ConstantColor.greyText),
      ),
      trailing: _buildTrailing(invitation),
    );
  }

  Widget _buildTrailing(AccountUserInvitationModle invitation) {
    switch (invitation.status) {
      case AccountUserInvitationStatus.waiting:
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildButton("拒绝", () => _cubit.refuse(invitation)),
            _buildButton("同意", () => _cubit.accpect(invitation))
          ],
        );
      default:
        return Text(
          invitation.status.name,
          style: TextStyle(fontSize: ConstantFontSize.largeHeadline, color: ConstantColor.greyText),
        );
    }
  }

  Widget _buildButton(String text, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.only(left: Constant.margin),
      child: GestureDetector(
        onTap: onTap,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: ConstantColor.greyBackground,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            child: Text(
              text,
              style: TextStyle(color: Colors.black, fontSize: ConstantFontSize.body),
            ),
          ),
        ),
      ),
    );
  }
}
