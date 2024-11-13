# Prodcut_Management

## Getting Started

##Api Key

```shell
"GOOGLE_API_KEY": "AIzaSyBqfaZeCJ9FXy62Hid2OnMT9vUbs9IitOo"
```

### Setup Flutter Version Management (FVM)

```shell
dart pub global activate fvm

fvm list

fvm releases

fvm install 3.24.3

fvm use 3.24.3
```

### Running Build Runner for Code Generation

```shell
fvm flutter pub run build_runner build --delete-conflicting-outputs
or
flutter pub run build_runner build --delete-conflicting-output
```

### Run Project In Development

```shell
fvm flutter run --dart-define=FLAVOR=dev --dart-define-from-file=api_keys.dev.json
```

## Download APK File

You can download the release APK file from the following link:

[Download prodcut-management.apk](./product-management.apk)
