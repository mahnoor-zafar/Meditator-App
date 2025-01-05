

# Meditopia App 
Individual Project: Mah Noor Zafar 002

## Overview
Meditopia is a simple meditation app that helps users relax and track their mindfulness journey. It includes features like guided meditations, journaling, and mood tracking.


## Prerequisites
Before you start, make sure you have the following installed:

- **Flutter SDK** (latest version)
- **Android Studio** or **VS Code** (with Flutter and Dart plugins)
- **Xcode** (for iOS if you're building for iOS)
- **Firebase account** for authentication and database setup

## Steps to Set Up the Project

### 1. Clone the Repository
First, clone the project to your local machine:
```bash
git clone https://github.com/mahnoor-zafar/Meditator-App.git
cd Meditator-App
```

### 2. Install Dependencies
Once inside the project folder, run the following command to install all the necessary dependencies:
```bash
flutter pub get
```

### 3. Set Up Firebase
To connect the app with Firebase:
- **For Android**: Go to Firebase Console, create a new project, and download the `google-services.json` file. Place this file inside `android/app` in your project.
- **For iOS**: Go to Firebase Console, download the `GoogleService-Info.plist`, and add it to your `ios/Runner` directory.

### 4. Run the App
Now, you’re ready to run the app!

- **For Android**: Open the project in Android Studio or run it directly from the terminal using the command:
  ```bash
  flutter run
  ```

- **For iOS**: If you're using a Mac, you can run the app on an iOS device or simulator with:
  ```bash
  flutter run
  ```

### 5. Run Tests (Optional)
To make sure everything works, you can run tests:
```bash
flutter test
```

## Project Structure
Here’s an overview of the main files and folders in the project:

```
meditopia/
│
├── android/          # Android-specific setup
├── ios/              # iOS-specific setup
├── lib/              # Main app code
│   ├── main.dart     # Entry point of the app
│   ├── screens/      # Screens like Home, Meditation, Profile
│   └── services/     # Firebase services and data fetching
└── pubspec.yaml      # Dependencies for the project
```

## Key Dependencies Used
- **firebase_auth**: For user authentication (sign up, sign in).
- **shared_preferences**: To save user data locally, like journal entries.

  
## Troubleshooting

- **Firebase Setup Issue**: Make sure you have added the correct `google-services.json` for Android or `GoogleService-Info.plist` for iOS in the respective folders.
- **Build Errors**: If you face build errors, make sure you have Android Studio or Xcode updated to the latest version. Run `flutter doctor` to check for issues.



---
