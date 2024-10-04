part of 'common.dart';

class CommonCard extends Card {
  const CommonCard({
    super.key,
    super.color,
    super.shadowColor,
    super.surfaceTintColor,
    super.elevation,
    super.shape,
    super.borderOnForeground = true,
    super.margin,
    super.clipBehavior,
    super.child,
    super.semanticContainer = true,
  }) : assert(elevation == null || elevation >= 0.0);

  factory CommonCard.withTitle({
    required Widget child,
    String? title,
    Color? background,
    Widget? action,
  }) {
    child = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: title == null
          ? [child]
          : [
              Padding(
                padding: EdgeInsets.only(top: Constant.padding, left: Constant.padding),
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: ConstantFontSize.headline,
                    letterSpacing: 2,
                  ),
                ),
              ),
              child
            ],
    );
    if (action != null) {
      child = Stack(children: [
        Positioned(top: Constant.padding, right: Constant.padding, child: action),
        child,
      ]);
    }
    return CommonCard(
      color: background ?? Colors.white,
      margin: EdgeInsets.all(Constant.margin),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: ConstantDecoration.borderRadius,
      ),
      child: child,
    );
  }
}
