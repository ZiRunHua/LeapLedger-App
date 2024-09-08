import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leap_ledger_app/common/global.dart';
import 'package:leap_ledger_app/model/account/model.dart';
import 'package:leap_ledger_app/view/account/user/invitation/cubit/account_user_invitation_cubit.dart';
import 'package:leap_ledger_app/widget/common/common.dart';

class AccountUserInvitation extends StatefulWidget {
  const AccountUserInvitation({super.key, required this.account});
  final AccountModel account;
  @override
  State<AccountUserInvitation> createState() => _AccountUserInvitationState();
}

class _AccountUserInvitationState extends State<AccountUserInvitation> {
  late final CommonPageController<AccountUserInvitationModle> _pageController;
  late final AccountUserInvitationCubit _cubit;

  @override
  void initState() {
    _pageController = CommonPageController<AccountUserInvitationModle>(
      refreshListener: _fetchData,
      loadMoreListener: _fetchData,
    );
    _cubit = AccountUserInvitationCubit(widget.account);
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
        child: BlocListener<AccountUserInvitationCubit, AccountUserInvitationState>(
          listener: (context, state) {
            if (state is AccountUserInvitationLoaded) {
              _pageController.addListData(state.list);
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
      leading: invitation.invitee.avatarPainterWidget,
      title: Text(invitation.invitee.username),
      subtitle: Text(invitation.invitee.email),
      trailing: _buildTrailing(invitation),
    );
  }

  Widget _buildTrailing(AccountUserInvitationModle invitation) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          invitation.status.name,
          style: TextStyle(fontSize: ConstantFontSize.largeHeadline, color: invitation.status.color),
        ),
        Text(
          invitation.inviter.username,
        ),
      ],
    );
  }
}
