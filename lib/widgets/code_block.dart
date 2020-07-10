import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark-reasonable.dart';

class CodeBlock extends StatelessWidget {
  final String text;
  final String language;

  static const backgroundColor = Color(0xff282c34);

  const CodeBlock({
    Key key,
    @required this.text,
    this.language,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: double.infinity,
        color: backgroundColor,
        child: Theme(
          data: ThemeData(highlightColor: Colors.blueGrey.shade700),
          child: Scrollbar(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: HighlightView(
                text.trimRight(),
                language: language ?? 'plaintext',
                theme: atomOneDarkReasonableTheme,
                padding: const EdgeInsets.all(20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
