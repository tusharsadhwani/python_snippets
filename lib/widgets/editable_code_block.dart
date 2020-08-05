import 'package:flutter/material.dart';

import '../flutter_highlight.dart';
import '../themes/atom-one-dark-reasonable.dart';

class EditableCodeBlock extends StatefulWidget {
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
  _EditableCodeBlockState createState() => _EditableCodeBlockState();
}

class _EditableCodeBlockState extends State<EditableCodeBlock> {
  HighlightEditingController controller;
  double codeWidth;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      controller = HighlightEditingController(
          widget.language, atomOneDarkReasonableTheme);
      controller.text = widget.text;
    } else {
      controller = widget.controller;
    }

    onTextChanged();
    controller.addListener(onTextChanged);
  }

  void onTextChanged() {
    final newTextSpan = controller.buildTextSpan();
    final textPaint = TextPainter(
      text: newTextSpan,
      textDirection: TextDirection.ltr,
    );
    textPaint.layout();
    setState(() {
      // no idea why reported width is around 25% less
      codeWidth = textPaint.width * 1.25;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: double.infinity,
        color: EditableCodeBlock.backgroundColor,
        child: Theme(
          data: ThemeData(highlightColor: Colors.blueGrey.shade700),
          child: Scrollbar(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: codeWidth,
                child: HighlightView(
                  controller: controller,
                  language: widget.language ?? 'plaintext',
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
