import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18);
  String _view = "list";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Startup Name Generator'),
        ),
          
        body: Center(
            child: _home(context)
          ),
        
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_view == "list") {
              _view = "grid";
            } else {
              _view = "list";
            }
            setState(() {});
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.swipe),
        ),
    );
  }

  _home(BuildContext context){
    if (_view == "list") {
      return _listView();
    } else {
      return _gridView();
    }
  }

  _listView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),

      itemBuilder: /*1*/ (context, i) {
        if (i.isOdd) return const Divider(); /*2*/

        final index = i ~/ 2; /*3*/
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10)); /*4*/
        }
        
        return ListTile(
          title: Text(
            _suggestions[index].asPascalCase,
            style: _biggerFont,
          ),
        );
      },
    );
  }

  _gridView() {
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      padding: const EdgeInsets.all(16.0),

      itemBuilder: /*1*/ (context, i) { /*3*/
        if (i >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10)); /*4*/
        }


        return Card(
          borderOnForeground: true,
          child: Center(
            child: Text(
              _suggestions[i].asPascalCase,
              style: _biggerFont,
            ),
          )
        );
      },
    );
  }
}