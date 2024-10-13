import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leap_ledger_app/bloc/user/user_bloc.dart';
import 'package:leap_ledger_app/common/global.dart';
import 'package:leap_ledger_app/model/account/model.dart';
import 'package:leap_ledger_app/view/account/template/list/bloc/account_template_list_bloc.dart';
import 'package:leap_ledger_app/widget/common/common.dart';

class AccountTemplateList extends StatelessWidget {
  const AccountTemplateList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountTemplateListBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("选择账本模板"),
        ),
        body: const AccountTemplateListBody(),
      ),
    );
  }
}

class AccountTemplateListBody extends StatefulWidget {
  const AccountTemplateListBody({super.key});

  @override
  State<AccountTemplateListBody> createState() => _AccountTemplateListBodyState();
}

class _AccountTemplateListBodyState extends State<AccountTemplateListBody> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AccountTemplateListBloc>(context).add(GetListEvent());
    return BlocListener<AccountTemplateListBloc, AccountTemplateListState>(
        listener: (context, state) {
          if (state is AddAccountSuccess) {
            BlocProvider.of<UserBloc>(context).add(SetCurrentAccount(state.account));
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<AccountTemplateListBloc, AccountTemplateListState>(buildWhen: (previousState, currentState) {
          return currentState is AccountTemplateListLoading || currentState is AccountTemplateListLoaded;
        }, builder: (context, state) {
          if (state is AccountTemplateListLoaded) {
            return buildList(state.list);
          }
          return ShimmerList();
        }));
  }

  buildList(List<AccountTemplateModel> list) {
    return ListView.separated(
        itemCount: list.length ~/ 2 + list.length % 2,
        itemBuilder: (_, index) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [buildTemplate(list[index * 2]), buildTemplate(list.elementAtOrNull(index * 2 + 1))],
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(color: Colors.grey.shade400, height: 1.sp);
        });
  }

  Widget buildTemplate(AccountTemplateModel? model) {
    if (model == null) {
      return Expanded(child: Container());
    }
    return Expanded(
        child: GestureDetector(
      onTap: () {
        triggerAddEvent(model);
      },
      child: Container(
          height: 100.h,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 2.0),
            borderRadius: BorderRadius.circular(Constant.radius),
          ),
          margin: const EdgeInsets.all(16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                model.icon,
                size: Constant.iconlargeSize,
                color: Colors.black54,
              ),
              Text(
                model.name,
                style: TextStyle(fontSize: ConstantFontSize.largeHeadline, color: Colors.black87),
              )
            ],
          )),
    ));
  }

  void triggerAddEvent(AccountTemplateModel model) {
    BlocProvider.of<AccountTemplateListBloc>(context).add(UseAccountTemplate(model));
  }
}
