# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.1] - 2026-04-29

### Added
- Initial stable release of FlashX
- Cross-platform support for Android, iOS, Web, Windows, macOS, and Linux
- State-management agnostic architecture compatible with GetX, Provider, Riverpod, Bloc, etc.
- Built-in notification types:
  - Success
  - Error
  - Warning
  - Info
- Persistent loading notifications support
- Future-based API using `FlashX.future()`
- Multiple built-in animations:
  - Slide
  - Fade
  - Scale
  - Elastic
  - Bounce
  - Rotation
  - iOS-style transitions
- Priority-based FIFO queue system
- Duplicate notification prevention using unique keys
- Swipe-to-dismiss support with configurable directions
- Animated countdown progress bar
- Glassmorphism (blur) effect support
- Gradient background support
- Fully custom widget support
- Primary and secondary action buttons
- Automatic light/dark theme adaptation
- RTL (Right-to-Left) language support
- Responsive UI for mobile, tablet, and desktop
- SafeArea and Dynamic Island compatibility
- Accessibility and screen reader support
- Global configuration via `FlashX.configure()`
- Zero-boilerplate initialization using `FlashXWidget.init()`

### Extensions
- Context extensions:
  - `context.flashSuccess()`
  - `context.flashError()`
  - `context.flashInfo()`
  - `context.flashWarning()`
- String extensions:
  - `"Success".flashSuccess()`
- Future extensions:
  - `future.flashFuture()`

### Features
- Dismiss notification by ID
- Dismiss all active notifications
- Persistent notification mode
- Custom themes per notification

### Documentation
- Full documentation included with example application
- Working example project added for all platforms