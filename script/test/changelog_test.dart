import 'dart:io';

import 'package:script/changelog.dart';
import 'package:test/test.dart';

void main() {
  group('extractIconNames', () {
    test('extracts icon constant names from generated dart source', () {
      const source = '''
        static const IconData foo = IconData(0x1, fontFamily: _fontFamily, fontPackage: _fontPackage);
        static const IconData bar = IconData(0x2, fontFamily: _fontFamily, fontPackage: _fontPackage);
      ''';

      expect(extractIconNames(source), {'foo', 'bar'});
    });

    test('returns an empty set when no icons are present', () {
      expect(extractIconNames('abstract final class LucideIcons {}'), isEmpty);
    });
  });

  group('buildAliasMap', () {
    late Directory dir;

    setUp(() {
      dir = Directory.systemTemp.createTempSync('changelog_test');
    });

    tearDown(() {
      dir.deleteSync(recursive: true);
    });

    test('reads deprecated aliases from icon metadata', () {
      File('${dir.path}/face-angry.json').writeAsStringSync('''
        {
          "aliases": [
            {"name": "angry", "deprecated": true, "deprecationReason": "alias.name"}
          ]
        }
      ''');
      File('${dir.path}/unrelated.json').writeAsStringSync('{}');

      expect(buildAliasMap(dir), {'angry': 'face_angry'});
    });

    test('ignores non-deprecated aliases', () {
      File('${dir.path}/foo.json').writeAsStringSync('''
        {
          "aliases": [
            {"name": "bar", "deprecated": false}
          ]
        }
      ''');

      expect(buildAliasMap(dir), isEmpty);
    });
  });

  group('classify', () {
    test('splits a diff into new, renamed, and removed icons', () {
      final result = classify(
        oldNames: {'foo', 'bar', 'baz'},
        newNames: {'foo', 'qux', 'quux'},
        aliasMap: {'baz': 'quux'},
      );

      expect(result.newIcons, ['qux']);
      expect(result.renamed, hasLength(1));
      expect(result.renamed.single.key, 'baz');
      expect(result.renamed.single.value, 'quux');
      expect(result.removed, ['bar']);
      expect(result.oldCount, 3);
      expect(result.newCount, 3);
    });

    test('treats icons with no matching alias as truly removed', () {
      final result =
          classify(oldNames: {'a', 'b'}, newNames: {'a'}, aliasMap: {});

      expect(result.newIcons, isEmpty);
      expect(result.renamed, isEmpty);
      expect(result.removed, ['b']);
    });

    test(
        'does not treat a coincidental alias target as a rename if the target was not actually added',
        () {
      // alias map claims 'old' -> 'existing', but 'existing' was already
      // present before, so it must not be reported as a rename.
      final result = classify(
        oldNames: {'old', 'existing'},
        newNames: {'existing'},
        aliasMap: {'old': 'existing'},
      );

      expect(result.newIcons, isEmpty);
      expect(result.renamed, isEmpty);
      expect(result.removed, ['old']);
    });
  });

  group('formatMarkdown', () {
    test('omits sections with nothing to report', () {
      const result = ChangelogResult(
        newIcons: ['new_icon'],
        renamed: [],
        removed: [],
        oldCount: 1,
        newCount: 2,
      );

      final markdown = formatMarkdown(result);

      expect(markdown, contains('## New Icons 🎨'));
      expect(markdown, contains('new-icon'));
      expect(markdown, isNot(contains('## Renamed Icons')));
      expect(markdown, isNot(contains('## Removed Icons')));
    });

    test('renders renamed icons as kebab-case old -> new pairs', () {
      const result = ChangelogResult(
        newIcons: [],
        renamed: [MapEntry('smile', 'face_slightly_smiling')],
        removed: [],
        oldCount: 1,
        newCount: 1,
      );

      final markdown = formatMarkdown(result);

      expect(markdown, contains('`smile` renamed to `face-slightly-smiling`'));
    });

    test('returns an empty string when nothing changed', () {
      const result = ChangelogResult(
        newIcons: [],
        renamed: [],
        removed: [],
        oldCount: 1,
        newCount: 1,
      );

      expect(formatMarkdown(result), isEmpty);
    });
  });
}
