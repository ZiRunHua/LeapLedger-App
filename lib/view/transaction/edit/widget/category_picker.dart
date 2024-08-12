part of '../transaction_edit.dart';

class CategoryPicker extends StatefulWidget {
  const CategoryPicker({required this.type, super.key});

  final IncomeExpense type;
  @override
  State<CategoryPicker> createState() => _CategoryPickerState();
}

class _CategoryPickerState extends State<CategoryPicker> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  int? get selected => _bloc.transInfo.categoryId;
  late final EditBloc _bloc = BlocProvider.of<EditBloc>(context);
  late final IncomeExpense type;
  late final CategoryQueryCond queryCond;

  @override
  void initState() {
    type = widget.type;
    queryCond = CategoryQueryCond(type: type);
    fetchData();
    super.initState();
  }

  void fetchData() {
    BlocProvider.of<CategoryBloc>(context).add(CategoryListLoadEvent(_bloc.account, cond: queryCond));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Widget child;

    child = BlocBuilder<CategoryBloc, CategoryState>(
      buildWhen: (context, state) {
        if (state is CategoryListLoadedState && state.current(account: _bloc.account, cond: queryCond)) {
          if (state.list.isNotEmpty) {
            var selected = state.list.firstWhere(
              (element) => element.id == _bloc.transInfo.categoryId,
              orElse: () => state.list.first,
            );
            _bloc.transInfo.setCategory(selected);
          }
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is CategoryListLoadedState && state.current(account: _bloc.account, cond: queryCond)) {
          if (state.list.isEmpty) {
            return Center(child: NoData.categoryText(context, account: BlocProvider.of<EditBloc>(context).account));
          }
          return _buildCategoryGridView(state.list);
        }
        return SizedBox();
      },
    );

    child = BlocListener<EditBloc, EditState>(
      listener: (context, state) {
        if (state is AccountChanged) fetchData();
      },
      child: child,
    );
    return Container(
      padding: const EdgeInsets.fromLTRB(Constant.padding, Constant.padding, Constant.padding, 0),
      color: ConstantColor.greyBackground,
      child: child,
    );
  }

  Widget _buildCategoryGridView(List<TransactionCategoryModel> categoryList) {
    return GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: categoryList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: Constant.padding,
          mainAxisSpacing: Constant.padding,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (BuildContext context, int index) {
          return CategoryIconAndName<TransactionCategoryModel>(
            onTap: _onTap,
            category: categoryList[index],
            isSelected: categoryList[index].id == selected,
          );
        });
  }

  void _onTap(TransactionCategoryModel category) {
    _bloc.transInfo.setCategory(category);
    setState(() {});
  }
}
