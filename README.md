# 🔥 FlashX

> **The most powerful, beautiful, and developer-friendly Flutter notification package.**
> Zero boilerplate · Works with every state manager · Stunning by default.

[![pub.dev](https://img.shields.io/pub/v/flashx.svg)](https://pub.dev/packages/flashx)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.10-blue)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0%2B-blue)](https://dart.dev)
[![Platforms](https://img.shields.io/badge/platforms-android%20%7C%20ios%20%7C%20web%20%7C%20desktop-lightgrey)](https://flutter.dev/multi-platform)

---

## ✨ Why FlashX?

| Feature | FlashX | fluttertoast | another_flushbar | bot_toast |
|---|---|---|---|---|
| All platforms | ✅ | ⚠️ Limited | ✅ | ✅ |
| State mgmt. agnostic | ✅ | ✅ | ✅ | ✅ |
| Queue system | ✅ | ❌ | ✅ | ✅ |
| Priority queue | ✅ | ❌ | ❌ | ❌ |
| Future tracking API | ✅ | ❌ | ❌ | ❌ |
| Glassmorphism | ✅ | ❌ | ❌ | ❌ |
| 7 built-in animations | ✅ | ❌ | ⚠️ 2 | ⚠️ 3 |
| Custom widget | ✅ | ❌ | ✅ | ✅ |
| Gradient backgrounds | ✅ | ❌ | ❌ | ❌ |
| Duplicate prevention | ✅ | ❌ | ❌ | ❌ |
| Dismiss by ID | ✅ | ❌ | ❌ | ✅ |
| Progress bar | ✅ | ❌ | ✅ | ❌ |
| RTL support | ✅ | ✅ | ✅ | ✅ |
| Dart 3 / null-safe | ✅ | ✅ | ✅ | ✅ |

---

## 🚀 Quick Start (2 minutes)

### 1. Install

```yaml
dependencies:
  flashx: ^1.0.0
```

```
flutter pub get
```

### 2. Initialize

Wrap your `MaterialApp` builder — that's it:

```dart
import 'package:flashx/flashx.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: FlashXWidget.init(), // ← One line
      home: HomeScreen(),
    );
  }
}
```

### 3. Show notifications

```dart
FlashX.success("Profile saved!");
FlashX.error("Payment failed.");
FlashX.warning("Weak internet connection.");
FlashX.info("Version 2.0 is available.");
```

Done. 🎉

---

## 🎛️ All APIs at a Glance

### Convenience methods

```dart
FlashX.success("Saved");
FlashX.error("Failed", title: "Oops");
FlashX.warning("Low battery");
FlashX.info("New update");
final id = FlashX.loading("Uploading...");
FlashX.dismissById(id);
FlashX.dismissAll();
```

### Full control with FlashOptions

```dart
FlashX.show(FlashOptions(
  title: "No Internet",
  message: "Please check your connection.",
  type: FlashType.error,
  position: FlashPosition.top,
  animation: FlashAnimation.elastic,
  duration: Duration(seconds: 5),
  actionText: "Retry",
  onAction: () => reconnect(),
  secondaryActionText: "Dismiss",
  onSecondaryAction: FlashX.dismissAll,
  showProgress: true,
  dismissDirection: FlashDismissDirection.horizontal,
  priority: FlashPriority.critical,
));
```

### Future tracking

```dart
await FlashX.future(
  future: uploadData(),
  loading: "Uploading your file...",
  success: "Upload complete! 🎉",
  error: "Upload failed. Please retry.",
);
```

With dynamic messages based on result:

```dart
await FlashX.future<User>(
  future: fetchUser(),
  loading: "Fetching profile...",
  success: (user) => "Welcome back, ${user.name}!",
  error: (e) => "Error: ${e.toString()}",
);
```

### Extension methods

```dart
// On BuildContext
context.flashSuccess("Saved!");
context.flashError("Failed!");

// On String
"Done!".flashSuccess();
"Oops!".flashError();

// On Future
uploadFile().flashFuture(
  loading: "Uploading...",
  success: (_) => "Done!",
  error: (e) => "Failed: $e",
);
```

---

## 🎨 Customization

### Global config

```dart
FlashX.configure(FlashXConfig(
  position: FlashPosition.bottom,
  animation: FlashAnimation.bounce,
  duration: Duration(seconds: 3),
  borderRadius: BorderRadius.circular(20),
  blur: true,                   // Glassmorphism globally
  maxVisible: 3,                // Max stacked notifications
  stackedMode: false,           // Show one at a time (default)
  showProgress: true,
  dismissDirection: FlashDismissDirection.horizontal,
));
```

### Custom theme per notification

```dart
FlashX.show(FlashOptions(
  type: FlashType.custom,
  message: "Premium feature unlocked.",
  themeData: FlashThemeData(
    backgroundColor: Color(0xFF1E1B4B),
    textColor: Colors.white,
    iconColor: Colors.amberAccent,
    actionColor: Colors.amber,
    progressColor: Colors.amber,
    borderColor: Color(0xFF312E81),
    borderWidth: 1,
  ),
));
```

### Gradient background

```dart
FlashX.show(FlashOptions(
  type: FlashType.custom,
  title: "Pro Plan",
  message: "Upgrade to unlock all features.",
  themeData: FlashThemeData(
    backgroundColor: Colors.transparent,
    textColor: Colors.white,
    iconColor: Colors.white,
    actionColor: Colors.amber,
    progressColor: Colors.amber,
    gradient: LinearGradient(
      colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
    ),
  ),
  actionText: "Upgrade",
  onAction: () => openUpgradeScreen(),
));
```

### Glassmorphism

```dart
FlashX.show(FlashOptions(
  type: FlashType.success,
  message: "Saved with glass effect!",
  themeData: FlashThemeData.glassSuccess(dark: false),
));
```

Or enable globally:

```dart
FlashX.configure(FlashXConfig(blur: true));
```

### Custom widget

```dart
FlashX.show(FlashOptions(
  type: FlashType.custom,
  customWidget: Row(
    children: [
      CircleAvatar(backgroundImage: NetworkImage(avatarUrl)),
      SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Alice sent you a message"),
            Text("Hey! Are you free tonight?", style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    ],
  ),
));
```

---

## 🎞️ Animations

| Name | Description |
|---|---|
| `FlashAnimation.slide` | Slides in from the nearest edge |
| `FlashAnimation.fade` | Fades in/out smoothly |
| `FlashAnimation.scale` | Scales from center with ease-out-back |
| `FlashAnimation.elastic` | Spring-like elastic entrance |
| `FlashAnimation.bounce` | Bouncy entrance |
| `FlashAnimation.rotation` | Rotation + scale + fade |
| `FlashAnimation.ios` | iOS-style cubic-emphasized curve |

### Custom animation builder

```dart
FlashX.show(FlashOptions(
  message: "Custom animation!",
  animationBuilder: (controller, child) {
    return SlideTransition(
      position: Tween(begin: Offset(-2, 0), end: Offset.zero)
          .animate(CurvedAnimation(parent: controller, curve: Curves.elasticOut)),
      child: child,
    );
  },
));
```

---

## 📋 Queue & Priority

```dart
// Normal (FIFO order)
FlashX.show(FlashOptions(message: "Normal", priority: FlashPriority.normal));

// Jumps ahead of normal items
FlashX.show(FlashOptions(message: "Important!", priority: FlashPriority.high));

// Goes to the front immediately
FlashX.show(FlashOptions(
  type: FlashType.error,
  message: "Critical error!",
  priority: FlashPriority.critical,
));
```

---

## 🔑 Duplicate Prevention

```dart
// Show only once even if called multiple times
for (int i = 0; i < 5; i++) {
  FlashX.show(FlashOptions(
    message: "You are offline",
    key: "offline_banner",  // ← unique key
  ));
}
// Only one notification is shown
```

---

## 🌐 Platform Support

| Platform | Supported |
|---|---|
| Android | ✅ |
| iOS | ✅ |
| Web | ✅ |
| Windows | ✅ |
| macOS | ✅ |
| Linux | ✅ |

---

## 🧩 State Management

FlashX has **zero dependency** on any state management solution. Use it with:

- ✅ GetX — call `FlashX.success(...)` anywhere
- ✅ Provider — no setup needed
- ✅ Riverpod — works in any `ref.read()` or callback
- ✅ Bloc/Cubit — call from `BlocListener`
- ✅ MobX — call from reactions
- ✅ Stacked — call from `ViewModelBuilder`
- ✅ setState — just call it!

---

## 🗺️ Roadmap

- [ ] Push-style grouped notifications
- [ ] Custom enter/exit path animations
- [ ] Notification history panel
- [ ] Haptic feedback support
- [ ] Sound/vibration customization
- [ ] Scheduled/delayed notifications
- [ ] Notification tap-through to routes

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

1. Fork the repo
2. Create your feature branch: `git checkout -b feat/amazing-feature`
3. Commit your changes: `git commit -m 'feat: add amazing feature'`
4. Push: `git push origin feat/amazing-feature`
5. Open a pull request

Please read [CONTRIBUTING.md](CONTRIBUTING.md) first.

---

## 📄 License

[MIT License](LICENSE) © 2025 FlashX Contributors
