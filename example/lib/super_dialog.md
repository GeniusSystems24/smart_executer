<div align="center">

# ↔️ Super Dialog

### Beautiful Animated Dialogs for Flutter

[![pub package](https://img.shields.io/pub/v/super_dialog.svg?style=for-the-badge&logo=dart&logoColor=white&labelColor=0175C2&color=02569B)](https://pub.dev/packages/super_dialog)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.10+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/Platform-All-blueviolet?style=for-the-badge)](https://flutter.dev)
[![Live Demo](https://img.shields.io/badge/🚀_Live_Demo-View_Online-success?style=for-the-badge)](https://geniussystems24.github.io/super_dialog)

*A powerful, flexible, and beautifully animated dialog toolkit for Flutter.*  
*Create stunning dialogs with smooth slide, scale, and fade animations.*

---

[📖 Documentation](#-api-reference) • [🚀 Quick Start](#-quick-start) • [📚 Examples](#-examples) • [🧪 Demo](#-demo-app)

</div>

---

## ✨ Features

<table>
<tr>
<td width="50%">

### 🎬 Rich Animations
- **24 Pre-built animation styles**
- Slide, rotation, bounce, elastic
- Flip & expand effects
- RTL-aware transitions

</td>
<td width="50%">

### 📍 Positioned Dialogs
- **9 screen positions** (3×3 grid)
- Custom start & end positions
- **10 transition types**
- Fine-grained control

</td>
</tr>
<tr>
<td width="50%">

### ⚙️ Highly Configurable
- Custom duration & curves
- Barrier color & blur
- Size constraints
- Safe area handling

</td>
<td width="50%">

### 🔧 Developer Friendly
- Simple, intuitive API
- Full TypeScript-like generics
- Lifecycle callbacks
- Zero dependencies

</td>
</tr>
</table>

---

## 📦 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  super_dialog: ^0.3.0
```

```bash
flutter pub get
```

---

## 🚀 Quick Start

### Basic Dialog

```dart
import 'package:super_dialog/super_dialog.dart';

SuperDialog.showAnimatedDialog<void>(
  context,
  (context) => const MyCustomDialog(),
  animation: DialogAnimation.bottomToTop,
);
```

### Positioned Dialog (NEW in 0.2.0)

```dart
SuperDialog.showPositionedDialog<void>(
  context,
  (context) => const MyDialog(),
  startPosition: DialogPosition.topEnd,
  endPosition: DialogPosition.center,
  transitionType: PositionedTransitionType.slideFadeScale,
);
```

---

## 🎬 Animation Types

### Slide Animations

<table>
<tr>
<th>Animation</th>
<th>Description</th>
<th>Best For</th>
</tr>
<tr>
<td><code>startToEnd</code></td>
<td>Slides from leading edge (RTL-aware)</td>
<td>Side drawers, navigation panels</td>
</tr>
<tr>
<td><code>endToStart</code></td>
<td>Slides from trailing edge (RTL-aware)</td>
<td>Settings panels, details views</td>
</tr>
<tr>
<td><code>topToBottom</code></td>
<td>Drops from top</td>
<td>Notifications, banners, alerts</td>
</tr>
<tr>
<td><code>bottomToTop</code></td>
<td>Rises from bottom</td>
<td>Action sheets, bottom menus</td>
</tr>
</table>

### Scale & Fade Animations

<table>
<tr>
<th>Animation</th>
<th>Description</th>
<th>Best For</th>
</tr>
<tr>
<td><code>centerScale</code></td>
<td>Scales from 92% with fade</td>
<td>Confirmations, important alerts</td>
</tr>
<tr>
<td><code>centerFade</code></td>
<td>Simple fade in/out</td>
<td>Toasts, status messages</td>
</tr>
</table>

### Rotation Animations ✨ NEW

<table>
<tr>
<th>Animation</th>
<th>Description</th>
<th>Best For</th>
</tr>
<tr>
<td><code>rotateIn</code></td>
<td>Rotates -15° to 0° with fade</td>
<td>Fun notifications, casual dialogs</td>
</tr>
<tr>
<td><code>rotateScale</code></td>
<td>Combines rotation + scale + fade</td>
<td>Important announcements, special dialogs</td>
</tr>
</table>

### Bounce Animations ✨ NEW

<table>
<tr>
<th>Animation</th>
<th>Description</th>
<th>Best For</th>
</tr>
<tr>
<td><code>bounceIn</code></td>
<td>Elastic bounce scale effect</td>
<td>Success messages, celebrations</td>
</tr>
<tr>
<td><code>bounceSlidBottom</code></td>
<td>Slides from bottom with bounce</td>
<td>Action sheets with personality</td>
</tr>
</table>

### Elastic Animations ✨ NEW

<table>
<tr>
<th>Animation</th>
<th>Description</th>
<th>Best For</th>
</tr>
<tr>
<td><code>elasticIn</code></td>
<td>Elastic scale with overshoot</td>
<td>Interactive dialogs, game UIs</td>
</tr>
<tr>
<td><code>elasticSlideBottom</code></td>
<td>Slides up with elastic overshoot</td>
<td>Modern bottom sheets</td>
</tr>
</table>

### Expand Animations ✨ NEW

<table>
<tr>
<th>Animation</th>
<th>Description</th>
<th>Best For</th>
</tr>
<tr>
<td><code>expandVertical</code></td>
<td>Expands 0% to 100% height</td>
<td>Dropdown menus, expandable panels</td>
</tr>
<tr>
<td><code>expandHorizontal</code></td>
<td>Expands 0% to 100% width</td>
<td>Side panels, horizontal menus</td>
</tr>
<tr>
<td><code>expandCenter</code></td>
<td>Expands uniformly from center</td>
<td>Centered modals, overlays</td>
</tr>
</table>

### Flip Animations ✨ NEW

<table>
<tr>
<th>Animation</th>
<th>Description</th>
<th>Best For</th>
</tr>
<tr>
<td><code>flipHorizontal</code></td>
<td>3D flip around X-axis</td>
<td>Revealing information, flip cards</td>
</tr>
<tr>
<td><code>flipVertical</code></td>
<td>3D flip around Y-axis</td>
<td>Card reveals, page transitions</td>
</tr>
</table>

### Combined Animations ✨ NEW

<table>
<tr>
<th>Animation</th>
<th>Description</th>
<th>Best For</th>
</tr>
<tr>
<td><code>slideRotateBottom</code></td>
<td>Slide from bottom + rotation</td>
<td>Modern mobile UIs, action sheets</td>
</tr>
<tr>
<td><code>slideRotateTop</code></td>
<td>Slide from top + rotation</td>
<td>Notifications, top banners</td>
</tr>
<tr>
<td><code>slideScaleStart</code></td>
<td>Slide from start + scale</td>
<td>Navigation panels, side menus</td>
</tr>
<tr>
<td><code>slideScaleEnd</code></td>
<td>Slide from end + scale</td>
<td>Settings panels, detail views</td>
</tr>
</table>

---

## 📍 Positioned Dialogs (v0.2.0)

Fine-grained control over dialog positioning with a 3×3 grid system:

```
┌─────────────┬─────────────┬─────────────┐
│  topStart   │  topCenter  │   topEnd    │
├─────────────┼─────────────┼─────────────┤
│ centerStart │   center    │  centerEnd  │
├─────────────┼─────────────┼─────────────┤
│ bottomStart │bottomCenter │  bottomEnd  │
└─────────────┴─────────────┴─────────────┘
```

### DialogPosition Enum

| Position | Description |
|:---------|:------------|
| `topStart` | Top-left (RTL: top-right) |
| `topCenter` | Top-center |
| `topEnd` | Top-right (RTL: top-left) |
| `centerStart` | Center-left (RTL: center-right) |
| `center` | Center of screen |
| `centerEnd` | Center-right (RTL: center-left) |
| `bottomStart` | Bottom-left (RTL: bottom-right) |
| `bottomCenter` | Bottom-center |
| `bottomEnd` | Bottom-right (RTL: bottom-left) |
| `offScreen` | Outside screen (for slide-in) |

### PositionedTransitionType Enum

| Type | Description |
|:-----|:------------|
| `slide` | Pure sliding motion |
| `slideFade` | Slide with opacity fade |
| `slideScale` | Slide with zoom effect |
| `slideFadeScale` | All three combined |
| `fade` | Opacity only (no movement) |
| `scale` | Zoom only (no movement) |
| `scaleFade` | Zoom with opacity (no movement) |
| `bounce` | Bouncy entrance with elastic curve |
| `elastic` | Elastic overshoot effect |
| `zoom` | Smooth zoom with ease-out curve |

### Usage Example

```dart
// Corner to center with all effects
SuperDialog.showPositionedDialog<void>(
  context,
  (context) => MyDialog(),
  startPosition: DialogPosition.bottomEnd,
  endPosition: DialogPosition.center,
  transitionType: PositionedTransitionType.slideFadeScale,
  config: const SuperDialogConfig(
    openDuration: Duration(milliseconds: 400),
    openCurve: Curves.easeOutBack,
  ),
);

// Slide from off-screen to bottom
SuperDialog.showPositionedDialog<void>(
  context,
  (context) => BottomSheet(),
  startPosition: DialogPosition.offScreen,
  endPosition: DialogPosition.bottomCenter,
);
```

---

## 📖 API Reference

### SuperDialog Methods

```dart
// Standard dialog (barrier dismissible by default)
SuperDialog.showAnimatedDialog<T>(...);

// Full control dialog (barrier NOT dismissible by default)
SuperDialog.showAnimatedGeneralDialog<T>(...);

// Platform-adaptive dialog (iOS: bottom sheet style)
SuperDialog.showAnimatedAdaptiveDialog<T>(...);

// Positioned dialog with custom start/end positions (NEW)
SuperDialog.showPositionedDialog<T>(...);
```

### SuperDialogConfig

Fine-tune animation timing:

```dart
const SuperDialogConfig({
  Duration openDuration = const Duration(milliseconds: 300),
  Duration closeDuration = const Duration(milliseconds: 300),
  Curve openCurve = Curves.easeInOut,
  Curve closeCurve = Curves.easeInOut,
});
```

### Common Parameters

| Parameter | Type | Default | Description |
|:----------|:-----|:--------|:------------|
| `context` | `BuildContext` | *required* | Build context |
| `builder` | `WidgetBuilder` | *required* | Dialog content builder |
| `animation` | `DialogAnimation` | `startToEnd` | Animation style |
| `config` | `SuperDialogConfig?` | `null` | Timing configuration |
| `constraints` | `BoxConstraints?` | `null` | Size constraints |
| `barrierDismissible` | `bool?` | `true`* | Tap outside to dismiss |
| `barrierColor` | `Color?` | `#B3000000` | Barrier overlay color |
| `barrierBlur` | `double?` | `null` | Gaussian blur amount |
| `useSafeArea` | `bool` | `true` | Respect safe area |
| `useRootNavigator` | `bool?` | `true` | Use root navigator |
| `onDismissed` | `VoidCallback?` | `null` | Dismissal callback |

<sub>*Default varies by method and platform</sub>

### Positioned Dialog Parameters

| Parameter | Type | Default | Description |
|:----------|:-----|:--------|:------------|
| `startPosition` | `DialogPosition` | *required* | Start position |
| `endPosition` | `DialogPosition` | *required* | End position |
| `transitionType` | `PositionedTransitionType` | `slideFade` | Transition effect |

---

## 📚 Examples

<details>
<summary><b>🗂️ Slide-In Drawer</b></summary>

```dart
SuperDialog.showAnimatedDialog(
  context,
  (context) => FractionallySizedBox(
    widthFactor: 0.7,
    alignment: AlignmentDirectional.centerStart,
    child: const NavigationDrawer(),
  ),
  animation: DialogAnimation.startToEnd,
  barrierColor: Colors.black26,
);
```
</details>

<details>
<summary><b>📍 Positioned Corner Dialog</b></summary>

```dart
SuperDialog.showPositionedDialog(
  context,
  (context) => const NotificationCard(),
  startPosition: DialogPosition.topEnd,
  endPosition: DialogPosition.topEnd,
  transitionType: PositionedTransitionType.slideFade,
);
```
</details>

<details>
<summary><b>🔄 Corner to Center Transition</b></summary>

```dart
SuperDialog.showPositionedDialog(
  context,
  (context) => const ModalDialog(),
  startPosition: DialogPosition.bottomStart,
  endPosition: DialogPosition.center,
  transitionType: PositionedTransitionType.slideFadeScale,
);
```
</details>

<details>
<summary><b>📋 Bottom Action Sheet</b></summary>

```dart
SuperDialog.showPositionedDialog(
  context,
  (context) => const ActionSheet(),
  startPosition: DialogPosition.offScreen,
  endPosition: DialogPosition.bottomCenter,
  transitionType: PositionedTransitionType.slideFade,
);
```
</details>

<details>
<summary><b>✅ Confirmation Modal</b></summary>

```dart
final confirmed = await SuperDialog.showAnimatedDialog<bool>(
  context,
  (context) => ConfirmDialog(
    onConfirm: () => Navigator.pop(context, true),
    onCancel: () => Navigator.pop(context, false),
  ),
  animation: DialogAnimation.centerScale,
  constraints: const BoxConstraints(maxWidth: 400),
);
```
</details>

<details>
<summary><b>📱 Platform Adaptive</b></summary>

```dart
SuperDialog.showAnimatedAdaptiveDialog(
  context,
  (context) => const CrossPlatformDialog(),
);
```
</details>

<details>
<summary><b>🎯 Rotation Animation</b></summary>

```dart
SuperDialog.showAnimatedDialog(
  context,
  (context) => const FunNotification(),
  animation: DialogAnimation.rotateIn,
  config: const SuperDialogConfig(
    openDuration: Duration(milliseconds: 400),
    openCurve: Curves.easeOutBack,
  ),
);
```
</details>

<details>
<summary><b>🎈 Bounce Effect</b></summary>

```dart
SuperDialog.showAnimatedDialog(
  context,
  (context) => const SuccessDialog(),
  animation: DialogAnimation.bounceIn,
  config: const SuperDialogConfig(
    openDuration: Duration(milliseconds: 600),
  ),
);
```
</details>

<details>
<summary><b>🔄 Flip Animation</b></summary>

```dart
SuperDialog.showAnimatedDialog(
  context,
  (context) => const FlipCard(),
  animation: DialogAnimation.flipVertical,
  config: const SuperDialogConfig(
    openDuration: Duration(milliseconds: 500),
    openCurve: Curves.easeInOut,
  ),
);
```
</details>

<details>
<summary><b>📏 Expand Effect</b></summary>

```dart
SuperDialog.showAnimatedDialog(
  context,
  (context) => const ExpandingPanel(),
  animation: DialogAnimation.expandVertical,
  config: const SuperDialogConfig(
    openDuration: Duration(milliseconds: 350),
    openCurve: Curves.easeOutCubic,
  ),
);
```
</details>

---

## 🧪 Demo App

### 🌐 Live Demo

[👉 Try it online: https://geniussystems24.github.io/super_dialog](https://geniussystems24.github.io/super_dialog)

The package includes a comprehensive example app with:

- **50+ animation demonstrations** (24 animation types)
- **90 positioned combinations** (9 positions × 10 transition types)
- Light/Dark theme support
- Beautiful, modern UI with enhanced card design
- Powered by `go_router` for modern navigation

### Run Locally

```bash
cd example
flutter run
```

---

## 📋 Requirements

| Requirement | Version |
|:------------|:--------|
| Dart SDK | `≥3.10.3` |
| Flutter | `≥1.17.0` |

### Supported Platforms

✅ Android • ✅ iOS • ✅ Web • ✅ Windows • ✅ macOS • ✅ Linux

---

## 📄 License

```
MIT License

Copyright (c) 2025 Genius Systems

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
```

---

<div align="center">

<sub>Built with ❤️ by <b>Genius Systems 24</b></sub>

</div>
