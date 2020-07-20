import 'dart:js' as js;

import 'package:flutter/material.dart';
import 'package:scaffold_responsive/scaffold_responsive.dart';

import './widgets/code_block.dart';
import './widgets/editable_code_block.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Python Snippets'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String tab;

  void setTab(newTab) {
    setState(() {
      tab = newTab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      title: Text(widget.title),
      tabs: [
        {'title': 'Example'}
      ],
      onTabChanged: setTab,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[if (tab != null) ExampleSnippet()],
        ),
      ),
    );
  }
}

class ExampleSnippet extends StatefulWidget {
  static const _textStyle = TextStyle(fontSize: 26, color: Colors.black87);

  @override
  _ExampleSnippetState createState() => _ExampleSnippetState();
}

class _ExampleSnippetState extends State<ExampleSnippet> {
  final code = '''def add_plus_one(x, y):
    """Adds two numbers and increments by 1. Useful for demonstrating how python functions work"""
    return x + y + 1

print(add_plus_one(6, 3))''';
  TextEditingController controller;
  String _output;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: code.trimRight());
  }

  void _getOutputFromSkulpt() {
    js.context.callMethod('runPython', [controller.text]);
    var codeOutput = js.context['codeOutput'];
    setState(() {
      _output = codeOutput;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text('Input:', style: ExampleSnippet._textStyle),
              Spacer(),
              RaisedButton(
                onPressed: _getOutputFromSkulpt,
                child: Text('Run'),
              ),
            ],
          ),
          SizedBox(height: 10),
          // CodeBlock(text: code, language: 'python'),
          EditableCodeBlock(controller: controller, language: 'python'),
          SizedBox(height: 30),
          Text('Output:', style: ExampleSnippet._textStyle),
          SizedBox(height: 10),
          if (_output != null)
            CodeBlock(
              text: _output,
            )
        ],
      ),
    );
  }
}
