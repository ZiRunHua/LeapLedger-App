part of '../transaction_edit.dart';

class CategoryPicker extends StatefulWidget {
  const CategoryPicker({this.initialVlaue, required this.type, required this.onSave, super.key});
  final int? initialVlaue;
  final IncomeExpense type;
  final Function(TransactionCategoryModel category) onSave;
  @override
  State<CategoryPicker> createState() => _CategoryPickerState();
}

class _CategoryPickerState extends State<CategoryPicker> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List<TransactionCategoryModel> categoryList = [];
  bool isNoData = false;
  int? selected;
  @override
  void initState() {
    fetchData();
    selected = widget.initialVlaue;
    super.initState();
  }

  void fetchData() {
    categoryList = [];
    selected = null;
    BlocProvider.of<EditBloc>(context).add(TransactionCategoryFetch(widget.type));
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
        shrinkWrap: true, // 让网格视图适应内容大小
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
    widget.onSave(category);
    setState(() {
      selected = category.id;
    });
  }
}
