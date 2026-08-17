import 'dart:io' as io;

import 'package:path/path.dart' as path;
import 'package:script/changelog.dart';

/// Formats an integer with thousands separators, e.g. `1767` -> `1,767`.
String formatCount(int count) {
  final digits = count.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

String updatePubspec(String content,
    {required String version, required int newCount}) {
  content = content.replaceFirst(
    RegExp(r'^version: .*$', multiLine: true),
    'version: $version',
  );
  content = content.replaceFirst(
    RegExp(r'icon set with [\d,]+\+ icons'),
    'icon set with $newCount+ icons',
  );
  return content;
}

String updateReadme(String content,
    {required String version, required int newCount}) {
  final count = formatCount(newCount);

  content = content.replaceFirst(
    RegExp(r'\*\*[\d,]+\+ beautiful, consistent icons\*\*'),
    '**$count+ beautiful, consistent icons**',
  );
  content = content.replaceFirst(
    RegExp(
        r'\*\*[\d,]+\+ Icons\*\* - Comprehensive collection from Lucide [\d.]+'),
    '**$count+ Icons** - Comprehensive collection from Lucide $version',
  );
  content = content.replaceFirst(
    RegExp(r'flutter_lucide: \^[\d.]+'),
    'flutter_lucide: ^$version',
  );
  content = content.replaceFirst(
    RegExp(r'all [\d,]+\+ icons with tags'),
    'all $count+ icons with tags',
  );
  content = content.replaceFirst(
    RegExp(
      r'Lucide [\d.]+\]\(https://github\.com/lucide-icons/lucide/releases/tag/[\d.]+\)',
    ),
    'Lucide $version](https://github.com/lucide-icons/lucide/releases/tag/$version)',
  );
  return content;
}

String updateScriptReadme(String content, {required int newCount}) {
  return content.replaceFirst(
    RegExp(r'[\d,]+\+ icon constants'),
    '${formatCount(newCount)}+ icon constants',
  );
}

/// Builds the `# <version>` CHANGELOG.md entry, appending [classifiedMarkdown]
/// (the New/Renamed/Removed sections from [classify]) when non-empty.
String buildChangelogEntry({
  required String version,
  required int oldCount,
  required int newCount,
  required String classifiedMarkdown,
}) {
  final buffer = StringBuffer()
    ..writeln('# $version')
    ..writeln()
    ..writeln('## Improvements 🚀')
    ..writeln('- Updated to Lucide Icons $version')
    ..writeln(
      '- Total icon count increased from ${formatCount(oldCount)}+ to ${formatCount(newCount)}+ icons',
    )
    ..writeln('- Updated `README.md` with the latest information');

  if (classifiedMarkdown.trim().isNotEmpty) {
    buffer
      ..writeln()
      ..write(classifiedMarkdown.trim());
  }

  return buffer.toString();
}

String prependChangelog(String content, String entry) {
  return '$entry\n\n---\n\n$content';
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
  final version = parsed['version'];
  final oldDartPath = parsed['old'];
  final newDartPath = parsed['new'];
  final iconsPath = parsed['icons'];
  final repoRoot = parsed['repo-root'] ?? '.';

  if (version == null ||
      oldDartPath == null ||
      newDartPath == null ||
      iconsPath == null) {
    io.stderr.writeln(
      'Usage: dart run lib/update_docs.dart --version <version> --old <old.dart> '
      '--new <new.dart> --icons <icons dir> [--repo-root <path>]',
    );
    io.exit(64);
  }

  final oldNames = extractIconNames(io.File(oldDartPath).readAsStringSync());
  final newNames = extractIconNames(io.File(newDartPath).readAsStringSync());
  final aliasMap = buildAliasMap(io.Directory(iconsPath));
  final result =
      classify(oldNames: oldNames, newNames: newNames, aliasMap: aliasMap);
  final classifiedMarkdown = formatMarkdown(result);

  final pubspecFile = io.File(path.join(repoRoot, 'pubspec.yaml'));
  pubspecFile.writeAsStringSync(
    updatePubspec(pubspecFile.readAsStringSync(),
        version: version, newCount: result.newCount),
  );

  final readmeFile = io.File(path.join(repoRoot, 'README.md'));
  readmeFile.writeAsStringSync(
    updateReadme(readmeFile.readAsStringSync(),
        version: version, newCount: result.newCount),
  );

  final scriptReadmeFile = io.File(path.join(repoRoot, 'script', 'README.md'));
  scriptReadmeFile.writeAsStringSync(
    updateScriptReadme(scriptReadmeFile.readAsStringSync(),
        newCount: result.newCount),
  );

  final entry = buildChangelogEntry(
    version: version,
    oldCount: result.oldCount,
    newCount: result.newCount,
    classifiedMarkdown: classifiedMarkdown,
  );

  final changelogFile = io.File(path.join(repoRoot, 'CHANGELOG.md'));
  changelogFile.writeAsStringSync(
    prependChangelog(changelogFile.readAsStringSync(), entry),
  );

  // ignore: avoid_print
  print(entry);
}
