import 'package:flutter/material.dart';
import 'package:highlight/highlight.dart';

import '../themes/atom-one-dark-reasonable.dart';

class EditableCodeBlock extends StatefulWidget {
  final TextEditingController controller;
  final String language;

  static const backgroundColor = Color(0xff282c34);

  const EditableCodeBlock({
    Key key,
    this.controller,
    this.language,
  }) : super(key: key);

  @override
  _EditableCodeBlockState createState() => _EditableCodeBlockState();
}

class _EditableCodeBlockState extends State<EditableCodeBlock> {
  static const _rootKey = 'root';
  static const _defaultFontColor = Color(0xff000000);

  var _textStyle = TextStyle(
    fontSize: 16.0,
    color: atomOneDarkReasonableTheme[_rootKey]?.color ?? _defaultFontColor,
  );

  FocusNode focusNode;
  ScrollController scrollController;
  ScrollController secondaryScrollController;

  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {});
    });
    focusNode = FocusNode();
    scrollController = ScrollController();
    secondaryScrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.offset >
          secondaryScrollController.position.maxScrollExtent) {
        scrollController
            .jumpTo(secondaryScrollController.position.maxScrollExtent);
      } else {
        secondaryScrollController.jumpTo(scrollController.offset);
      }
    });
  }

  List<TextSpan> _convert(List<Node> nodes) {
    List<TextSpan> spans = [];
    var currentSpans = spans;
    List<List<TextSpan>> stack = [];

    _traverse(Node node) {
      if (node.value != null) {
        currentSpans.add(node.className == null
            ? TextSpan(text: node.value)
            : TextSpan(
                text: node.value,
                style: atomOneDarkReasonableTheme[node.className]));
      } else if (node.children != null) {
        List<TextSpan> tmp = [];
        currentSpans.add(TextSpan(
            children: tmp, style: atomOneDarkReasonableTheme[node.className]));
        stack.add(currentSpans);
        currentSpans = tmp;

        node.children.forEach((n) {
          _traverse(n);
          if (n == node.children.last) {
            currentSpans = stack.isEmpty ? spans : stack.removeLast();
          }
        });
      }
    }

    for (var node in nodes) {
      _traverse(node);
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    var codeText = TextSpan(
      style: _textStyle,
      children: _convert(
          highlight.parse(widget.controller.text, language: 'python').nodes),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: double.infinity,
        color: EditableCodeBlock.backgroundColor,
        child: Stack(
          children: [
            Theme(
              data: ThemeData(highlightColor: Colors.blueGrey.shade700),
              child: Scrollbar(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  controller: secondaryScrollController,
                  scrollDirection: Axis.horizontal,
                  child: RichText(text: codeText),
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              child: Container(
                width: double.maxFinite,
                child: TextField(
                  controller: widget.controller,
                  style: _textStyle.copyWith(color: Colors.transparent),
                  decoration: InputDecoration.collapsed(hintText: ""),
                  maxLines: null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
