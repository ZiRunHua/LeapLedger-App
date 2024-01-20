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
      width: 64,
      height: 64,
      child: Icon(
        icon,
        size: 32,
        color: Colors.black87,
      ),
    );
  }
}
