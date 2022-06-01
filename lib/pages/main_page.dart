import 'package:flutter/material.dart';
import 'package:starwars/models/film_model.dart';
import 'package:starwars/pages/characters_page.dart';

import '../api_request.dart';
import '../dialogs/progress_dialog.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  List<FilmModel> _items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: Colors.grey[800],
      body: _body(),
    );
  }

  Widget _body()
  {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          var film = _items[index];
          return GestureDetector(
            onTap: () {
              _showFilmCharacters(film);
            },
            child: Card(
              color: Colors.grey[900],
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
                child: Text(film.title, style: const TextStyle(color: Colors.yellow, fontSize: 22, fontWeight: FontWeight.bold)),
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
      _initStateAsync();
    });
  }

  Future<void> _initStateAsync()
  async {
    var progressDialog = ProgressDialog(context);
    await progressDialog.show();
    var res = await ApiRequest().films();
    await progressDialog.hide();
    setState(() {
      _items = res;
    });
  }

  void _showFilmCharacters(FilmModel filmModel) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CharactersPage(film: filmModel)));
  }
}
