import 'package:flutter/material.dart';
import 'package:starwars/models/film_model.dart';

import '../api_request.dart';
import '../dialogs/progress_dialog.dart';
import '../models/character_model.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({required this.film, Key? key}) : super(key: key);

  final FilmModel film;

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {

  List<CharacterModel> _items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personajes de "${widget.film.title}"'),
      ),
      backgroundColor: Colors.grey[800],
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          var ch = _items[index];
          return Card(
            color: Colors.grey[900],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                direction: Axis.vertical,
                children: [
                  Text(ch.name, style: TextStyle(fontSize: 20, color: Colors.yellow[800]),),
                  Text(ch.homeworld, style: TextStyle(fontSize: 18, color: Colors.yellow),),
                  Text(ch.getSpeciesString(), style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18, color: Colors.yellow),)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _initAsync();
    });
  }

  Future<void> _initAsync()
  async {
    var progressDialog = ProgressDialog(context);
    await progressDialog.show();
    var res = await ApiRequest().characters(widget.film);
    await progressDialog.hide();
    setState(() {
      _items = res;
    });
  }
}
