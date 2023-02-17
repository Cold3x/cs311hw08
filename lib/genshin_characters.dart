import 'dart:convert';
import 'package:http/http.dart' as http;

class GenshinCharacters {
  final List<String> genshinCharacters;

  const GenshinCharacters({
    required this.genshinCharacters,
  });

  factory GenshinCharacters.fromJson(dynamic json) {
    return GenshinCharacters(genshinCharacters: List.from(json));
  }
}

class CharacterInfo {
  final String name;
  final String vision;
  final String weapon;
  final String nation;
  final String description;

  const CharacterInfo({
    required this.name,
    required this.vision,
    required this.weapon,
    required this.nation,
    required this.description,
  });

  factory CharacterInfo.fromJson(dynamic json) {
    return CharacterInfo(
        name: json['name'],
        vision: json['vision'],
        weapon: json['weapon'],
        nation: json['nation'],
        description: json['description']);
  }
}

Future<GenshinCharacters> fetchCharacters(http.Client client) async {
  final response =
      await client.get(Uri.parse('https://api.genshin.dev/characters'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON.
    return GenshinCharacters.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load characters');
  }
}

Future<CharacterInfo> fetchCharacterInfo(
    http.Client client, String name) async {
  final response =
      await client.get(Uri.parse('https://api.genshin.dev/characters/$name'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON.
    return CharacterInfo.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load characters');
  }
}
