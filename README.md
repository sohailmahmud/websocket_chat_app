# Flutter WebSocket Chat App

A real-time chat application built with Flutter using WebSocket connections, BLoC pattern, and Clean Architecture principles.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white)
![WebSocket](https://img.shields.io/badge/WebSocket-010101?style=flat&logo=socket.io&logoColor=white)
![BLoC](https://img.shields.io/badge/BLoC-02569B?style=flat&logo=flutter&logoColor=white)

## 🚀 Features

- **Real-time Communication**: Connect to any WebSocket server and exchange messages instantly
- **Clean Architecture**: Well-structured codebase following clean architecture principles
- **State Management**: Robust state management using BLoC pattern
- **Connection Management**: Easy connect/disconnect with visual connection status
- **Error Handling**: Comprehensive error handling and user feedback
- **Modern UI**: Material Design 3 with intuitive chat interface
- **Message History**: View all sent and received messages with timestamps
- **Flexible Configuration**: Connect to any WebSocket server URL

## 📱 Screenshots

| Connection Screen | Chat Interface | Connection Status |
|:---:|:---:|:---:|
| *Connect to WebSocket* | *Real-time messaging* | *Live status indicator* |

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── 🎯 core/                      # Core functionality
│   ├── error/                    # Error handling
│   ├── network/                  # Network layer
│   └── usecases/                 # Base use case classes
├── 💬 features/chat/             # Chat feature module
│   ├── 🏛️ domain/                # Business logic layer
│   │   ├── entities/             # Domain entities
│   │   ├── repositories/         # Repository interfaces
│   │   └── usecases/             # Business use cases
│   ├── 💾 data/                  # Data layer
│   │   ├── models/               # Data models
│   │   └── repositories/         # Repository implementations
│   └── 🎨 presentation/          # UI layer
│       ├── bloc/                 # BLoC state management
│       ├── pages/                # Screen widgets
│       └── widgets/              # Reusable UI components
├── 🔧 injection_container.dart   # Dependency injection
└── 🏠 main.dart                  # App entry point
```

### 📋 Architecture Layers

- **Domain Layer**: Contains business logic, entities, and repository interfaces
- **Data Layer**: Implements repositories and handles data sources
- **Presentation Layer**: Contains UI components and state management

## 🛠️ Built With

- **[Flutter](https://flutter.dev/)** - UI framework
- **[flutter_bloc](https://pub.dev/packages/flutter_bloc)** - State management
- **[web_socket_channel](https://pub.dev/packages/web_socket_channel)** - WebSocket communication
- **[get_it](https://pub.dev/packages/get_it)** - Dependency injection
- **[equatable](https://pub.dev/packages/equatable)** - Value equality
- **[dartz](https://pub.dev/packages/dartz)** - Functional programming

## 📦 Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/sohailmahmud/websocket_chat_app.git
   cd websocket_chat_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 🎮 Usage

### Quick Start

1. **Launch the app** - You'll see the connection interface
2. **Enter WebSocket URL** - Default is `wss://echo.websocket.org` (echo server for testing)
3. **Tap "Connect"** - Establish WebSocket connection
4. **Start chatting** - Send messages using the input field
5. **Monitor status** - Watch the connection indicator in the app bar

### Example WebSocket Servers

- **Echo Server**: `wss://echo.websocket.org` - Echoes back your messages
- **Demo Server**: `wss://ws.postman-echo.com/raw` - Postman's WebSocket echo
- **Custom Server**: Connect to your own WebSocket server

### Configuration

The app supports any WebSocket server that accepts text messages. Simply enter the WebSocket URL and connect.

## 🏛️ Project Structure

### Core Components

- **WebSocketClient**: Manages low-level WebSocket connections
- **ChatRepository**: Abstracts WebSocket operations and data flow
- **Use Cases**: Encapsulate business operations (Connect, Disconnect, SendMessage)
- **ChatBloc**: Handles state management and user interactions

### State Management

The app uses BLoC pattern with the following states:

- `ChatInitial` - Initial state
- `ChatConnecting` - Connecting to WebSocket
- `ChatConnected` - Successfully connected with message list
- `ChatDisconnected` - Disconnected from WebSocket
- `ChatError` - Error state with error message

### Events

- `ConnectToWebSocket` - Initiate connection
- `DisconnectFromWebSocket` - Close connection
- `SendChatMessage` - Send a message
- `MessageReceived` - Handle incoming message

## 🧪 Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# View coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Test Structure

- **Unit Tests**: Domain layer logic and use cases
- **Widget Tests**: UI components and interactions
- **Integration Tests**: End-to-end WebSocket functionality

## 🔧 Development

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Setting Up Development Environment

1. **Install Flutter**: Follow the [official Flutter installation guide](https://flutter.dev/docs/get-started/install)

2. **Clone and setup**:
   ```bash
   git clone <repository-url>
   cd flutter-websocket-chat
   flutter pub get
   ```

3. **Run in debug mode**:
   ```bash
   flutter run --debug
   ```

### Code Generation

If you modify the BLoC files, you may need to regenerate code:

```bash
flutter packages pub run build_runner build
```

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/amazing-feature`)
3. **Commit your changes** (`git commit -m 'Add some amazing feature'`)
4. **Push to the branch** (`git push origin feature/amazing-feature`)
5. **Open a Pull Request**

### Contribution Guidelines

- Follow the existing code style and architecture
- Add tests for new features
- Update documentation as needed
- Ensure all tests pass before submitting PR

## 📝 Dependencies

### Production Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.3      # State management
  equatable: ^2.0.5         # Value equality
  dartz: ^0.10.1            # Functional programming
  web_socket_channel: ^2.4.0 # WebSocket support
  get_it: ^7.6.4            # Dependency injection
  injectable: ^2.3.2        # DI annotations
```

### Development Dependencies

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  injectable_generator: ^2.4.1  # Code generation
  build_runner: ^2.4.7          # Build system
  flutter_lints: ^2.0.0         # Linting rules
```

## 🐛 Known Issues

- None at the moment. Please report any issues you encounter!

## 📋 Roadmap

- [ ] **Message Persistence** - Save chat history locally
- [ ] **Multiple Rooms** - Support for different chat rooms
- [ ] **File Sharing** - Send and receive files
- [ ] **User Authentication** - Login/logout functionality
- [ ] **Push Notifications** - Background message notifications
- [ ] **Message Encryption** - End-to-end encryption
- [ ] **Voice Messages** - Audio message support
- [ ] **Dark Mode** - Theme customization

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2024 Sohail Mahmud

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## 👤 Author

**Your Name**
- GitHub: [@sohailmahmud](https://github.com/sohailmahmud)
- LinkedIn: [LinkedIn](https://linkedin.com/in/sohailmahmud)
- Email: sohailmahmuud@gmail.com

## 🙏 Acknowledgments

- [Flutter Team](https://flutter.dev/) for the amazing framework
- [BLoC Library](https://bloclibrary.dev/) for excellent state management
- [WebSocket.org](https://websocket.org/) for WebSocket standards and testing tools
- The Flutter community for continuous support and contributions

---

⭐ **If you found this project helpful, please give it a star!** ⭐

---

## 📞 Support

If you have any questions or need help with the project:

1. **Check the Issues**: Look through existing [GitHub Issues](https://github.com/sohailmahmud/websocket_chat_app/issues)
2. **Create a New Issue**: If you can't find your answer, create a new issue
3. **Discussions**: Use [GitHub Discussions](https://github.com/sohailmahmud/websocket_chat_app/discussions) for general questions

---

*Made with ❤️ using Flutter*