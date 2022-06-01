import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:starwars/models/character_model.dart';
import 'package:starwars/models/film_model.dart';

class ApiRequest {
  Future<List<FilmModel>> films()
  async {
    List<FilmModel> filmList = [];
    var jsonBody = await _getJsonBody('https://swapi.dev/api/films/');
    if(jsonBody.isNotEmpty) {
      var resultsArray = jsonBody['results'];
      for(var r in resultsArray) {
        filmList.add(FilmModel(id: r['episode_id'],
            title: r['title'],
            characterRequestList: List<String>.from(r['characters']))
        );
      }
    }
    return filmList;
  }

  Future<List<CharacterModel>> characters(FilmModel film)
  async {
    List<CharacterModel> characterList = [];

    if(film.characterRequestList.isNotEmpty) {
      for(var i = 0; i < film.characterRequestList.length; i++) {
        var ch = film.characterRequestList[i];
        var jsonBody = await _getJsonBody(ch);
        if(jsonBody.isNotEmpty) {
          var homeWorldResponse = await _getJsonBody(jsonBody['homeworld']);
          var species = await _species(List<String>.from(jsonBody['species']));
          characterList.add(CharacterModel(
              name: jsonBody['name'],
              homeworld: homeWorldResponse['name'],
              species: species)
          );
        }
      }
    }
    return characterList;
  }

  Future<List<String>> _species(List<String> requestList)
  async {
    List<String> list = [];
    for(var i = 0; i < requestList.length; i++){
      var jsonBody = await _getJsonBody(requestList[i]);
      if(jsonBody.isNotEmpty) {
        list.add(jsonBody['name']);
      }
    }
    return list;
  }

  dynamic _getJsonBody(String request)
  async {
    dynamic res;
    var response = await http.get(Uri.parse(request));
    if(response.body.isNotEmpty) {
      res = jsonDecode(response.body);
    }
    return res;
  }
}