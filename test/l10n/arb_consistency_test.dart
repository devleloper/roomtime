import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roomtime/l10n/app_localizations.dart';

/// Keys and placeholders of every locale match the English template, and
/// Russian plurals cover the one/few/many categories.
void main() {
  Map<String, dynamic> read(String name) =>
      jsonDecode(File('lib/l10n/$name').readAsStringSync())
          as Map<String, dynamic>;

  final en = read('app_en.arb');
  final ru = read('app_ru.arb');
  Set<String> keysOf(Map<String, dynamic> arb) =>
      arb.keys.where((k) => !k.startsWith('@')).toSet();
  Set<String> placeholdersIn(String message) => RegExp(
    r'\{(\w+)[,}]',
  ).allMatches(message).map((m) => m.group(1)!).toSet();

  test('ru has exactly the keys of the en template', () {
    expect(keysOf(ru), keysOf(en));
  });

  test(
    'every template message has a description and declared placeholders',
    () {
      for (final key in keysOf(en)) {
        final meta = en['@$key'] as Map<String, dynamic>?;
        expect(meta?['description'], isA<String>(), reason: key);
        final declared =
            ((meta?['placeholders'] as Map<String, dynamic>?) ?? {}).keys
                .toSet();
        expect(placeholdersIn(en[key] as String), declared, reason: 'en $key');
        expect(placeholdersIn(ru[key] as String), declared, reason: 'ru $key');
      }
    },
  );

  test('ru plurals cover one, few and many', () {
    for (final key in keysOf(ru)) {
      final message = ru[key] as String;
      if (!message.contains(', plural,')) continue;
      for (final category in ['one{', 'few{', 'many{', 'other{']) {
        expect(message, contains(category), reason: '$key: $category');
      }
    }
  });

  test('ru plural forms pick the right word', () {
    final l10n = lookupAppLocalizations(const Locale('ru'));
    expect(l10n.roomParticipantCount(1), '1 участник');
    expect(l10n.roomParticipantCount(3), '3 участника');
    expect(l10n.roomParticipantCount(5), '5 участников');
    expect(l10n.roomParticipantCount(21), '21 участник');
    expect(l10n.homeMinutesAgo(2), '2 минуты назад');
    expect(l10n.homeMinutesAgo(11), '11 минут назад');
    expect(l10n.homeHoursAgo(24), '24 часа назад');
  });

  test('brand is never translated', () {
    expect(ru['appName'], 'RoomTime');
    expect(en['appName'], 'RoomTime');
  });
}
