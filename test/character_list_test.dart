import 'package:cs311hw08/character_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'character_list_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  testWidgets(
    'Character List should display',
    (widgetTester) async {
      final client = MockClient();

      when(client.get(Uri.parse('https://api.genshin.dev/characters')))
          .thenAnswer(
              (_) async => http.Response('["albedo","aloy","amber"]', 200));
      // add widget to tester.
      await widgetTester.pumpWidget(MaterialApp(
        home: Scaffold(body: CharacterList(client: client)),
      ));
      await widgetTester.pumpAndSettle();

      final findListView = find.byType(ListView);

      expect(findListView, findsOneWidget);
    },
  );

  testWidgets(
    'Character List should not display when data is not found',
    (widgetTester) async {
      final client = MockClient();

      when(client.get(Uri.parse('https://api.genshin.dev/characters')))
          .thenAnswer((_) async => http.Response('Not found', 400));
      // add widget to tester.
      await widgetTester.pumpWidget(MaterialApp(
        home: Scaffold(body: CharacterList(client: client)),
      ));
      await widgetTester.pumpAndSettle();

      final findListView = find.byType(ListView);
      final findText = find.byType(Text);

      expect(findListView, findsNothing);
      expect(findText, findsOneWidget);
    },
  );

  testWidgets(
    'CircularProgressIndicator should display when loading data',
    (widgetTester) async {
      http.Client client = http.Client();
      await widgetTester.pumpWidget(MaterialApp(
        home: Scaffold(body: CharacterList(client: client)),
      ));

      final findCircular = find.byType(CircularProgressIndicator);

      expect(findCircular, findsOneWidget);
    },
  );
}
