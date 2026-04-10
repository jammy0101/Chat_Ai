# Chat AI Pro (Flutter + Provider + Firebase + Gemini)

A production-style chat application starter built with clean layering, Provider state management, Firebase persistence, and Gemini model integration.

## Architecture

```text
lib/
 ┣ core/constants
 ┣ models
 ┣ services
 ┣ providers
 ┣ views
 ┣ widgets
 ┗ main.dart
```

## Why this is "pro" level

- **Dependency injection** via `Provider` and `ChangeNotifierProxyProvider2`.
- **Separation of concerns**:
  - `GeminiService` handles AI API calls.
  - `ChatRepository` handles Firestore writes.
  - `ChatProvider` orchestrates use-cases and state.
- **Conversation context** support for better AI responses.
- **Non-hardcoded secret management** using `--dart-define`.
- **Extensible architecture** to add auth, history, and RAG features.

## Setup

### 1) Install dependencies

```bash
flutter pub get
```

### 2) Firebase setup

1. Create Firebase project.
2. Add Android/iOS apps.
3. Place `google-services.json` in `android/app/`.
4. Enable:
   - Authentication (Email/Password)
   - Firestore Database

### 3) Run with Gemini key

```bash
flutter run --dart-define=GEMINI_API_KEY=your_gemini_api_key
```

## Firestore model

Each chat write creates one document in `chats`:

```json
{
  "userId": "demo-user",
  "createdAt": "serverTimestamp",
  "messages": [
    { "id": "...", "text": "user prompt", "isUser": true, "createdAt": "...", "status": "sent" },
    { "id": "...", "text": "assistant response", "isUser": false, "createdAt": "...", "status": "sent" }
  ]
}
```

## Next upgrades

- Real auth flow (`FirebaseAuth`) and per-user chat streams.
- Streaming response UX and token-by-token rendering.
- Local caching (Hive/Isar) + offline retries.
- Prompt templates + safety layer + telemetry.
- File upload and RAG (vector db + embeddings).
