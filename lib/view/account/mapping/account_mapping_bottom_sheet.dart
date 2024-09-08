import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leap_ledger_app/common/global.dart';
import 'package:leap_ledger_app/model/account/model.dart';
import 'package:leap_ledger_app/view/account/mapping/cubit/account_mapping_cubit.dart';
import 'package:leap_ledger_app/widget/common/common.dart';

typedef MappingChangeCallback = void Function(AccountMappingModel? mapping);

class AccountMappingBottomSheet extends StatefulWidget {
  const AccountMappingBottomSheet({super.key, required this.mainAccount, this.mapping, this.onMappingChange});
  final AccountDetailModel mainAccount;
  final AccountMappingModel? mapping;
  final MappingChangeCallback? onMappingChange;
  @override
  State<AccountMappingBottomSheet> createState() => _AccountMappingBottomSheetState();
}

class _AccountMappingBottomSheetState extends State<AccountMappingBottomSheet> {
  late AccountMappingCubit _cubit;
  @override
  void initState() {
    _cubit = AccountMappingCubit(widget.mainAccount, mapping: widget.mapping);
    _cubit.fetchData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountMappingCubit>.value(
      value: _cubit,
      child: BlocListener<AccountMappingCubit, AccountMappingState>(
        listener: (context, state) {
          if (state is AccountMappingChanged) {
            if (widget.onMappingChange != null) widget.onMappingChange!(_cubit.mapping);
          }
        },
        child: Container(
          decoration: ConstantDecoration.bottomSheet,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(Constant.margin, Constant.margin, Constant.margin, 0),
                  child: Text(
                    '账本关联',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: ConstantFontSize.largeHeadline),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 2.0,
                child: _buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return BlocBuilder<AccountMappingCubit, AccountMappingState>(builder: (context, state) {
      if (state is AccountListLoad || state is AccountMappingChanged) {
        if (_cubit.list.isNotEmpty) {
          return ListView.separated(
            itemBuilder: (_, int index) {
              var account = _cubit.list[index];
              return CommonListTile.fromAccountDetailModel(
                account,
                onSelect: _cubit.isCurrentMappingAccount(account),
                ontap: () {
                  if (_cubit.isCurrentMappingAccount(account)) {
                    // 确认删除
                    CommonDialog.showDeleteConfirmationDialog(context, () => _cubit.changeMapping(account));
                  } else {
                    _cubit.changeMapping(account);
                  }
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return ConstantWidget.divider.list;
            },
            itemCount: _cubit.list.length,
          );
        } else {
          return Center(child: NoData.accountText(context));
        }
      }
      return const Center(child: ConstantWidget.activityIndicator);
    });
  }
}
