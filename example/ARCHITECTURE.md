# Example Architecture

The example app is organized by feature while preserving every route and the
legacy import paths used before the refactor.

## Structure

```text
lib/
├── app/                       # bootstrap, routing, theme, composition root
├── features/
│   └── <feature>/
│       ├── domain/            # framework-independent entities and models
│       ├── application/       # contracts required by the feature
│       ├── infrastructure/    # Dio and other technical adapters
│       └── presentation/
│           ├── controllers/   # MVC controllers and observable state
│           ├── models/        # presentation-only models
│           └── pages/         # Flutter views
├── shared/
│   ├── domain/
│   ├── application/
│   ├── infrastructure/
│   └── presentation/
├── core/                      # compatibility exports
└── pages/                     # compatibility exports
```

## Dependency direction

```text
View -> Controller -> Application contract / Domain model
Infrastructure -> Application contract / Domain model
App composition root -> concrete Infrastructure implementations
```

Domain and application files do not import Flutter or Dio. Controllers consume
`DemoHttpClient`, while `DioDemoHttpClient` remains an infrastructure detail.
The exception-builder demonstration follows the same rule through
`ExceptionDemoAdapter`.

## MVC mapping

- **Model:** feature entities, immutable demo models, and transport-independent
  response models.
- **View:** pages and reusable widgets. Views render state and own only
  presentation concerns such as dialogs, animation, and text fields.
- **Controller:** coordinates commands, state transitions, SmartExecuter calls,
  pagination, retries, and optimistic updates.

## Compatibility

The previous files under `lib/core`, `lib/pages`, and `lib/home_page.dart` remain
small export shims. Existing example imports therefore continue to resolve,
while new code uses the feature-first paths.
