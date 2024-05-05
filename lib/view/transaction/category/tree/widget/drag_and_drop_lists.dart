part of '../transaction_category_tree.dart';

class _DragAndDropLists extends StatefulWidget {
  final IncomeExpense incomeExpense;
  const _DragAndDropLists({Key? key, required this.incomeExpense}) : super(key: key);

  @override
  _DragAndDropListsState createState() => _DragAndDropListsState();
}

class _DragAndDropListsState extends State<_DragAndDropLists> with AutomaticKeepAliveClientMixin {
  late final TransactionCategoryTreeBloc _bloc;
  bool get canEdit => _bloc.canEdit;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    _bloc = BlocProvider.of<TransactionCategoryTreeBloc>(context);
    _bloc.add(LoadEvent(widget.incomeExpense));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<TransactionCategoryTreeBloc, TransactionCategoryTreeState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return buildShimmerList();
        } else if (state is LoadedState) {
          return _buildDragAndDropLists(state.list);
        }
        return Container();
      },
    );
  }

  _buildDragAndDropLists(List<CategoryData> list) {
    return Container(
      color: ConstantColor.greyBackground,
      padding: const EdgeInsets.symmetric(horizontal: Constant.padding),
      child: DragAndDropLists(
          children: List.generate(list.length, (index) => _buildChildrenList(list[index].father, list[index].children)),
          onItemReorder: _onItemReorder,
          onListReorder: _onListReorder,
          listPadding: const EdgeInsets.only(top: Constant.margin),
          listGhost: Container(
            padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(),
              borderRadius: ConstantDecoration.borderRadius,
            ),
          ),
          listDecoration: ConstantDecoration.cardDecoration,
          itemDivider: ConstantWidget.divider.indented,
          contentsWhenEmpty: const Text("快来设置交易类型！")),
    );
  }

  _onItemReorder(int oldChildIndex, int oldFatherIndex, int newChildIndex, int newFatherIndex) {
    _bloc.add(MoveChildEvent(oldChildIndex, oldFatherIndex, newChildIndex, newFatherIndex));
  }

  _onListReorder(int oldFatherIndex, int newFatherIndex) {
    _bloc.add(MoveFatherEvent(oldFatherIndex, newFatherIndex));
  }

  DragAndDropListExpansion _buildChildrenList(
      TransactionCategoryFatherModel father, List<TransactionCategoryModel> children) {
    return DragAndDropListExpansion(
      canDrag: _bloc.canEdit,
      initiallyExpanded: true,
      disableTopAndBottomBorders: true,
      title: Text(father.name, style: const TextStyle(color: ConstantColor.greyText, fontSize: ConstantFontSize.body)),
      trailing: _actionButtons(() => _updateFather(father), () => _deleteFather(father)),
      children: List.generate(children.length, (index) => _buildChild(children[index])),
      listKey: ObjectKey(father),
      lastTarget: _buildAddButton(father),
      contentsWhenEmpty: const SizedBox(height: 1),
    );
  }

  Widget? _buildAddButton(TransactionCategoryFatherModel father) {
    if (!_bloc.canEdit) return null;
    return Center(
        child: TextButton(
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add_circle_outline, size: ConstantFontSize.body, color: ConstantColor.greyText),
          Text("新建子类型", style: TextStyle(fontSize: ConstantFontSize.body, color: ConstantColor.greyText))
        ],
      ),
      onPressed: () async {
        var page = TransactionCategoryRoutes.editNavigator(
          context,
          account: _bloc.account,
          transactionCategory: TransactionCategoryModel.toAdd(father),
        );
        await page.push();
        if (page.result != null) {
          _bloc.add(AddChildEvent(page.result!));
        }
      },
    ));
  }

  _buildChild(TransactionCategoryModel child) {
    return DragAndDropItem(
      child: ListTile(
          leading: Icon(child.icon, color: ConstantColor.primaryColor),
          title: Text(child.name),
          trailing: _actionButtons(() => _updateChild(child), () => _deleteChild(child))),
    );
  }

  Widget? _actionButtons(Function updateFunc, Function deleteFunc) {
    if (!canEdit) {
      return null;
    }
    return Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => updateFunc(),
            icon: const Icon(Icons.edit, color: ConstantColor.greyButtonIcon),
          ),
          IconButton(
            onPressed: () => deleteFunc(),
            icon: const Icon(Icons.delete, color: ConstantColor.greyButtonIcon),
          )
        ]);
  }

  _updateFather(TransactionCategoryFatherModel father) async {
    //编辑
    var page = TransactionCategoryRoutes.fatherEditNavigator(context, account: _bloc.account, father: father);
    await page.showDialog();
    var result = page.getReturn();
    if (result != null && mounted) {
      _bloc.add(UpdateFatherEvent(result));
    }
  }

  _updateChild(TransactionCategoryModel child) async {
    var page = TransactionCategoryRoutes.editNavigator(context, account: _bloc.account, transactionCategory: child);
    await page.push();
    if (page.result != null) {
      _bloc.add(UpdateChildEvent(page.result!));
    }
  }

  _deleteFather(TransactionCategoryFatherModel fahter) {
    CommonDialog.showDeleteConfirmationDialog(context, () {
      _bloc.add(DeleteFatherEvent(fahter.id));
    });
  }

  _deleteChild(TransactionCategoryModel child) {
    CommonDialog.showDeleteConfirmationDialog(context, () {
      _bloc.add(DeleteChildEvent(child.id));
    });
  }

  addFather() {
    TransactionCategoryFatherModel model = TransactionCategoryFatherModel.fromJson({})
      ..incomeExpense = widget.incomeExpense;
    showDialog(
        context: context,
        builder: (context) => TransactionCategoryFatherEditDialog(
              account: UserBloc.currentAccount,
              model: model,
            )).then((value) {
      if (value is TransactionCategoryFatherModel && value.isValid) {
        _bloc.add(AddFatherEvent(value));
      }
    });
  }
}
