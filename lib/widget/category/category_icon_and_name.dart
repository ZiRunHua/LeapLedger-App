part of 'enter.dart';

class CategoryIconAndName extends StatelessWidget {
  const CategoryIconAndName({super.key, required this.category, this.onTap, this.isSelected = false});
  final TransactionCategoryModel category;
  final Function(TransactionCategoryModel category)? onTap;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    var child = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isSelected ? ConstantColor.primaryColor : ConstantColor.greyButton,
            borderRadius: BorderRadius.circular(90),
          ),
          width: 48,
          height: 48,
          child: Icon(category.icon, size: 28),
        ),
        Text(
          category.name,
          style: const TextStyle(fontSize: ConstantFontSize.bodySmall),
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
