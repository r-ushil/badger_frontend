# badger_frontend

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## How to Configure Build for Android
Make sure you're in the `android/` directory, and run `./gradlew signingReport`.

You should see something like:

```
> Task :app:signingReport
Variant: debug
Config: debug
Store: /Users/oli/.android/debug.keystore
Alias: AndroidDebugKey
MD5: XX:XX:XX:XX:XX:XX:XX:XX:XX
SHA1: XX:XX:XX:XX:XX:XX:XX:XX:XX
SHA-256: XX:XX:XX:XX:XX:XX:XX:XX:XX
Valid until: Friday, 8 November 2052
----------
Variant: release
Config: release
Store: null
Alias: null
----------
Variant: profile
Config: debug
Store: /Users/oli/.android/debug.keystore
Alias: AndroidDebugKey
MD5: XX:XX:XX:XX:XX:XX:XX:XX:XX
SHA1: XX:XX:XX:XX:XX:XX:XX:XX:XX
SHA-256: XX:XX:XX:XX:XX:XX:XX:XX:XX
Valid until: Friday, 8 November 2052
```

To enable login for your Android app, make sure to copy the `SHA1` fingerprint for the `Variant: profile` report, and add it to the Android app registered in Firebase console (Firebase Console > Project Settings > General > Your Apps).
