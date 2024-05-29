import 'dart:math';

import 'package:intl/intl.dart' show DateFormat;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
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
part 'transaction_amount_rank.dart';

class CommonExpandedView extends StatefulWidget {
  const CommonExpandedView({
    super.key,
    required this.children,
  });
  final List<Widget> children;
  @override
  State<CommonExpandedView> createState() => _CommonExpandedViewState();
}

class _CommonExpandedViewState extends State<CommonExpandedView> with SingleTickerProviderStateMixin {
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
        children: [
          ...List.generate(
            stateOfExpansion ? widget.children.length : min(initialDisplays, widget.children.length),
            (index) => widget.children[index],
          ),
          _buildBottomContent()
        ],
      ),
    );
  }

  _buildBottomContent() {
    late List<Widget> list;
    if (!stateOfExpansion) {
      list = const [
        Icon(Icons.keyboard_double_arrow_down_outlined, size: ConstantFontSize.body + 2),
        Text("展开", style: TextStyle(fontSize: ConstantFontSize.body)),
      ];
    } else {
      list = const [
        Icon(Icons.keyboard_double_arrow_up_outlined, size: ConstantFontSize.body + 2),
        Text("合起", style: TextStyle(fontSize: ConstantFontSize.body)),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: list,
      ),
    );
  }
}
