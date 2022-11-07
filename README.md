# zpass

Your digital assets management and automation tool.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Build Environment

- Flutter
```yaml
Flutter: stable 3.3.4
Engine revision: c08d7d5efc
Dart: 2.18.2
DevTools: 2.15.0
```

- Android
```yaml
Android Studio: Dolphin | 2021.3.1
Android SDK: 30.0.3
Java OpenJDK: build 11.0.13+0-b1751.21-8125866
Flutter plugin: https://plugins.jetbrains.com/plugin/9212-flutter
Dart plugin: https://plugins.jetbrains.com/plugin/6351-dart
```

## International Auto Generate
For null-safety please update Android Studio plugin: Flutter Intl.

```shell
flutter gen-l10n

# For CI/CD
flutter pub global activate intl_utils
flutter pub global run intl_utils:generate
```

## JSON Auto Generate

`ZPass Mobile` follows the `Flutter` development specification and relies on `json_serializable` and `build_runner` to manage the `JSON` entity automatic parsing template in the project source code. Therefore, every time the `JSON` object is modified in the source code, it must be Run the following `JSON` template code synchronization command in the project root directory

```shell
flutter pub run build_runner build --delete-conflicting-outputs
```

## Repository synchronize

The `ZPass Mobile` project relies on self-developed or third-party source code `plugins` in the form of `git submodules`, so every time you re `clone` or update the source code `plugins`, you must run the following synchronization command

```shell
git submodule update --init --recursive
```