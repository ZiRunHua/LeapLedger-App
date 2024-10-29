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
              Center(
                child: Padding(
                  padding: EdgeInsets.all(Constant.padding),
                  child: Text(
                    '选择关联账本',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: ConstantFontSize.largeHeadline),
                  ),
                ),
              ),
             _buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return BlocBuilder<AccountMappingCubit, AccountMappingState>(builder: (context, state) {
      if (state is! AccountListLoad && state is! AccountMappingChanged) {
        return const Center(child: ConstantWidget.activityIndicator);
      }
      if (_cubit.list.isEmpty) {
        return Center(child: NoData.accountText(context));
      }
      if (_cubit.list.length <= 5) {
        return Column(
          children: List.generate(
            _cubit.list.length * 2 - 1,
            (index) {
              if (index % 2 != 0) {
                return ConstantWidget.divider.list;
              }
              return _buildOne(_cubit.list[index~/2]);
            },
          ),
        );
      }
      return SizedBox(
                height: MediaQuery.of(context).size.height / 2.0,
                child:ListView.separated(
        itemBuilder: (_, int index) => _buildOne(_cubit.list[index]),
        separatorBuilder: (BuildContext context, int index) {
          return ConstantWidget.divider.list;
        },
        itemCount: _cubit.list.length,
      ));
    });
  }

  _buildOne(AccountDetailModel account) {
    return CommonListTile.fromAccountDetailModel(
      account,
      onSelect: _cubit.isCurrentMappingAccount(account),
      ontap: () {
        if (_cubit.isCurrentMappingAccount(account)) {
          CommonDialog.showDeleteConfirmationDialog(context, () => _cubit.changeMapping(account));
        } else {
          _cubit.changeMapping(account);
        }
      },
    );
  }
}
