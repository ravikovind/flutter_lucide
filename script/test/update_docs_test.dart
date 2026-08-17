import 'package:script/update_docs.dart';
import 'package:test/test.dart';

void main() {
  group('formatCount', () {
    test('adds thousands separators', () {
      expect(formatCount(1767), '1,767');
      expect(formatCount(42), '42');
      expect(formatCount(1000000), '1,000,000');
    });
  });

  group('updatePubspec', () {
    const content = '''
name: flutter_lucide
description: Flutter package for Lucide Icons. Lucide is a free, open-source icon set with 1699+ icons. It's a fork of the popular Feather icon set.
version: 1.11.0
homepage: https://lucide.dev/
''';

    test('bumps version and icon count', () {
      final updated = updatePubspec(content, version: '1.31.0', newCount: 1767);

      expect(updated, contains('version: 1.31.0'));
      expect(updated, contains('icon set with 1767+ icons'));
      expect(updated, isNot(contains('version: 1.11.0')));
    });
  });

  group('updateReadme', () {
    const content = '''
A comprehensive Flutter package providing **1,699+ beautiful, consistent icons** from the [Lucide](https://lucide.dev/) icon set.

- 🎨 **1,699+ Icons** - Comprehensive collection from Lucide 1.11.0

```yaml
dependencies:
  flutter_lucide: ^1.11.0
```

Browse **[ICONS.md](https://github.com/ravikovind/flutter_lucide/blob/main/ICONS.md)** — a searchable reference of all 1,699+ icons with tags and categories.

- **Current Version**: [Lucide 1.11.0](https://github.com/lucide-icons/lucide/releases/tag/1.11.0)
''';

    test('updates every version and icon-count reference', () {
      final updated = updateReadme(content, version: '1.31.0', newCount: 1767);

      expect(updated, contains('**1,767+ beautiful, consistent icons**'));
      expect(
          updated,
          contains(
              '**1,767+ Icons** - Comprehensive collection from Lucide 1.31.0'));
      expect(updated, contains('flutter_lucide: ^1.31.0'));
      expect(updated, contains('all 1,767+ icons with tags'));
      expect(
        updated,
        contains(
          'Lucide 1.31.0](https://github.com/lucide-icons/lucide/releases/tag/1.31.0)',
        ),
      );
      expect(updated, isNot(contains('1.11.0')));
      expect(updated, isNot(contains('1,699')));
    });
  });

  group('updateScriptReadme', () {
    test('bumps the icon constant count', () {
      final updated = updateScriptReadme(
        '- 1,699+ icon constants\n',
        newCount: 1767,
      );

      expect(updated, contains('1,767+ icon constants'));
    });
  });

  group('buildChangelogEntry', () {
    test('includes classified sections when present', () {
      final entry = buildChangelogEntry(
        version: '1.31.0',
        oldCount: 1699,
        newCount: 1767,
        classifiedMarkdown: '## New Icons 🎨\n- ad, angle',
      );

      expect(entry, startsWith('# 1.31.0'));
      expect(entry,
          contains('Total icon count increased from 1,699+ to 1,767+ icons'));
      expect(entry, contains('## New Icons 🎨'));
    });

    test('omits classified sections when nothing changed', () {
      final entry = buildChangelogEntry(
        version: '1.31.0',
        oldCount: 1767,
        newCount: 1767,
        classifiedMarkdown: '',
      );

      expect(entry, isNot(contains('## New Icons')));
    });
  });

  group('prependChangelog', () {
    test('inserts the new entry above the existing changelog with a separator',
        () {
      final updated =
          prependChangelog('# 1.11.0\n\nold entry\n', '# 1.31.0\n\nnew entry');

      expect(updated, startsWith('# 1.31.0\n\nnew entry\n\n---\n\n# 1.11.0'));
      expect(updated, contains('old entry'));
    });
  });
}
