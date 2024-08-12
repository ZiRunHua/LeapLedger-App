part of 'enter.dart';

class CategoryAmountRank extends StatefulWidget {
  const CategoryAmountRank({super.key, required this.data});
  final List<TransactionCategoryAmountRankApiModel> data;
  @override
  State<CategoryAmountRank> createState() => _CategoryAmountRankState();
}

enum PageStatus { loading, expanding, contracting, noData }

class _CategoryAmountRankState extends State<CategoryAmountRank> with SingleTickerProviderStateMixin {
  late List<TransactionCategoryAmountRankApiModel> data;
  late int maxAmount = 0;

  late final AnimationController _controller;
  @override
  void initState() {
    initData();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..addListener(() => setState(() {}));

    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.forward());
    super.initState();
  }

  @override
  void didUpdateWidget(CategoryAmountRank oldWidget) {
    if (widget.data != oldWidget.data) {
      initData();
    }
    super.didUpdateWidget(oldWidget);
  }

  void initData() {
    data = widget.data;
    if (data.length > 0) {
      maxAmount = data.first.amount;
    } else {
      maxAmount = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (data.length == 0) return SizedBox();
    return _Func._buildCard(
      title: "本月支出排行",
      child: CommonExpansionList(
        children: List.generate(data.length, (index) => _buildListTile(data[index])),
      ),
    );
  }

  _buildListTile(TransactionCategoryAmountRankApiModel data) {
    return GestureDetector(
        onTap: () => _Func._pushTransactionFlow(
            context,
            TransactionQueryCondModel(
                accountId: UserBloc.currentAccount.id,
                categoryIds: {data.category.id},
                startTime: HomeBloc.startTime,
                endTime: HomeBloc.endTime)),
        child: ListTile(
          leading: Icon(data.category.icon, color: ConstantColor.primaryColor),
          title: Text(
            data.category.name,
            style: const TextStyle(fontSize: ConstantFontSize.body),
          ),
          subtitle: data.amount != 0 ? _buildProgress(data.amount / maxAmount) : _buildProgress(0),
          trailing: Padding(
            padding: EdgeInsets.zero,
            child: AmountText.sameHeight(
              data.amount,
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black87),
            ),
          ),
        ));
  }

  _buildProgress(double value) {
    return LinearProgressIndicator(
      value: min(_controller.value, value),
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      valueColor: const AlwaysStoppedAnimation<Color>(ConstantColor.primaryColor),
      borderRadius: BorderRadius.circular(2),
    );
  }
}

class AmountDivider extends StatelessWidget {
  final double proportion;
  const AmountDivider(this.proportion, {super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // 获取当前渲染的组件的宽度
        double currentWidth = constraints.maxWidth;

        return Divider(
            color: ConstantColor.secondaryColor,
            height: 0.5,
            thickness: 5,
            endIndent: currentWidth - currentWidth * proportion);
      },
    );
  }
}
