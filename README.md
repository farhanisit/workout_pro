# Workout Pro
A Minimalist Mobile App for Gym Workout Logging & Progress Review

Workout Pro is a focused fitness app designed to help users log and review their workouts without the clutter of traditional health apps. Built using Flutter and powered by Firebase, it delivers a seamless and distraction-free gym tracking experience.

## Features

- Secure user authentication (Firebase)
- Quick and intuitive workout logging
- Weekly progress summaries
- Clean, minimalist UI optimized for focus
- Real-time data storage with Firebase Firestore
- User goal setup and profile management

## Tech Stack

- Frontend: Flutter (Dart)
- Backend: Firebase (Auth + Firestore)
- State Management: Provider
- Version Control: GitHub
- Design Tools: Figma
- IDE: VS Code / Android Studio

## Folder Structure Overview

Here's a quick overview of the main folders and what they contain:

lib/
├── auth/                # Authentication logic (login, signup, auth services)
│   └── Auth.dart
├── core_screens/screens_/
│   ├── home_screen.dart
│   ├── progress_screen.dart
│   ├── profile_screen.dart
│   └── dashboard_screen.dart
├── model/               # Data models (User, Exercise)
│   ├── exercise.dart
│   └── user_model.dart
├── services/            # Backend service logic (Firebase auth, workout service)
│   └── auth_service.dart
├── features/            # UI-specific submodules (e.g., display_exercise)
└── debug/               # Debug tools, Firestore seeders

## Installation Guide

### Prerequisites
- Flutter SDK installed
- Android device or emulator
- Firebase CLI (optional for web builds)

### Steps

1. Clone the repository
   git clone https://github.com/yourusername/workout_pro.git
   cd workout_pro

2. Install dependencies
   flutter pub get

3. Run the app
   flutter run

4. To build release APK
   flutter build apk --release

## Deployment Notes

- APK testing done on Samsung Z Flip 5 (Android 14)
- APK sideloading required permissions from unknown sources
- Future deployment recommended via Google Play Console
- iOS support validated via Xcode Simulator

## Future Enhancements

- Add offline logging support with local sync
- Visual analytics with charts
- iOS App Store deployment
- Accessibility improvements (screen reader, high-contrast mode)
- Workout template reuse and autocomplete

## Credits

- Farhan Ahmed – Developer & Researcher
- University of Strathclyde – MSc Software Development 2025
- Tools used: Flutter, Firebase, VS Code, Figma

## License

MIT License (or whichever license applies to your submission/project policy)

## Developer Notes

This project includes some files used during development and testing:
- `firestore_seeder.dart`: Used to seed dummy data during testing
- `demo_progress_*.dart`: Experimental or demo files not part of final implementation

These are not essential to the core functionality but were useful during development.

## Test Files

The `/test` folder includes automated test cases developed for authentication and UI components:
- `auth_test.dart`: Unit tests for login/signup logic
- `widget_test.dart`: Default test created during project setup (may not be used)

These files demonstrate test-driven development practices used during implementation.
