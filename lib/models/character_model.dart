class CharacterModel
{
  String name;
  String homeworld;
  List<String> species;

  CharacterModel({required this.name, required this.homeworld, required this.species});

  String getSpeciesString(){
    return species.isNotEmpty ? species.join(", ") : "Human";
  }
}