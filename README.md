# BlackMeDo

**BlackMeDo** is a lightweight and customizable `/me` and `/do` roleplay command system for FiveM servers. It allows players to express actions and descriptions in a visible and immersive way, enhancing the RP experience.

## Features

- 🎭 Supports `/me` and `/do` commands
- 🧠 Displays messages above player heads
- 🔒 Anonymous display when wearing a mask
- 💬 Fully customizable texts and formatting
- 🔗 Server-side logging for moderation
- 📦 Optimized and easy to configure

## Installation

1. Download or clone the repository into your `resources` folder:

```bash
git clone https://github.com/yourusername/BlackMeDo.git
```

2. Ensure the folder is named `BlackMeDo`.

3. Add the resource to your `server.cfg`:

```cfg
ensure BlackMeDo
```

## Configuration

Open `config.lua` to customize the following options:

- Command names
- Display time
- Mask anonymity behavior
- Message colors
- Webhook logging (if integrated)

## File Structure

```
BlackMeDo/
├── client/
│   └── client.lua        # Handles client-side text display
├── server/
│   └── server.lua        # Handles command logic and webhook
├── config.lua            # Configuration file
├── fxmanifest.lua        # Resource manifest
└── LICENSE               # License information
```

## Dependencies

- [ox_lib](https://overextended.dev) (optional, if integrated for notifications)

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contribution

Feel free to fork and submit pull requests. Suggestions and improvements are always welcome!

---

✅ **Make roleplay more immersive with BlackMeDo!**
