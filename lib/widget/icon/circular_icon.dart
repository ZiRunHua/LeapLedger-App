part of 'enter.dart';

class CircularIcon extends StatelessWidget {
  const CircularIcon({
    super.key,
    required this.icon,
    this.backgroundColor = ConstantColor.primaryColor,
  });
  final IconData icon;
  final Color backgroundColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(90),
      ),
      width: 64.sp,
      height: 64.sp,
      child: Icon(icon, size: Constant.iconlargeSize, color: Colors.black87),
    );
  }
}
