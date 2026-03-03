# APK Build Status

## Current blocker on host
This machine currently cannot build APK locally because required toolchain is missing:
- Flutter SDK (`flutter` not found)
- Java/JDK (`java` not found)

## What was implemented now
1. Added Android emulator-safe API base URL logic in:
   - `frontend/lib/services/api_client.dart`
2. Added GitHub Actions workflow to build APK automatically:
   - `.github/workflows/build-android-apk.yml`

## How to get APK now (no local setup needed)
1. Push this branch to GitHub.
2. Open repository **Actions** tab.
3. Run workflow: **Build Android APK** (or trigger by push).
4. After job success, download artifact:
   - `aquatrack-android-apk`
   - contains `app-release.apk`

## Optional local build prerequisites
If you also want local APK builds on this host:
- Install Flutter SDK
- Install Java 17+
- Install Android SDK / platform tools
Then run:
```bash
cd frontend
flutter pub get
flutter build apk --release
```
