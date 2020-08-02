import 'package:flutter/material.dart';

import '../flutter_highlight.dart';
import '../themes/atom-one-dark-reasonable.dart';

class CodeBlock extends StatelessWidget {
  final String text;
  final HighlightEditingController controller;
  final String language;

  static const backgroundColor = Color(0xff282c34);

  const CodeBlock({
    Key key,
    this.text,
    this.controller,
    this.language,
  })  : assert(text != null || controller != null,
            'One of text or controller properties must be provided'),
        super(key: key);

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
                text: text,
                controller: controller,
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
