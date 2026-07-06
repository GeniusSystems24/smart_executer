import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final sourceRoot = Directory('lib');

  test('domain code is framework and transport independent', () {
    final violations = _filesIn(sourceRoot)
        .where((file) => _normalized(file.path).contains('/domain/'))
        .where((file) {
      final source = file.readAsStringSync();
      return source.contains("package:flutter/") ||
          source.contains("package:dio/") ||
          source.contains("/infrastructure/");
    }).map((file) => file.path).toList();

    expect(violations, isEmpty);
  });

  test('application contracts do not depend on presentation or infrastructure', () {
    final violations = _filesIn(sourceRoot)
        .where((file) => _normalized(file.path).contains('/application/'))
        .where((file) {
      final source = file.readAsStringSync();
      return source.contains('/presentation/') ||
          source.contains('/infrastructure/') ||
          source.contains("package:flutter/") ||
          source.contains("package:dio/");
    }).map((file) => file.path).toList();

    expect(violations, isEmpty);
  });

  test('presentation code does not import Dio directly', () {
    final violations = _filesIn(sourceRoot)
        .where((file) => _normalized(file.path).contains('/presentation/'))
        .where((file) => file.readAsStringSync().contains("package:dio/dio.dart"))
        .map((file) => file.path)
        .toList();

    expect(violations, isEmpty);
  });

  test('legacy example paths remain compatibility exports', () {
    final compatibilityFiles = [
      File('lib/home_page.dart'),
      File('lib/core/app_router.dart'),
      File('lib/core/app_theme.dart'),
      File('lib/pages/basic_usage_page.dart'),
      File('lib/pages/status_cards_page.dart'),
    ];

    for (final file in compatibilityFiles) {
      expect(file.existsSync(), isTrue, reason: file.path);
      expect(file.readAsStringSync(), contains('export '), reason: file.path);
    }
  });
}

Iterable<File> _filesIn(Directory directory) {
  return directory
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'));
}

String _normalized(String path) => path.replaceAll('\\', '/');
