import 'dart:convert' as convert;
import 'dart:io' as io;

import 'package:path/path.dart' as path;

/// Result of diffing the old and new sets of icon constant names.
class ChangelogResult {
  const ChangelogResult({
    required this.newIcons,
    required this.renamed,
    required this.removed,
    required this.oldCount,
    required this.newCount,
  });

  /// Icons present in the new set but not derived from a renamed old icon.
  final List<String> newIcons;

  /// Pairs of (old name, new name) for icons whose metadata declares a
  /// deprecated alias pointing at a name that used to be a separate icon.
  final List<MapEntry<String, String>> renamed;

  /// Icons present in the old set with no matching entry in the new set.
  final List<String> removed;

  final int oldCount;
  final int newCount;
}

final _iconNameRegExp = RegExp(r'static const IconData (\w+) =');

/// Extracts every `static const IconData <name> =` constant name from
/// generated `flutter_lucide.dart` source.
Set<String> extractIconNames(String dartSource) {
  return _iconNameRegExp.allMatches(dartSource).map((m) => m.group(1)!).toSet();
}

/// Builds a map of deprecated alias name (snake_case) -> current icon name
/// (snake_case) by reading the `aliases` field of every icon metadata file
/// in [iconsDir].
Map<String, String> buildAliasMap(io.Directory iconsDir) {
  final map = <String, String>{};

  final files = iconsDir.listSync().whereType<io.File>().where(
        (f) => f.path.endsWith('.json'),
      );

  for (final file in files) {
    final name = path.basenameWithoutExtension(file.path);
    final nameAsIcon = name.split('-').join('_');

    final decoded = convert.json.decode(file.readAsStringSync());
    final details = Map<String, dynamic>.from(decoded is Map ? decoded : {});
    final aliases = details['aliases'];
    if (aliases is! List) continue;

    for (final alias in aliases) {
      if (alias is! Map) continue;
      final aliasDetails = Map<String, dynamic>.from(alias);
      if (aliasDetails['deprecated'] != true) continue;

      final aliasName = aliasDetails['name']?.toString();
      if (aliasName == null) continue;

      map[aliasName.split('-').join('_')] = nameAsIcon;
    }
  }

  return map;
}

/// Classifies the diff between [oldNames] and [newNames] into genuinely new
/// icons, renames (resolved via [aliasMap]), and genuinely removed icons.
ChangelogResult classify({
  required Set<String> oldNames,
  required Set<String> newNames,
  required Map<String, String> aliasMap,
}) {
  final added = newNames.difference(oldNames);
  final removedRaw = oldNames.difference(newNames);

  final renamed = <MapEntry<String, String>>[];
  final stillRemoved = <String>[];

  for (final oldName in removedRaw) {
    final target = aliasMap[oldName];
    if (target != null && added.contains(target)) {
      renamed.add(MapEntry(oldName, target));
      added.remove(target);
    } else {
      stillRemoved.add(oldName);
    }
  }

  final newIcons = added.toList()..sort();
  renamed.sort((a, b) => a.key.compareTo(b.key));
  stillRemoved.sort();

  return ChangelogResult(
    newIcons: newIcons,
    renamed: renamed,
    removed: stillRemoved,
    oldCount: oldNames.length,
    newCount: newNames.length,
  );
}

String toKebab(String snake) => snake.split('_').join('-');

/// Renders a [ChangelogResult] as the New/Renamed/Removed sections used in
/// `CHANGELOG.md`. Sections with nothing to report are omitted entirely.
String formatMarkdown(ChangelogResult result) {
  final buffer = StringBuffer();

  if (result.newIcons.isNotEmpty) {
    buffer
      ..writeln('## New Icons 🎨')
      ..writeln('- ${result.newIcons.map(toKebab).join(', ')}')
      ..writeln();
  }

  if (result.renamed.isNotEmpty) {
    buffer.writeln('## Renamed Icons ✏️');
    for (final entry in result.renamed) {
      buffer.writeln(
          '- `${toKebab(entry.key)}` renamed to `${toKebab(entry.value)}`');
    }
    buffer.writeln();
  }

  if (result.removed.isNotEmpty) {
    buffer
      ..writeln('## Removed Icons 🗑️')
      ..writeln('- ${result.removed.map(toKebab).join(', ')}')
      ..writeln();
  }

  return buffer.toString().trimRight();
}

Map<String, String> _parseArgs(List<String> args) {
  final parsed = <String, String>{};
  for (var i = 0; i < args.length - 1; i++) {
    if (args[i].startsWith('--')) {
      parsed[args[i].substring(2)] = args[i + 1];
    }
  }
  return parsed;
}

Future<void> main(List<String> args) async {
  final parsed = _parseArgs(args);
  final oldPath = parsed['old'];
  final newPath = parsed['new'];
  final iconsPath = parsed['icons'];

  if (oldPath == null || newPath == null || iconsPath == null) {
    io.stderr.writeln(
      'Usage: dart run lib/changelog.dart --old <old.dart> --new <new.dart> --icons <icons dir>',
    );
    io.exit(64);
  }

  final oldNames = extractIconNames(io.File(oldPath).readAsStringSync());
  final newNames = extractIconNames(io.File(newPath).readAsStringSync());
  final aliasMap = buildAliasMap(io.Directory(iconsPath));

  final result =
      classify(oldNames: oldNames, newNames: newNames, aliasMap: aliasMap);

  io.stderr.writeln('Icon count: ${result.oldCount} -> ${result.newCount}');
  // ignore: avoid_print
  print(formatMarkdown(result));
}
