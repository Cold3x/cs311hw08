import 'package:cs311hw08/character_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'genshin_characters_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  testWidgets(
    'Appbar title should be a name of character',
    (widgetTester) async {
      final client = http.Client();
      await widgetTester.pumpWidget(MaterialApp(
          home: CharacterDetail(
        client: client,
        name: 'albedo',
      )));
      final findName = find.text('Albedo');
      expect(findName, findsOneWidget);
    },
  );

  testWidgets(
    'CircularProgressIndicator should display when data on loading',
    (widgetTester) async {
      final client = http.Client();
      await widgetTester.pumpWidget(MaterialApp(
          home: CharacterDetail(
        client: client,
        name: 'albedo',
      )));

      final findCircular = find.byType(CircularProgressIndicator);

      expect(findCircular, findsOneWidget);
    },
  );

  testWidgets(
    'CharacterInfo should display',
    (widgetTester) async {
      final client = MockClient();
      when(client.get(Uri.parse('https://api.genshin.dev/characters/albedo')))
          .thenAnswer((_) async => http.Response(
              '{"name":"albedo","vision":"geo","weapon":"sword","nation":"monstadt","description":"desc"}',
              200));
      await widgetTester.pumpWidget(MaterialApp(
          home: CharacterDetail(
        client: client,
        name: 'albedo',
      )));
      await widgetTester.pumpAndSettle();
      final findName = find.textContaining('albedo');
      final findVision = find.textContaining('geo');
      final findWeapon = find.textContaining('sword');
      final findNation = find.textContaining('monstadt');
      final findDescription = find.textContaining('desc');

      expect(findName, findsOneWidget);
      expect(findVision, findsOneWidget);
      expect(findWeapon, findsOneWidget);
      expect(findNation, findsOneWidget);
      expect(findDescription, findsOneWidget);
    },
  );
  testWidgets(
    'Detail column should not display but error text display when data is not found',
    (widgetTester) async {
      final client = MockClient();
      when(client.get(Uri.parse('https://api.genshin.dev/characters/albedo')))
          .thenAnswer((_) async => http.Response('Not found', 400));
      await widgetTester.pumpWidget(MaterialApp(
          home: CharacterDetail(
        client: client,
        name: 'albedo',
      )));
      await widgetTester.pumpAndSettle();
      final findText = find.byType(Text);
      final findColumn = find.byType(Column);

      expect(findColumn, findsNothing);
      expect(findText, findsNWidgets(2));
    },
  );
}
