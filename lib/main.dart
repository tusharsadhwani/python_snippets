import 'dart:js' as js;

import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark-reasonable.dart';
import 'package:scaffold_responsive/scaffold_responsive.dart';

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
    """Adds two numbers and increments by 1"""
    return x + y + 1

print(add_plus_one(6, 3))''';
  String _output;

  void _getOutputFromSkulpt() {
    js.context.callMethod('runPython', [code]);
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
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: HighlightView(
              code,
              language: 'python',
              theme: atomOneDarkReasonableTheme,
              padding: const EdgeInsets.all(16),
            ),
          ),
          SizedBox(height: 30),
          Text('Output:', style: ExampleSnippet._textStyle),
          SizedBox(height: 10),
          if (_output != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: HighlightView(
                '10',
                language: 'plaintext',
                theme: atomOneDarkReasonableTheme,
                padding: const EdgeInsets.all(16),
              ),
            ),
        ],
      ),
    );
  }
}
