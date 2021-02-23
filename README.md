# Flutter Animation Demo

常用的动画效果示例集合。仅供学习参考。

## Flutter版本

分支：master

## 打包Android

```dart
flutter build apk
flutter build apk --target-platform android-arm
flutter build apk --target-platform android-arm64
flutter build apk --target-platform android-x64

// 分隔包
flutter build apk --split-per-abi
flutter build apk --target-platform android-arm64 --split-per-abi

```

## 打包ios

```yaml
flutter build ios --release
// 再到xcode下进行打包
```

## 打包桌面应用

```yaml
flutter build windows -v
flutter build macos
```

## 启用桌面应用开关

```dart
flutter config --enable-linux-desktop // to enable Linux.
flutter config --enable-macos-desktop // to enable macOS.
flutter config --enable-windows-desktop // to enable Windows.
```

