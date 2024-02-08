import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClipboardText extends StatelessWidget {
  const ClipboardText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Text(text, textAlign: TextAlign.center),
      onTap: () {
        Clipboard.setData(ClipboardData(text: text));
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(const SnackBar(content: Text('클립보드에 복사하였습니다.')));
      },
    );
  }
}

class ClipboardBLText extends StatelessWidget {
  const ClipboardBLText({
    Key? key,
    required this.text,
    required this.isReplied,
  }) : super(key: key);

  final String text;
  final int isReplied;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Text(text,
          style: TextStyle(
              color: (isReplied == 0)
                  ? const Color.fromRGBO(255, 146, 46, 1)
                  : (isReplied == 2)
                      ? const Color.fromRGBO(255, 35, 35, 1)
                      : Colors.black)),
      onTap: () {
        Clipboard.setData(ClipboardData(text: text));
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(const SnackBar(content: Text('클립보드에 복사하였습니다.')));
      },
    );
  }
}
