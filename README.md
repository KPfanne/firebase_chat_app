# BetterChatter

A mobile chat application built with Flutter and Firebase. Users register their own account, add contacts by email address, and exchange messages that appear on both devices in real time.

This is the most complete of my Flutter projects — it covers the full path from authentication and user lookup to a live, persisted conversation between two accounts.

## Features

**Accounts**

- Registration with name, email and password
- Email format validation and enforced password rules (minimum length, uppercase, digits, special character)
- Login and logout; the auth state decides which screen is shown, so a returning user lands directly in their contact list
- Profile picture selectable from the device gallery, shown on the contact list, in the chat header and next to every message

**Contacts**

- Add other users by their email address — the app looks the address up among registered accounts
- Contact list with avatar and name, refreshed after each addition

**Chat**

- One-to-one conversations, updating live on both devices without a manual refresh
- Messages aligned left or right depending on the sender, each with a timestamp
- Messages that have not yet been confirmed by the server are marked as sending, so it is visible when a message is still in flight

## Screenshots

<!-- Screenshots hochladen und hier einbinden:
     1. Ordner "screenshots" im Repo anlegen
     2. PNGs per Drag & Drop auf GitHub hineinziehen
     3. Zeilen unten einkommentieren und Dateinamen anpassen -->

<!-- <img src="screenshots/login.png" width="250"> <img src="screenshots/contacts.png" width="250"> <img src="screenshots/chat.png" width="250"> -->

## How it works

**Auth state drives navigation.** A `StreamBuilder` on Firebase's `authStateChanges()` sits at the root of the widget tree. Logging in or out swaps the screen automatically — no manual navigation after a successful login, and no way to reach the chat without a session.

**Conversations are addressed by a derived ID.** Both participant IDs are sorted alphabetically and joined, so each pair of users always resolves to the same conversation document from either side. No lookup table and no extra bookkeeping is needed to find an existing chat.

**Messages stream instead of poll.** The chat screen subscribes to a Firestore snapshot stream ordered by timestamp; new messages arrive as the server pushes them. Timestamps are written with `FieldValue.serverTimestamp()` so ordering does not depend on the clock of the sending device.

**Services are injected, not constructed inline.** `UserService`, `UserAuthService` and `ChatService` are provided through `provider` at the root. Widgets read them from the tree, which keeps Firebase calls out of the UI layer.

### Data model

```
users/{uid}                        name, email, imageUrl
users/{uid}/contacts/{contactId}   uid
chats/{chatId}/messages/{msgId}    senderId, message, time_stamp
```

### Project structure

```
lib/
├── model/     AppUser
├── service/   UserAuthService (auth), UserService (profiles, contacts), ChatService (messages)
├── view/      Login, Register, Contacts, Chat, Settings
├── widget/    Avatar, ChatCard, message bar, chat header, gradient background
└── theme/     Central colour definitions
```

## Tech

Flutter · Dart · [Firebase Authentication](https://firebase.google.com/docs/auth) · [Cloud Firestore](https://firebase.google.com/docs/firestore) · [provider](https://pub.dev/packages/provider) · [image_picker](https://pub.dev/packages/image_picker) · [email_validator](https://pub.dev/packages/email_validator) · [flutter_pw_validator](https://pub.dev/packages/flutter_pw_validator)

## Getting started

This project is not tied to my Firebase instance — the generated config files are excluded from the repository, so you need to connect your own Firebase project.

**1. Clone and install dependencies**

```bash
git clone https://github.com/KPfanne/flutter-chat-app.git
cd flutter-chat-app
flutter pub get
```

**2. Create a Firebase project**

In the [Firebase Console](https://console.firebase.google.com/), create a project and enable:

- **Authentication** → Sign-in method → Email/Password
- **Cloud Firestore**

**3. Connect the app to your Firebase project**

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This generates `lib/firebase_options.dart` and the platform config files.

**4. Run**

```bash
flutter run
```

To try the chat end to end, register two accounts and add each other by email — a second device or emulator instance works well for this.

## Note on configuration

`firebase_options.dart`, `google-services.json` and `GoogleService-Info.plist` are intentionally not committed. They are specific to a Firebase project, so anyone running this app should generate their own with `flutterfire configure`.