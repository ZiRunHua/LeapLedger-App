part of 'common.dart';

class CommonAvatarPainter extends CustomPainter {
  final String username;

  CommonAvatarPainter({required this.username});

  @override
  void paint(Canvas canvas, Size size) {
    Paint circlePaint = Paint()..color = ConstantColor.secondaryColor;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2, circlePaint);

    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: getUsernameInitials(),
        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset((size.width - textPainter.width) / 2, (size.height - textPainter.height) / 2),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  String getUsernameInitials() {
    String firstChar = extractFirstChineseOrEnglish(username);
    return firstChar;
  }

  final int _maxLength = 4;
  String extractFirstChineseOrEnglish(String input) {
    // 取第一个中文字符
    RegExp regex = RegExp(r'[\u4e00-\u9fa5]');
    Match? strMatch = regex.firstMatch(input);
    if (strMatch != null && strMatch.group(0) != null) {
      return strMatch.group(0)!;
    }
    // 取分割后的字符
    regex = RegExp(r'[ _/]');
    strMatch = regex.firstMatch(input);
    String result = input;
    if (strMatch != null && strMatch.group(0) != null) {
      result = input.substring(0, strMatch.start);
    }

    if (_maxLength < result.length) {
      return result.substring(0, _maxLength);
    } else {
      return result;
    }
  }
}
