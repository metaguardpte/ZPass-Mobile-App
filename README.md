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

`ZPass Mobile`遵循`Flutter`开发规范，依赖`json_serializable`和`build_runner`来管理工程源代码中的`JSON`实体自动化解析模版，因此每次源代码中修改了`JSON`对象时，须在工程根目录下运行以下`JSON`模版代码同步命令：

```shell
flutter pub run build_runner build --delete-conflicting-outputs
```

## Repository synchronize

`ZPass`工程以`git submodules`方式依赖自研或第三方源代码`plugins`，因此每次重新`clone`或有源代码`plugins`更新时，须在工程根目录下运行以下`git submodules`同步命令：

```shell
git submodule update --init --recursive
```