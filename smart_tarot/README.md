# Smart Tarot

Professional tarot app with verifiable randomness and AI interpretation.

## 🏗️ Architecture

- **Frontend**: Flutter with Riverpod state management
- **Backend**: Vercel serverless functions (Node.js)
- **Randomness**: Random.org signed API for verifiable entropy
- **AI**: DeepSeek-V3 for interpretations
- **Database**: Isar (local, encrypted)
- **Payments**: In-app purchases (Google Play + iOS)

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.1.0)
- Node.js (>=18.0.0) for Vercel backend
- Random.org API key
- DeepSeek API key

### Setup

1. **Backend Setup (Vercel)**:
   ```bash
   # Install dependencies
   npm install
   
   # Set environment variable in Vercel dashboard
   # RANDOM_ORG_KEY=your_random_org_api_key
   
   # Deploy to Vercel
   vercel --prod
   ```

2. **Flutter Setup**:
   ```bash
   # Install dependencies
   flutter pub get
   
   # Generate Isar files
   flutter packages pub run build_runner build
   
   # Run the app
   flutter run
   ```

### Configuration

1. **API Keys**: 
   - Add your DeepSeek API key in the app's AiService constructor
   - Set RANDOM_ORG_KEY in Vercel environment variables

2. **Cards**: 
   - Place your 78 tarot card images in `assets/cards/`
   - Follow the naming convention in `assets/cards/.gitkeep`
   - Update `assets/tarot_deck.json` with complete card data

3. **Animation**:
   - Add `loader.json` Lottie animation to `assets/lottie/`

## 📁 Project Structure

```
smart_tarot/
├── lib/
│   ├── core/
│   │   ├── models/         # Data models (TarotCard, Entities)
│   │   ├── services/       # AI, Random, Subscription services
│   │   ├── db/            # Isar database configuration
│   │   └── fsm/           # Reading phase state machine
│   ├── features/reading/
│   │   ├── views/         # Chat, History views
│   │   └── widgets/       # Card reveals, loaders, etc.
│   ├── l10n/              # Internationalization
│   └── theme/             # App theming
├── pages/api/             # Vercel backend endpoints
├── assets/
│   ├── cards/             # 78 tarot card images
│   └── lottie/           # Ritual loader animation
└── README.md
```

## 🔮 Reading Flow (5-10-3-3-1 Canon)

1. **General 5**: Current situation, obstacles, resources, opposition, trend
2. **Celtic Cross 10**: Complete Celtic Cross spread
3. **Auxiliary 3a**: Advantage, disadvantage, advice
4. **Auxiliary 3b**: Past, present, future
5. **Final 1**: Synthesis and final guidance

## 🌍 Supported Languages

- English (en)
- Spanish (es)
- Catalan (ca)

## 💎 Premium Features

- **Free**: 1 session per 7 days, limited history (3 sessions)
- **Premium Monthly**: Unlimited sessions, full history
- **Premium Annual**: Unlimited sessions, full history (discounted)

## 🔒 Security & Privacy

- All session data stored locally (Isar)
- No PII sent to backend
- Cryptographically signed randomness from Random.org
- Optional history clearing
- Disclaimer for guidance vs. prediction

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Generate golden test files
flutter test --update-goldens

# Run integration tests
flutter drive --target=test_driver/app.dart
```

## 🚀 Deployment

### Backend (Vercel)
1. Push to Git repository
2. Connect to Vercel
3. Set environment variables
4. Deploy automatically

### Mobile Apps
1. **Android**: `flutter build appbundle`
2. **iOS**: `flutter build ios` then archive in Xcode
3. Upload to respective stores

## 📄 License

Private project - All rights reserved.

## 🔧 Development Notes

- Use `flutter pub run build_runner build` after modifying Isar entities
- Cards must be added to both `assets/cards/` and `tarot_deck.json`
- Backend endpoint must be updated in RandomService constructor
- Test with mock services before deploying