# @rbxts/rofirestore

A Roblox TypeScript library for interacting with Google Firestore directly from Roblox games.

> **Warning:** This library is a **lazy way** to use Firestore from Roblox. It is **not recommended** to use this in production games or for sensitive data. You should host your own middleman server to securely handle Firestore requests, rather than piggybacking off Roblox servers. Using this library exposes your API keys and credentials to Roblox, which is a significant security risk.

## Features
- Authenticate with Google Firebase using email/password
- Read and write Firestore documents and collections
- Convert Firestore data to Roblox-friendly formats
- Utility for handling Firestore field types (strings, numbers, booleans, arrays, maps, timestamps, etc.)

## Installation

```sh
npm install @rbxts/rofirestore
```

## Usage

```typescript
import firestore from "@rbxts/rofirestore";

const app = firestore({
	apikey: "YOUR_FIREBASE_API_KEY",
	email: "YOUR_FIREBASE_EMAIL",
	password: "YOUR_FIREBASE_PASSWORD",
	projectId: "YOUR_FIREBASE_PROJECT_ID"
});

const users = app.collection("users");
const userDoc = users.getDocument("userId");
print(userDoc);
```

## Security Notice

- **Never** commit your Firebase credentials to public repositories.
- This library authenticates directly from Roblox, which is inherently insecure.
- For production, use a secure backend/middleman server to interact with Firestore and only expose safe endpoints to Roblox.

## License

MIT

## Credits

https://devforum.roblox.com/t/rofirestore-a-new-way-of-storage/3412592 - Upstream module by maxplayz2746