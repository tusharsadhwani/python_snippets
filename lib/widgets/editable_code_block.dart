import 'package:flutter/material.dart';

import '../flutter_highlight.dart';
import '../themes/atom-one-dark-reasonable.dart';

class EditableCodeBlock extends StatelessWidget {
  final String text;
  final HighlightEditingController controller;
  final String language;

  static const backgroundColor = Color(0xff282c34);

  const EditableCodeBlock({
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
              child: Container(
                width: 1000, //TODO: make this the width of the textspan
                child: HighlightView(
                  text: text,
                  controller: controller,
                  language: language ?? 'plaintext',
                  editable: true,
                  theme: atomOneDarkReasonableTheme,
                  padding: const EdgeInsets.all(20),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
