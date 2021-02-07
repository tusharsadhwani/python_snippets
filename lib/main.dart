import 'dart:js' as js;

import 'package:flutter/material.dart';
import 'package:scaffold_responsive/scaffold_responsive.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark-reasonable.dart';

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
  final code = '''def bang(f):
    """Decorator used for functions that return a string. Adds an exclamation to
    the end of the returned string."""
    def func(*args):
        return f(*args) + '!'
    return func

@bang
def greet(name):
    return 'Hello, {}'.format(name)

print(greet('Tushar'))''';
  HighlightEditingController controller;
  String _output;

  @override
  void initState() {
    super.initState();
    controller = HighlightEditingController(
      'python',
      atomOneDarkReasonableTheme,
    );
    controller.text = code;
  }

  void _getOutputFromSkulpt() {
    js.context.callMethod('runPython', [controller.text]);
    var codeOutput = js.context['codeOutput'];
    setState(() {
      _output = codeOutput.toString()?.trimRight() ?? '';
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
          EditableCodeBlock(controller: controller, language: 'python'),
          SizedBox(height: 30),
          Text('Output:', style: ExampleSnippet._textStyle),
          SizedBox(height: 10),
          if (_output != null)
            CodeBlock(
              key: ValueKey(_output),
              text: _output,
            ),
        ],
      ),
    );
  }
}
