import 'package:cs311hw08/genshin_characters.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:strings/strings.dart';

import 'character_detail.dart';

class CharacterList extends StatefulWidget {
  const CharacterList({Key? key, required this.client}) : super(key: key);
  final http.Client client;

  @override
  State<CharacterList> createState() => _CharacterListState();
}

class _CharacterListState extends State<CharacterList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchCharacters(widget.client),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.genshinCharacters.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title:
                      Text(capitalize(snapshot.data!.genshinCharacters[index])),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CharacterDetail(
                                  name: snapshot.data!.genshinCharacters[index],
                                  client: widget.client,
                                )));
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        });
  }
}
