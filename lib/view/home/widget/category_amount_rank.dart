part of 'enter.dart';

class CategoryAmountRank extends StatefulWidget {
  const CategoryAmountRank({super.key, required this.data});
  final List<TransactionCategoryAmountRankApiModel> data;
  @override
  State<CategoryAmountRank> createState() => _CategoryAmountRankState();
}

enum PageStatus { loading, expanding, contracting, noData }

class _CategoryAmountRankState extends State<CategoryAmountRank> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  int maxAmount = 0;
  @override
  Widget build(BuildContext context) {
    return _Func._buildCard(
        title: "本月支出排行",
        child: BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (_, state) => state is HomeCategoryAmountRank,
          builder: (context, state) {
            if (state is HomeCategoryAmountRank) {
              if (state.rankingList.length > 0) {
                maxAmount = state.rankingList.first.amount;
              } else {
                maxAmount = 0;
              }
              return CommonExpandableList(
                children: List.generate(
                  state.rankingList.length,
                  (index) => _buildListTile(state.rankingList[index], index + 1),
                ),
              );
            }
            return SizedBox();
          },
        ));
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
