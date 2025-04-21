
# Workout Pro – Minimalist Fitness Logger

Workout Pro is a clean and focused workout tracking app for users who prefer simplicity over feature bloat, social feeds, or ads. It enables fast, distraction-free logging with essential stats and summaries.

The app is built with **Flutter** and integrates **Firebase** for authentication and cloud-based storage. While designed cross-platform, testing and deployment were completed on Android (API 23–30). iOS support can be added in future iterations.

---

## 🚀 Features

- Secure login and logout (Firebase Auth)
- Exercise logging with custom input fields
- Weekly progress summaries
- Minimal Material Design UI
- Syncs locally and to Firestore

---

## 🛠️ Tech Stack

- **Flutter** 3.x
- **Dart**
- **Firebase Auth** + **Firestore**
- **Provider** for state management
- **Android SDK 33** (min 23)

---

## 📲 Installation (Dev Mode)

1. Clone this repo  
2. Run `flutter pub get`  
3. Open in VS Code or Android Studio  
4. Launch using Android emulator or real device

> 🔹 To sideload APK, see `/appendix/` or [Appendix C in dissertation]

---

## ⚙️ Firebase Setup

1. Add your `google-services.json` to `android/app/`
2. Enable Firebase Auth and Firestore in Firebase Console
3. Set basic read/write rules for test mode

---

## 📝 Dev Notes

- Built using stateless/stateful widgets  
- Workout data tied to userID and stored via Firestore  
- Timestamp filtering for weekly summaries  
- Partial offline mode with sync fallback

---

## 📚 Author

Farhan – MSc Thesis Project (2025)  
University of Strathclyde, Department of Computer & Information Sciences
