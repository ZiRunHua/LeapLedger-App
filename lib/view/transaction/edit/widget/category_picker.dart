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
  List<TransactionCategoryModel> categoryList = [];
  bool isNoData = false;
  int? get selected => _bloc.trans.categoryId;
  late final EditBloc _bloc;
  @override
  void initState() {
    _bloc = BlocProvider.of<EditBloc>(context);
    fetchData();
    super.initState();
  }

  void fetchData() {
    categoryList = [];
    _bloc.add(TransactionCategoryFetch(widget.type));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Widget child;
    if (isNoData) {
      child = Center(child: NoData.categoryText(context, account: BlocProvider.of<EditBloc>(context).account));
    } else if (categoryList.isEmpty) {
      child = const Center(child: CircularProgressIndicator());
    } else {
      child = _buildCategoryGridView();
    }
    return BlocListener<EditBloc, EditState>(
      listener: (context, state) {
        if (widget.type == IncomeExpense.income && state is IncomeCategoryPickLoaded) {
          setState(() {
            categoryList = state.tree;
            isNoData = categoryList.isEmpty;
          });
        } else if (widget.type == IncomeExpense.expense && state is ExpenseCategoryPickLoaded) {
          setState(() {
            categoryList = state.tree;
            isNoData = categoryList.isEmpty;
          });
        } else if (state is AccountChanged) {
          fetchData();
        }
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(Constant.padding, Constant.padding, Constant.padding, 0),
        color: ConstantColor.greyBackground,
        child: child,
      ),
    );
  }

  Widget _buildCategoryGridView() {
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
          return CategoryIconAndName(
            onTap: _onTap,
            category: categoryList[index],
            isSelected: categoryList[index].id == selected,
          );
        });
  }

  void _onTap(TransactionCategoryModel category) {
    _bloc.trans.categoryId = category.id;
    _bloc.trans.incomeExpense = category.incomeExpense;
    setState(() {});
  }
}
