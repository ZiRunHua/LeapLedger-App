part of 'enter.dart';

class TabView extends StatefulWidget {
  final IncomeExpense type;
  const TabView(this.type, {super.key});

  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> with AutomaticKeepAliveClientMixin {
  late final TransactionCategoryMappingBloc _bloc;

  List<MapEntry<TransactionCategoryFatherModel, List<TransactionCategoryModel>>> get tree =>
      widget.type == IncomeExpense.income ? _bloc.incomeCategoryTree : _bloc.expenseCategoryTree;

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    _bloc = BlocProvider.of<TransactionCategoryMappingBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<TransactionCategoryMappingBloc, TransactionCategoryMappingState>(
      buildWhen: (TransactionCategoryMappingState oldState, TransactionCategoryMappingState newState) {
        if (widget.type == IncomeExpense.expense && newState is TransactionCategoryMappingExpenseLoaded) {
          return true;
        } else if (widget.type == IncomeExpense.income && newState is TransactionCategoryMappingIncomeLoaded) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is TransactionCategoryMappingLoaded) {
          return Container(
            color: ConstantColor.greyBackground,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(Constant.padding, Constant.padding, Constant.padding, 0),
                    child: HeaderCard(state.unmapped),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: Constant.padding),
                  sliver: buildList(state.relation),
                ),
              ],
            ),
          );
        }
        return const ShimmerList();
      },
    );
  }

  Widget buildList(
    Map<int, List<TransactionCategoryBaseModel>> relation,
  ) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (_, int index) => buildCategoryGroup(tree[index].key, tree[index].value, relation),
          childCount: tree.length),
    );
  }

  Widget buildCategoryGroup(
    TransactionCategoryFatherModel father,
    List<TransactionCategoryModel> childList,
    Map<int, List<TransactionCategoryBaseModel>> relation,
  ) {
    List<Widget> childrenWidget = [];

    for (var i = 0; i < childList.length; i++) {
      if (i != 0) childrenWidget.add(ConstantWidget.divider.list);
      childrenWidget.add(buildCategory(childList[i], relation[childList[i].id]));
    }
    return Padding(
      padding: EdgeInsets.only(top: Constant.margin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.all(Constant.margin), child: Text(father.name)),
          Container(
            padding: EdgeInsets.all(Constant.padding),
            width: double.infinity,
            decoration: ConstantDecoration.cardDecoration,
            child: Column(
                mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: childrenWidget),
          )
        ],
      ),
    );
  }

  Widget buildCategory(
    TransactionCategoryModel category,
    List<TransactionCategoryBaseModel>? relation,
  ) {
    var textSize = (TextPainter(
            text: const TextSpan(text: "测试文字"),
            maxLines: 1,
            textScaler: MediaQuery.of(context).textScaler,
            textDirection: TextDirection.ltr)
          ..layout())
        .size;
    return ListTile(
        contentPadding: EdgeInsets.zero,
        minVerticalPadding: 0,
        dense: true,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: textSize.width, child: Center(child: Text(category.name))),
            const Icon(Icons.keyboard_double_arrow_left_outlined)
          ],
        ),
        title: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: Constant.margin / 2,
          runSpacing: 0,
          children: List.generate(
              relation != null ? relation.length : 0,
              (index) => GestureDetector(
                  onTap: () => onDelete(category, relation[index]),
                  child: Chip(
                    label: Text(relation![index].name, style: TextStyle(fontSize: ConstantFontSize.bodySmall)),
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: ConstantDecoration.borderRadius,
                    ),
                    backgroundColor: ConstantColor.greyButton,
                  ))),
        ),
        trailing: GestureDetector(
          child: const Icon(ConstantIcon.add),
          onTap: () => onSelect(category),
        ));
  }

  _showCustomModalBottomSheet(
      BuildContext context, List<TransactionCategoryBaseModel> unmapped, TransactionCategoryModel model) async {
    return showModalBottomSheet(
      context: context,
      builder: (_) {
        return OptionBottomSheet(unmapped: unmapped);
      },
    ).then((value) {
      if (value is TransactionCategoryBaseModel) {
        BlocProvider.of<TransactionCategoryMappingBloc>(context).add(TransactionCategoryMappingAddEvent(model, value));
      }
    });
  }

  onSelect(TransactionCategoryModel model) {
    _showCustomModalBottomSheet(
        context, _bloc.unmapped.where((element) => element.incomeExpense == widget.type).toList(), model);
  }

  onDelete(TransactionCategoryModel category, TransactionCategoryBaseModel prc) {
    BlocProvider.of<TransactionCategoryMappingBloc>(context).add(TransactionCategoryMappingDeleteEvent(category, prc));
  }
}
