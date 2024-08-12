part of 'enter.dart';

class SaveButtom extends StatelessWidget {
  const SaveButtom({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ConstantDecoration.cardDecoration,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Constant.margin, horizontal: Constant.padding),
        child: Expanded(
          child: FormButton.mediumElevatedBtn(
              context, "保存", () => BlocProvider.of<TransactionTimingCubit>(context).save()),
        ),
      ),
    );
  }
}
