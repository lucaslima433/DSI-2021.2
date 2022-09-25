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
      theme: ThemeData(          // Add the 5 lines from here... 
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
      ),
      home: const Homepage(),
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
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  String _view = "list";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Startup Name Generator'),
          actions: [
          IconButton(
              icon: const Icon(Icons.list),
              onPressed: _pushSaved,
              tooltip: 'Saved Suggestions',
            ),
          ],
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
          backgroundColor: Colors.deepPurple,
          child: const Icon(Icons.swipe),
        ),
    );
  }

  void _pushSaved(){
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );


          final divided = tiles.isNotEmpty ? ListTile.divideTiles(context: context,tiles: tiles,).toList() : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
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

        final alreadySaved = _saved.contains(_suggestions[index]);
        
        return ListTile(
          title: Text(
            _suggestions[index].asPascalCase,
            style: _biggerFont,
          ),
          
          trailing: Icon(
            alreadySaved ? Icons.favorite : Icons.favorite_border,
            color: alreadySaved ? Colors.red : null,
            semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
          ),

          onTap: () {          // NEW from here ...
                setState(() {
                  if (alreadySaved) {
                    _saved.remove(_suggestions[index]);
                  } else {
                    _saved.add(_suggestions[index]);
                  }
                }
              );    
            },

        );
      },
    );
  }

  _gridView() {
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      padding: const EdgeInsets.all(16.0),

      itemBuilder: /*1*/ (context, index) { /*3*/
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10)); /*4*/
        }

        final alreadySaved = _saved.contains(_suggestions[index]);

        return Card(
          borderOnForeground: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Text(
                _suggestions[index].asPascalCase,
                style: _biggerFont,
              ),

              const SizedBox(
                height: 20,
              ),

              IconButton(
                icon: Icon(
                alreadySaved ? Icons.favorite : Icons.favorite_border,
                color: alreadySaved ? Colors.red : null,
                semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
              ),
              
              onPressed: () => {
                setState(() {
                    if (alreadySaved) {
                      _saved.remove(_suggestions[index]);
                    } else {
                      _saved.add(_suggestions[index]);
                    }
                  }
                )
              },

              )  
            ],    

          )
        );
      },
    );
  }
}