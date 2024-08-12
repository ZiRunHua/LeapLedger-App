part of 'enter.dart';

class CategoryIconAndName<T extends TransactionCategoryBaseModel> extends StatelessWidget {
  const CategoryIconAndName(
      {super.key, required this.category, this.onTap, this.isSelected = false, this.hasBackgroundColor = true});
  final T category;
  final Function(T category)? onTap;
  final bool isSelected;
  final bool hasBackgroundColor;
  @override
  Widget build(BuildContext context) {
    var child = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: isSelected && hasBackgroundColor ? ConstantColor.primaryColor : ConstantColor.greyButton,
            borderRadius: BorderRadius.circular(90),
          ),
          child: SizedBox(
            width: 48,
            height: 48,
            child: Icon(
              category.icon,
              size: 28,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
        SizedBox(height: Constant.margin / 2),
        Text(
          category.name,
          style: TextStyle(
            fontSize: ConstantFontSize.bodySmall,
            color: isSelected ? ConstantColor.primaryColor : Colors.black,
          ),
        )
      ],
    );
    if (onTap != null) {
      return GestureDetector(
        onTap: onTap != null ? () => onTap!(category) : null,
        child: child,
      );
    }
    return child;
  }
}

class LargeCategoryIconAndName extends StatelessWidget {
  const LargeCategoryIconAndName(this.category, {super.key});
  final TransactionCategoryBaseModel category;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: ConstantColor.primaryColor,
            borderRadius: BorderRadius.circular(90),
          ),
          child: SizedBox(
            width: 48,
            height: 48,
            child: Icon(category.icon, size: 28, color: Colors.white),
          ),
        ),
        SizedBox(height: Constant.margin / 2),
        Text(
          category.name,
          style: TextStyle(fontSize: ConstantFontSize.bodySmall, color: ConstantColor.primaryColor),
        )
      ],
    );
  }
}
