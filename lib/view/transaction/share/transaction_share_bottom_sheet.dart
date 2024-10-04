import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:leap_ledger_app/common/global.dart' show Constant, ConstantColor, ConstantDecoration, ConstantFontSize;
import 'package:leap_ledger_app/model/transaction/model.dart' show TransactionShareModel;
import 'package:leap_ledger_app/util/enter.dart' show FileOperation;
import 'package:leap_ledger_app/widget/amount/enter.dart';
import 'package:leap_ledger_app/widget/common/common.dart';

class TransactionShareDialog extends StatelessWidget {
  TransactionShareDialog({super.key, required this.data});

  final TransactionShareModel data;
  final GlobalKey repaintKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.8,
      heightFactor: 0.8,
      alignment: FractionalOffset.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: _buildImage()),
          GestureDetector(
              onTap: () => _onSaveImage(),
              child: Container(
                margin: EdgeInsets.only(top: Constant.padding),
                decoration: BoxDecoration(
                  color: ConstantColor.greyButton,
                  borderRadius: BorderRadius.circular(90),
                ),
                width: 48.sp,
                height: 48.sp,
                child: Icon(Icons.download_outlined, size: 28),
              )),
        ],
      ),
    );
  }

  Widget _buildImage() {
    List<Widget> children = [];
    if (data.categoryIcon != null && data.categoryName != null) {
      children.add(_buildHeader(data.categoryIcon!, data.categoryName!));
    }
    children.add(_buildAmount());
    List<optionWidget> options = [];
    if (data.tradeTime != null) {
      options.add(_buildDetail("时间", DateFormat('yyyy-MM-dd').format(data.tradeTime!)));
    }
    if (data.accountName != null) {
      options.add(_buildDetail("账本", data.accountName!));
    }
    if (data.createTime != null) {
      options.add(_buildDetail("记录时间", DateFormat('yyyy-MM-dd HH:mm:ss').format(data.createTime!)));
    }
    if (data.updateTime != null) {
      options.add(_buildDetail("更新时间", DateFormat('yyyy-MM-dd HH:mm:ss').format(data.updateTime!)));
    }
    if (data.remark != null) {
      options.add(_buildDetail("备注", data.remark == "" ? "无" : data.remark!));
    }
    children.add(
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(options.length, (index) => options[index].title).toList()),
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(options.length, (index) => options[index].value).toList(),
          )
        ],
      ),
    );
    return RepaintBoundary(
        key: repaintKey,
        child: AspectRatio(
          aspectRatio: 0.6,
          child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: ConstantDecoration.borderRadius,
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage("assets/image/share_bg.png"),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.bottomCenter,
                ),
              ),
              child: FractionallySizedBox(
                widthFactor: 0.7,
                heightFactor: 0.7,
                alignment: FractionalOffset.center,
                child: Column(children: children),
              )),
        ));
  }

  Widget _buildHeader(IconData icon, String name) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: ConstantColor.secondaryColor,
            borderRadius: BorderRadius.circular(90),
          ),
          width: 48,
          height: 48,
          child: Icon(icon, size: 28),
        ),
        SizedBox(
          height: Constant.margin,
        ),
        Text(
          name,
          style: TextStyle(fontSize: ConstantFontSize.headline),
        ),
      ],
    );
  }

  Widget _buildAmount() {
    return Padding(
      padding: EdgeInsets.only(top: Constant.smallPadding, bottom: Constant.padding),
      child: Text.rich(
        AmountTextSpan.sameHeight(
          data.amount,
          incomeExpense: data.incomeExpense,
          displayModel: IncomeExpenseDisplayModel.symbols,
          textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.black),
        ),
      ),
    );
  }

  optionWidget _buildDetail(String title, String value) {
    return optionWidget(title: Text(title, style: TextStyle(color: Colors.black54)), value: Text(value));
  }

  Future<Uint8List?> _getImageData() async {
    if (repaintKey.currentContext == null) {
      return null;
    }
    BuildContext context = repaintKey.currentContext!;
    RenderRepaintBoundary boundary = context.findRenderObject() as RenderRepaintBoundary;
    double dpr = MediaQuery.of(context).devicePixelRatio;
    var image = await boundary.toImage(pixelRatio: dpr);
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    if (byteData == null) {
      return null;
    }
    Uint8List imageBytes = byteData.buffer.asUint8List();
    return imageBytes;
  }

  void _onSaveImage() async {
    Uint8List? imageByte = await _getImageData();
    if (imageByte == null) {
      return;
    }
    var path = await FileOperation.saveImage(imageByte);
    if (path != null) {
      CommonToast.tipToast("保存成功");
    } else {
      CommonToast.tipToast("保存失败");
    }
  }
}

class optionWidget {
  final Widget title, value;
  optionWidget({required this.title, required this.value});
}
