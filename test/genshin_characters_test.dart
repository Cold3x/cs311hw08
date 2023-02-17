import 'package:cs311hw08/genshin_characters.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'genshin_characters_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  test(
    'returns GenshinCharacters if the http call completes',
    () async {
      final client = MockClient();

      when(client.get(Uri.parse('https://api.genshin.dev/characters')))
          .thenAnswer((_) async => http.Response(
              '["albedo","aloy","amber","arataki-itto","ayaka","ayato"]', 200));
      expect(await fetchCharacters(client), isA<GenshinCharacters>());
    },
  );

  test(
    'throws an exception if the http call completes with an error',
    () {
      final client = MockClient();
      when(client.get(Uri.parse('https://api.genshin.dev/characters')))
          .thenAnswer((_) async => http.Response('Not Found', 400));
      expect(fetchCharacters(client), throwsException);
    },
  );
  test(
    'returns GenshinCharacterInfo if the http call completes',
    () async {
      final client = MockClient();

      when(client.get(Uri.parse('https://api.genshin.dev/characters/albedo')))
          .thenAnswer((_) async => http.Response(
              '{"name":"albedo","vision":"a","weapon":"a","nation":"a","description":"a"}',
              200));
      expect(await fetchCharacterInfo(client, 'albedo'), isA<CharacterInfo>());
    },
  );

  test(
    'throws an exception if the http call info completes with an error',
    () {
      final client = MockClient();
      when(client.get(Uri.parse('https://api.genshin.dev/characters/albedo')))
          .thenAnswer((_) async => http.Response('Not Found', 400));
      expect(fetchCharacterInfo(client, 'albedo'), throwsException);
    },
  );
}
