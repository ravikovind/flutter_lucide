import 'package:path/path.dart' as path;
import 'dart:io' as io;
import 'dart:convert' as convert;

Future<void> main() async {
  final current = path.current;

  /// read old.md file
  // final old = io.File(path.join(current, 'old.md'));
  // final content = await old.readAsString();
  // /*
  //  static const IconData vegan = IconData(0xee50, fontFamily: _fontFamily, fontPackage: _fontPackage);
  // */
  // /// regExp: static const IconData start to fontPackage: _fontPackage); end
  // final regExp = RegExp(
  //   r'static const IconData [\w\s]+ = IconData\([\w\s,]+, fontFamily: [\w\s]+, fontPackage: [\w\s]+\)',
  // );
  // final matches = regExp.allMatches(content);
  // final icons = <(String, String)>[];
  // for (final match in matches) {
  //   final line = match.group(0);
  //   if (line == null) continue;
  //   final parts = ((line.split(r'static const IconData ')
  //             ..removeWhere((element) => element.isEmpty))
  //           .join()
  //           .split(' = IconData('))
  //       .map((e) {
  //     return e
  //         .split(', fontFamily: _fontFamily, fontPackage: _fontPackage)')
  //         .first;
  //   }).toList();
  //   icons.add((parts.first, parts.last));
  // }

  final info = io.File(path.join(current, 'info.json'));
  final json = await info.readAsString();
  final map = Map<String, dynamic>.from(
    convert.json.decode(json) ?? <String, dynamic>{},
  );

  /// read icons directory
  final dir = io.Directory(path.join(current, 'icons'));

  /// all icons
  final files =
      dir.listSync().where((element) => element.path.endsWith('.json')).toList()
        ..sort((a, b) {
          final aName = path.split(a.path).last.split('.').first;
          final bName = path.split(b.path).last.split('.').first;
          return aName.compareTo(bName);
        });

  final list = <String>[];

  for (final file in files) {
    final name = path.split(file.path).last.split('.').first;
    final info = map.containsKey(name)
        ? Map<String, dynamic>.from(map[name])
        : <String, dynamic>{};
    final json = await io.File(file.path).readAsString();
    final details = Map<String, dynamic>.from(
      convert.json.decode(json) ?? <String, dynamic>{},
    );

    final nameAsIcon = name.split('-').join('_');
    final encoded = info['encodedCode']?.toString().replaceAll('\\', '0x');

    final tags = details['tags'] ?? <String>[];
    final categories = details['categories'] ?? <String>[];
    final contributors = details['contributors']
            ?.map((e) => '[https://github.com/$e](https://github.com/$e)')
            ?.toList() ??
        <String>[];

    final str = '''
  /// Represents the [$nameAsIcon] icon from the Lucide icon set.
  /// 
  /// Description:
  /// - The [$nameAsIcon] icon is a graphical symbol that conveys a specific idea or functionality related to ${tags.join(', ')}.
  /// - It belongs to the ${categories.join(', ')} categories.
  /// 
  /// Acknowledgements:
  /// - Contributions from ${contributors.join(', ')} have been instrumental in the development of this icon.
  /// 
  /// - For more insights, please visit the Lucide icon library at [https://lucide.dev/].
  /// 
  static const IconData $nameAsIcon = IconData($encoded, fontFamily: _fontFamily, fontPackage: _fontPackage);
  ''';
    list.add(str);
  }

  final newContent = '''
// ignore_for_file: constant_identifier_names
import 'package:flutter/widgets.dart';

///  Lucide is a free, open-source icon set with 1450+ icons. It's a fork of the popular Feather icon set.
/// Lucide is licensed under the ISC license.
///
/// for more info visit [https://lucide.dev/](https://lucide.dev/).
///
@staticIconProvider
abstract final class LucideIcons {
  /// const constructor for [LucideIcons]
  const LucideIcons._();

  // /// [fromCode] is a helper function that returns the icon data for a particular icon code.
  // /// The icon code can be found in the Lucide icon library at [https://lucide.dev/](https://lucide.dev/).
  // ///
  // /// avoid using this function directly, instead use the icon directly from the [LucideIcons] class.
  // /// Tree shaking will remove the unused icons from the final build.
  // /// This will reduce the final build size.
  // ///
  // /// Example: To use the [a_arrow_down] icon, use the following code:
  // /// ```dart
  // /// Icon(LucideIcons.fromCode(0xe900))
  // /// ```
  // ///
  // Removed:
  // Unable to tree shake when build #3
  // [https://github.com/ravikovind/flutter_lucide/issues/3]
  //
  // static IconData? fromCode(int code) {
  //   try {
  //     return IconData(code, fontFamily: _fontFamily, fontPackage: _fontPackage);
  //   } on Exception catch (_) {
  //     return null;
  //   }
  // }

  /// [_fontFamily] is the font family for the lucide icon set.
  static const String _fontFamily = 'lucide';

  /// [_fontPackage] is the font package for the lucide icon set.
  static const String _fontPackage = 'flutter_lucide';

  ${list.join('\n')}
  }
  ''';

  final script = io.File(path.join(current, 'flutter_lucide_update.txt'));
  await script.writeAsString(newContent);
  return print('Script completed successfully! 🎉 🎉');
}
