import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leap_ledger_app/api/api_server.dart' show UserTransactionShareConfigFlag;
import 'package:leap_ledger_app/bloc/user/config/user_config_bloc.dart';
import 'package:leap_ledger_app/common/global.dart';
import 'package:leap_ledger_app/model/user/model.dart' show UserTransactionShareConfigModel;

class UserConfigTransactionShare extends StatefulWidget {
  const UserConfigTransactionShare({super.key});

  @override
  State<UserConfigTransactionShare> createState() => _UserConfigTransactionShareState();
}

class _UserConfigTransactionShareState extends State<UserConfigTransactionShare> {
  @override
  void initState() {
    BlocProvider.of<UserConfigBloc>(context).add(UserTransactionShareConfigFetch());
    super.initState();
  }

  UserTransactionShareConfigModel? config;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("分享配置"),
      ),
      body: Container(
          color: ConstantColor.greyBackground,
          child: BlocListener<UserConfigBloc, UserConfigState>(
            listener: (context, state) {
              if (state is UserTransactionShareConfigLoaded) {
                setState(() {
                  config = state.config;
                });
              } else if (state is UserTransactionShareConfigUpdateSuccess) {
                setState(() {
                  config = state.config;
                });
              }
            },
            child: Column(
              children: _buildChildren(),
            ),
          )),
    );
  }

  List<Widget> _buildChildren() {
    if (config == null) {
      return [const Center(child: CircularProgressIndicator())];
    }
    return [
      _buildStatusSwitch(
          name: "账本",
          value: config!.account,
          onChanged: (bool value) {
            BlocProvider.of<UserConfigBloc>(context)
                .add(UserTransactionShareConfigUpdate(UserTransactionShareConfigFlag.account, value));
            // setState(() {
            //   config!.account = value;
            // });
          }),
      _buildStatusSwitch(
          name: "记录时间",
          value: config!.createTime,
          onChanged: (bool value) {
            BlocProvider.of<UserConfigBloc>(context)
                .add(UserTransactionShareConfigUpdate(UserTransactionShareConfigFlag.createTime, value));
            // setState(() {
            //   config!.createTime = value;
            // });
          }),
      _buildStatusSwitch(
          name: "更新时间",
          value: config!.updateTime,
          onChanged: (bool value) {
            BlocProvider.of<UserConfigBloc>(context)
                .add(UserTransactionShareConfigUpdate(UserTransactionShareConfigFlag.updateTime, value));
            // setState(() {
            //   config!.updateTime = value;
            // });
          }),
      _buildStatusSwitch(
          name: "备注",
          value: config!.remark,
          onChanged: (bool value) {
            BlocProvider.of<UserConfigBloc>(context)
                .add(UserTransactionShareConfigUpdate(UserTransactionShareConfigFlag.remark, value));
            // setState(() {
            //   config!.remark = value;
            // });
          }),
    ];
  }

  Widget _buildStatusSwitch({required String name, required bool value, Function(bool)? onChanged}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Constant.margin),
      child: DecoratedBox(
          decoration: const BoxDecoration(color: Colors.white),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Constant.padding),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(name),
                Switch(
                    trackOutlineColor: const WidgetStatePropertyAll<Color>(Colors.white),
                    thumbColor: const WidgetStatePropertyAll<Color>(Colors.white),
                    trackColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return ConstantColor.primaryColor;
                      }
                      return Colors.grey.shade400;
                    }),
                    value: value,
                    onChanged: onChanged,
                    trackOutlineWidth: const WidgetStatePropertyAll<double>(0)),
              ],
            ),
          )),
    );
  }
}
