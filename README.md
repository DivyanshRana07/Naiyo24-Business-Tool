# Naiyo24 Business Tool

A Flutter Web application replicating the **Refrens authentication flow** — built with Material 3, Riverpod, and GoRouter.

---

## 🚀 Quick Start

### Prerequisites

Make sure you have Flutter installed and configured for web:

```bash
flutter channel stable
flutter upgrade
flutter config --enable-web
```

### Install dependencies

```bash
cd Naiyo24-Business-Tool
flutter pub get
```

### Run on Chrome

```bash
flutter run -d chrome
```

### Build for production

```bash
flutter build web --release
```

---

## 🔐 Demo Credentials

| Field    | Value               |
|----------|---------------------|
| Email    | naiyodemo@gmail.com |
| Password | demo123             |

---

## 📁 Folder Structure

```
lib/
├── main.dart                     # App entry point
├── app_shell.dart                # Root widget (router + theme)
│
├── core/
│   ├── routes/
│   │   ├── app_router.dart       # GoRouter configuration
│   │   └── app_router.g.dart     # Generated Riverpod code
│   └── theme/
│       └── app_theme.dart        # Material 3 theme + design tokens
│
├── models/
│   └── auth_state.dart           # Immutable AuthState
│
├── notifiers/
│   ├── auth_notifier.dart        # AuthNotifier (login/logout)
│   └── auth_notifier.g.dart      # Generated
│
├── providers/
│   ├── auth_provider.dart        # authProvider alias
│   └── auth_provider.g.dart      # Generated
│
├── screens/
│   ├── splash/
│   │   └── splash_screen.dart    # 2-second animated splash
│   ├── login/
│   │   └── login_screen.dart     # Refrens-style login
│   ├── signup/
│   │   └── signup_screen.dart    # Registration form
│   └── dashboard/
│       └── dashboard_screen.dart # Post-login dashboard
│
└── widgets/                      # Reusable components
    ├── logo_widget.dart
    ├── auth_header.dart
    ├── custom_button.dart
    ├── custom_text_field.dart
    ├── password_field.dart
    ├── google_button.dart
    ├── divider_with_text.dart
    └── floating_chat_button.dart
```

---

## 🏗 Architecture

```
UI (Screens/Widgets)
       ↓
   Provider (authProvider)
       ↓
   Notifier (AuthNotifier)
       ↓
   State Update (AuthState)
```

---

## 📱 Screens

| Route        | Screen      | Description                          |
|--------------|-------------|--------------------------------------|
| `/`          | Splash      | Animated logo + 2s auto-navigate     |
| `/login`     | Login       | Email/password form + Google button  |
| `/signup`    | Signup      | Registration with country dropdowns  |
| `/dashboard` | Dashboard   | Stats, quick actions, activity feed  |

---

## 🎨 Design System

| Token        | Value      |
|--------------|------------|
| Primary      | `#6C3CE1`  |
| Primary Dark | `#5429C8`  |
| Background   | `#FAFAFC`  |
| Surface      | `#FFFFFF`  |
| Error        | `#EF4444`  |
| Border Radius| 12dp (card)|
| Font         | Inter (Google Fonts) |

---

## ⚙️ Tech Stack

- **Flutter 3.x** (Web)
- **Material 3** design system
- **Riverpod 2** (Riverpod annotation)
- **GoRouter 14** (declarative routing)
- **Google Fonts** (Inter typeface)

---

## 📝 Notes

- The `.g.dart` files are pre-generated and committed to avoid needing `build_runner` on first run.
- If you modify `@riverpod` annotations, regenerate with:
  ```bash
  dart run build_runner build --delete-conflicting-outputs
  ```
- No backend, Firebase, or API is used. All state is local boolean-only.
