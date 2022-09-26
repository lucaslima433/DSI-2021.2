import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Argumentos {
  final Repositorio rep;
  final int index;
  Argumentos(this.rep, this.index);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const Homepage(),
        '/editar': (context) => const Editar(),
      },
      title: 'Startup Name Generator',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}

class Homepage extends StatefulWidget {
  static const routeName = '/';
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final Repositorio _suggestions = Repositorio();
  final _saved = <Word>{};
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

          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addNewWord,
            tooltip: 'Add new word',
          ),
        ],
      ),
      body: Center(child: _home(context)),
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

  void _addNewWord(){
    Navigator.pushNamed(context, '/editar',
        arguments: {'index': Null, 'suggestions': _suggestions})
        .then((value) => (setState(() {})));  
  }

  void _pushSaved() {
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

          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                ).toList()
              : <Widget>[];

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

  _home(BuildContext context) {
    if (_view == "list") {
      return _listView();
    } else {
      return _gridView();
    }
  }

  _listView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _suggestions.length,
      itemBuilder: /*1*/ (context, i) {
        //if (i.isOdd) return const Divider(); /*2*/

        final index = i ~/ 1; /*3*/
        final alreadySaved = _saved.contains(_suggestions.index(index));

        return GestureDetector(
          child: Column(
            children: [
              ListTile(
                title: Text(
                  _suggestions.index(index).asPascalCase,
                  style: _biggerFont,
                ),
                trailing: Wrap(
                  children: [
                    IconButton(
                      icon: Icon(
                        alreadySaved ? Icons.favorite : Icons.favorite_border,
                        color: alreadySaved ? Colors.red : null,
                        semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
                      ),
                      onPressed: () {
                        setState(() {
                          if (alreadySaved) {
                            _saved.remove(_suggestions.index(index));
                          } else {
                            _saved.add(_suggestions.index(index));
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          if (alreadySaved) {
                            _saved.remove(_suggestions.index(index));
                          }
                          _suggestions.remove(index);
                        });
                      },
                    ),
                  ],
                ),
              ),
              Divider(),
            ],
          ),
          onTap: () {
            Navigator.pushNamed(context, '/editar',
                    arguments: {'index': index, 'suggestions': _suggestions})
                .then((value) => (setState(() {})));
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
      itemCount: _suggestions.length,
      itemBuilder: /*1*/ (context, index) {
        /*3*/
        final alreadySaved = _saved.contains(_suggestions.index(index));

        return GestureDetector(
          child: Card(
            borderOnForeground: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _suggestions.index(index).asPascalCase,
                  style: _biggerFont,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        alreadySaved ? Icons.favorite : Icons.favorite_border,
                        color: alreadySaved ? Colors.red : null,
                        semanticLabel:
                            alreadySaved ? 'Remove from saved' : 'Save',
                      ),
                      onPressed: () => {
                        setState(() {
                          if (alreadySaved) {
                            _saved.remove(_suggestions.index(index));
                          } else {
                            _saved.add(_suggestions.index(index));
                          }
                        })
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          if (alreadySaved) {
                            _saved.remove(_suggestions.index(index));
                          }
                          _suggestions.remove(index);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, '/editar',
                    arguments: {'index': index, 'suggestions': _suggestions})
                .then((value) => (setState(() {})));
          },
        );
      },
    );
  }
}

class Editar extends StatefulWidget {
  const Editar({Key? key}) : super(key: key);

  @override
  State<Editar> createState() => _EditarState();
}

class _EditarState extends State<Editar> {
  @override
  Widget build(BuildContext context) {
    final palavras = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Repositorio palavraSel = palavras['suggestions'];
    final index = palavras['index'];

    TextEditingController _textEditingController = TextEditingController();

    final String texto;

    if (index == Null) {
      texto = "Digite uma palavra a ser adicionada:";
    } else {
      texto = "Palavra que será editada:";
    } 


    return Scaffold(
        appBar: AppBar(
          title: Text("Pagina de Edição"),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Center(
                child: Text(
              texto,
              style: TextStyle(fontSize: 20),
            )),
            Center(
                child: Text(index == Null ? ' ' : palavraSel.index(index).asPascalCase,
                    style: const TextStyle(fontSize: 32, color: Colors.black))),
            Padding(
              padding: const EdgeInsets.all(64.0),
              child: TextField(
                controller: _textEditingController,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      const Radius.circular(12.0),
                    ),
                  ),
                  labelText: 'Digite um novo nome',
                  labelStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                ),
              ),
            ),

            RaisedButton(
              child: Text('Salvar'),
              onPressed: () => submit(_textEditingController, palavraSel, index),
            ),
            
            //Text(texto)
          ],
        )
        
        
    );
  }

  void submit(textEdit, palavraSel, index){
    setState(() {
    if (index == Null) {
      palavraSel.add(textEdit.text);
    } else {
      palavraSel.change(textEdit.text, index);
    } 
    });
    Navigator.pop(context);
  }
}

class Word {
  String? _text;
  String? _textPascalCase;
  String? _newText;

  Word({required String text, required String textPascal}) {
    _text = text;
    _textPascalCase = textPascal;
  }

  String get text {
    if (_newText == null) return _text!;
    return _newText!;
  }

  String get asPascalCase {
    if (_newText == null) return _textPascalCase!;
    return _newText!;
  }

  set text(String newText) {
    _newText = newText;
  }

  changeWord(String newString) {
    if (_newText != null) {
      _text = _newText;
      _textPascalCase = _newText;
    }
    _newText = newString;
  }
}

class Repositorio {
  final List<Word> _list = [];

  Repositorio() {
    for (int i = 0; i < 20; i++) {
      final word = generateWordPairs().take(1).first;
      _list.add(Word(
          text: word.toString(), textPascal: word.asPascalCase.toString()));
    }
  }

  List<Word> get list {
    return _list;
  }

  int get length {
    return _list.length;
  }

  index(int index) {
    return _list[index];
  }

  remove(int index) {
    _list.removeAt(index);
  }

  change(String newString, int index) {
    _list[index].changeWord(newString);
  }
  
  add(String word) {
    _list.add(Word(text: word, textPascal: word));
  }
}
