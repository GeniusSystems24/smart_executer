# Example Verification Results

## Summary

- Checks passed: **15/15**
- Checks failed: **0**
- Dart source files checked: **117**
- MVC controllers: **16**
- Domain model/entity files: **11**
- Infrastructure adapter files: **2**
- Added test files: **5**

## Checks

- PASS — **Internal imports/exports resolve**: 117 Dart files checked; missing=0
- PASS — **Lexical delimiter/string integrity**: files with issues=0
- PASS — **No internal import/export cycles**: cycles=0
- PASS — **Domain is framework/transport independent**: violations=0
- PASS — **Application contracts point inward**: violations=0
- PASS — **Presentation has no direct Dio import**: violations=0
- PASS — **Dio is isolated to infrastructure**: imports=2
- PASS — **Legacy example import shims retained**: checked=9; invalid=0
- PASS — **Public example declarations preserved**: old=79; missing=0
- PASS — **Route classes preserved**: old=24; new=24
- PASS — **Route paths preserved**: paths=23
- PASS — **widgets.dart public widgets preserved**: expected=8; missing=0
- PASS — **premium_widgets.dart public widgets preserved**: expected=12; missing=0
- PASS — **No known num-to-int clamp hazards**: hazards=0
- PASS — **YAML files parse**: pubspec.yaml and analysis_options.yaml parsed

## Tooling limitation

Flutter and Dart SDK executables are not installed in the review environment, so `flutter analyze`, `dart format`, and `flutter test` could not be executed here. The checks above are deterministic static checks over the package structure, dependency graph, declarations, route configuration, delimiters, imports, and architecture boundaries. Run the following in a Flutter environment before publishing:

```bash
cd example
flutter pub get
dart format --set-exit-if-changed lib test
flutter analyze
flutter test
```

