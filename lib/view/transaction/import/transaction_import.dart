import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:leap_ledger_app/common/global.dart';
import 'package:leap_ledger_app/model/account/model.dart';
import 'package:leap_ledger_app/model/product/model.dart';
import 'package:leap_ledger_app/model/transaction/category/model.dart';
import 'package:leap_ledger_app/routes/routes.dart';
import 'package:leap_ledger_app/util/enter.dart';

import 'package:file_picker/file_picker.dart';
import 'package:leap_ledger_app/widget/amount/enter.dart';
import 'package:leap_ledger_app/widget/category/enter.dart';
import 'bloc/enter.dart';

part 'widget/ptc_card.dart';
part 'widget/exec_card.dart';
part 'widget/fail_dialog.dart';

class TransactionImport extends StatefulWidget {
  const TransactionImport({super.key, required this.account});
  final AccountDetailModel account;

  @override
  State<TransactionImport> createState() => _TransactionImportState();
}

class _TransactionImportState extends State<TransactionImport> {
  late final TransImportTabBloc _tabBloc;
  @override
  void initState() {
    _tabBloc = TransImportTabBloc(account: widget.account)..add(TransImportTabLoadedEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransImportTabBloc>.value(
      value: _tabBloc,
      child: BlocBuilder<TransImportTabBloc, TransImportTabState>(
        builder: (context, state) {
          if (state is TransImportTabLoaded) {
            return DefaultTabController(
              length: state.list.length,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('导入账单'),
                  bottom: TabBar(
                    tabs: state.list.map((product) => Tab(text: product.name)).toList(),
                  ),
                ),
                body: buildPage(context, state),
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(title: const Text('导入账单')),
            body: const Center(child: ConstantWidget.activityIndicator),
          );
        },
      ),
    );
  }

  Widget buildPage(BuildContext context, TransImportTabLoaded state) {
    return PageStorage(
      bucket: PageStorageBucket(),
      child: TabBarView(
        children: List.generate(state.list.length, (index) {
          return DecoratedBox(
            decoration: BoxDecoration(color: ConstantColor.greyBackground),
            child: Padding(
              padding: const EdgeInsets.all(Constant.margin),
              child: ExecCard(product: state.list[index], categoryTree: state.tree),
            ),
          );
        }),
      ),
    );
  }
}

class _Func {
  _Func();
  static Card _buildCard({required Widget child}) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(Constant.margin),
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: ConstantDecoration.borderRadius,
      ),
      child: child,
    );
  }
}
