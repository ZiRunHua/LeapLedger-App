import 'package:flutter/material.dart';
import 'package:keepaccount_app/common/global.dart';

class ShareHome extends StatefulWidget {
  const ShareHome({super.key});

  @override
  State<ShareHome> createState() => _ShareHomeState();
}

class _ShareHomeState extends State<ShareHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DropdownButton(
          value: "ok",
          underline: null,
          dropdownColor: Colors.white,
          items: [
            DropdownMenuItem<String>(
              value: "ok",
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.abc),
                  const SizedBox(
                    width: Constant.margin,
                  ),
                  Text("ok")
                ],
              ),
            ),
            DropdownMenuItem<String>(
              value: "ok1",
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.abc),
                  const SizedBox(
                    width: Constant.margin,
                  ),
                  Text("ok")
                ],
              ),
            )
          ],
          onChanged: (value) => {},
        ),
        centerTitle: true,
      ),
    );
  }

  Widget _buildTab() {
    print(Theme.of(context).tabBarTheme.dividerHeight);
    return const Padding(
      padding: EdgeInsets.all(Constant.padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [Icon(Icons.abc), Text("日常账本")],
      ),
    );
  }
}
