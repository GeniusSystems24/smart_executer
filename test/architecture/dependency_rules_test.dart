import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final packageRoot = Directory.current;
  final sourceRoot = Directory('${packageRoot.path}/lib/src');

  test('domain and application do not import frameworks or infrastructure', () {
    final forbidden = RegExp(
      r"package:(flutter|dio|logger|connectivity_plus)|"
      r"package:smart_executer/src/(infrastructure|presentation|internal|widgets)",
    );

    for (final layer in ['domain', 'application']) {
      final directory = Directory('${sourceRoot.path}/$layer');
      for (final file in _dartFiles(directory)) {
        final content = file.readAsStringSync();
        expect(
          forbidden.hasMatch(content),
          isFalse,
          reason: '${file.path} violates the dependency direction',
        );
      }
    }
  });

  test('internal package imports resolve to real Dart files', () {
    final packageImport = RegExp(
      r"(?:import|export) 'package:smart_executer/([^']+)'",
    );

    for (final file in _dartFiles(Directory('${packageRoot.path}/lib'))) {
      final content = file.readAsStringSync();
      for (final match in packageImport.allMatches(content)) {
        final target = File('${packageRoot.path}/lib/${match.group(1)!}');
        expect(
          target.existsSync(),
          isTrue,
          reason: '${file.path} points to missing ${target.path}',
        );
      }
    }
  });
}

Iterable<File> _dartFiles(Directory directory) sync* {
  for (final entity in directory.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      yield entity;
    }
  }
}
