part of 'enter.dart';

class ConditionBottomSheet extends StatefulWidget {
  const ConditionBottomSheet({super.key});

  @override
  State<ConditionBottomSheet> createState() => _ConditionBottomSheetState();
}

class _ConditionBottomSheetState extends State<ConditionBottomSheet> {
  late final GlobalKey<FormState> _formKey;
  late final FlowConditionCubit _conditionCubit;

  TransactionQueryCondModel get _condition => _conditionCubit.condition;
  @override
  void initState() {
    _conditionCubit = BlocProvider.of<FlowConditionCubit>(context);
    _conditionCubit.fetchCategoryData();
    _formKey = GlobalKey<FormState>();
    getAmountStr(int amount) {
      String str = (amount / 100).toStringAsFixed(2);
      if (str.endsWith('.00')) {
        return str.substring(0, str.length - 3);
      } else if (str.endsWith('0')) {
        return str.substring(0, str.length - 1);
      }
      return str;
    }

    if (_condition.minimumAmount != null) {
      _minAmountController.text = getAmountStr(_condition.minimumAmount!);
    }
    if (_condition.maximumAmount != null) {
      _maxAmountController.text = getAmountStr(_condition.maximumAmount!);
    }
    super.initState();
  }

  @override
  void dispose() {
    _minAmountController.dispose();
    _maxAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return PopScope(
        onPopInvokedWithResult: (bool didPop, bool? result) => _conditionCubit.sync(),
        child: BlocBuilder<FlowConditionCubit, FlowConditionState>(
          buildWhen: (_, state) => state is FlowEditingConditionUpdate,
          builder: (context, state) {
            return Stack(children: [
              Container(
                padding: EdgeInsets.only(top: Constant.buttomSheetRadius),
                decoration: ConstantDecoration.bottomSheet,
                height: size.height * 0.8,
                width: size.width,
                child: _buildForm(),
              ),
              Positioned(
                top: Constant.margin / 2,
                right: Constant.margin / 2,
                child: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
              ),
            ]);
          },
        ));
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 11,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOneConditon(name: "金额", _buildAmountInput()),
                  _buildOneConditon(name: "收支", _buildIncomeExpense()),
                  _buildCategory()
                ],
              ),
            ),
          ),
          Expanded(flex: 1, child: _buildButtonGroup()),
        ],
      ),
    );
  }

  Widget _buildOneConditon(List<Widget> widgetList, {String? name}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(Constant.padding, Constant.padding, Constant.padding, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: Constant.padding),
            child: Visibility(
              visible: name != null,
              child: Text(
                name ?? "",
                style: TextStyle(fontSize: ConstantFontSize.bodyLarge, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          ...widgetList
        ],
      ),
    );
  }

  /// 金额
  final TextEditingController _minAmountController = TextEditingController();
  final TextEditingController _maxAmountController = TextEditingController();
  List<Widget> _buildAmountInput() {
    return [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: AmountInput(
              controller: _minAmountController,
              onChanged: (amount) => _conditionCubit.updateMinimumAmount(amount: amount),
              decoration: AmountInput.defaultDecoration.copyWith(labelText: "最低金额"),
            ),
          ),
          SizedBox(
              width: 32.w,
              child: Divider(
                color: ConstantColor.greyText,
                indent: Constant.margin,
                endIndent: Constant.margin,
                height: 0.5,
                thickness: 0.5,
              )),
          Flexible(
            child: AmountInput(
              controller: _maxAmountController,
              onChanged: (amount) => _conditionCubit.updateMaximumAmount(amount: amount),
              decoration: AmountInput.defaultDecoration.copyWith(labelText: "最高金额"),
            ),
          ),
        ],
      )
    ];
  }

  /// 收支
  get selectedIncomeExpense => _condition.incomeExpense;
  List<Widget> _buildIncomeExpense() {
    return [
      SegmentedButton<IncomeExpense?>(
        selected: {selectedIncomeExpense},
        emptySelectionAllowed: true,
        showSelectedIcon: false,
        style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          textStyle: WidgetStateProperty.all<TextStyle>(const TextStyle(color: Colors.white)),
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return ConstantColor.primaryColor;
              }
              return Colors.white;
            },
          ),
        ),
        onSelectionChanged: (value) => _conditionCubit.changeIncomeExpense(ie: value.first),
        segments: [
          ButtonSegment(
            value: IncomeExpense.income,
            label: Padding(
              padding: EdgeInsets.symmetric(vertical: Constant.padding, horizontal: Constant.padding / 2),
              child: Text("收入",
                  style: TextStyle(
                    fontSize: ConstantFontSize.body,
                    color: selectedIncomeExpense == IncomeExpense.income ? Colors.white : null,
                  )),
            ),
          ),
          ButtonSegment(
            value: IncomeExpense.expense,
            label: Padding(
                padding: EdgeInsets.symmetric(vertical: Constant.padding, horizontal: Constant.padding / 2),
                child: Text("支出",
                    style: TextStyle(
                      fontSize: ConstantFontSize.body,
                      color: selectedIncomeExpense == IncomeExpense.expense ? Colors.white : null,
                    ))),
          )
        ],
      ),
    ];
  }

  /// 交易类型
  Widget _buildCategory() {
    return BlocBuilder<FlowConditionCubit, FlowConditionState>(
      buildWhen: (_, state) => state is FlowConditionCategoryLoaded,
      builder: (context, state) {
        return Column(
          children: List.generate(
            _conditionCubit.categorytree.length,
            (index) => _buildOneConditon(
              [_buildCategoryChildren(_conditionCubit.categorytree[index].value)],
              name: _conditionCubit.categorytree[index].key.name,
            ),
          ),
        );
      },
    );
  }

  _buildCategoryChildren(List<TransactionCategoryModel> list) {
    if (list.isEmpty) {
      return const Center(child: Text("无"));
    }
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: Constant.padding,
        mainAxisSpacing: Constant.padding,
        childAspectRatio: 0.8,
      ),
      itemCount: list.length,
      itemBuilder: (context, index) => _buildCategoryIcon(list[index]),
    );
  }

  Set<int> get selectCategory => _condition.categoryIds;
  Widget _buildCategoryIcon(TransactionCategoryModel category) {
    return CategoryIconAndName(
      category: category,
      onTap: (category) => _conditionCubit.selectCategory(category: category),
      isSelected: selectCategory.contains(category.id),
    );
  }

  /// 按钮组
  Widget _buildButtonGroup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            width: 100,
            child: OutlinedButton(
              style: ButtonStyle(
                  shape: WidgetStateProperty.all(const StadiumBorder(side: BorderSide(style: BorderStyle.none)))),
              onPressed: () {
                _minAmountController.clear();
                _maxAmountController.clear();
                _conditionCubit.setOptionalFieldsToEmpty();
              },
              child: const Text("重 置"),
            )),
        SizedBox(
          width: 100,
          child: ElevatedButton(
            style: ButtonStyle(
                shape: WidgetStateProperty.all(const StadiumBorder(side: BorderSide(style: BorderStyle.none)))),
            onPressed: () {
              _conditionCubit.save();
              Navigator.of(context).pop();
            },
            child: const Text("确 定"),
          ),
        )
      ],
    );
  }
}
