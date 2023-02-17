import 'package:cs311hw08/genshin_characters.dart';
import 'package:flutter/material.dart';
import 'package:strings/strings.dart';
import 'package:http/http.dart' as http;

class CharacterDetail extends StatelessWidget {
  const CharacterDetail({Key? key, required this.name, required this.client})
      : super(key: key);

  final String name;
  final http.Client client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(capitalize(name)),
      ),
      body: FutureBuilder(
        future: fetchCharacterInfo(client, name),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            CharacterInfo info = snapshot.data!;
            return Column(
              children: [
                Text("Name: ${info.name}"),
                Text("Vision: ${info.vision}"),
                Text("Weapon: ${info.weapon}"),
                Text("Nation: ${info.nation}"),
                Text(info.description),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
