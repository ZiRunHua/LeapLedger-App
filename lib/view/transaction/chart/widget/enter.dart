import 'dart:math';

import 'package:intl/intl.dart' show DateFormat;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:keepaccount_app/api/model/model.dart';
import 'package:keepaccount_app/common/global.dart';
import 'package:keepaccount_app/model/common/model.dart';
import 'package:keepaccount_app/model/transaction/model.dart';
import 'package:keepaccount_app/view/transaction/chart/model/enter.dart';
import 'package:keepaccount_app/widget/amount/enter.dart';
import 'package:keepaccount_app/widget/common/common.dart';

part 'total_header.dart';
part 'category_pie_chart.dart';
part 'category_amount_rank.dart';
part 'statistics_line_chart.dart';
part 'transaction_rank.dart';

class ExpandedView extends StatefulWidget {
  const ExpandedView({
    super.key,
    required this.children,
  });
  final List<Widget> children;
  @override
  State<ExpandedView> createState() => _ExpandedViewState();
}

class _ExpandedViewState extends State<ExpandedView> with SingleTickerProviderStateMixin {
  final int initialDisplays = 3;
  late final AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..addListener(() => setState(() {}));
    super.initState();
  }

  bool stateOfExpansion = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      alignment: Alignment.topCenter,
      child: Column(
        children: [...widget.children, _buildBottomContent()],
      ),
    );
  }

  _buildBottomContent() {
    late List<Widget> list;
    if (!stateOfExpansion) {
      list = const [
        Icon(Icons.keyboard_double_arrow_down_outlined, size: Constant.iconSize),
        Text("展开", style: TextStyle(fontSize: ConstantFontSize.largeHeadline)),
      ];
    } else {
      list = const [
        Icon(Icons.keyboard_double_arrow_up_outlined, size: Constant.iconSize),
        Text("合起", style: TextStyle(fontSize: ConstantFontSize.largeHeadline)),
      ];
    }
    return TextButton(
      onPressed: () {
        stateOfExpansion = !stateOfExpansion;
        if (stateOfExpansion) {
          _controller.reset();
          _controller.forward();
        }
        setState(() {});
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: list,
      ),
    );
  }
}
