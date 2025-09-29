# ``AppleShowsFeed``

A native iOS application displaying top movies from the iTunes Store RSS feed, built with SwiftUI and modern iOS development practices.

## 🎯 Overview

Apple Shows Feed is a SwiftUI-based iOS application that displays trending movies from the iTunes Store, featuring a clean architecture with comprehensive testing and international support. This project demonstrates proficiency in iOS development, architectural patterns, and production-ready code practices.

### 🏗️ Architecture

Basic clean architecture featuring SOLID principles. Ensuring the system is modular, testable and easy to extend.
MVVM design pattern for SwiftUI, defining clear separation between views and business logic.

![screenshot](architecture.png)

### Project structure and schemes

This project is organized into multiple Xcode schemes to separate concerns and optimize both development speed and future CI/CD reliability.

#### 1. AppleShowsFeed (macOS Framework):
- Encapsulates all business logic and core domain models so unit tests run fast and isolated from UI concerns.
    
#### 2. AppleShowsFeedApp (iOS Application):
- Provides the UI layer and composition for the iOS app.
    
#### 3. CI_iOS (Aggregated TestPlan):
- Runs all test targets from both `AppleShowsFeed` and `AppleShowsFeedApp`. Used in CI/CD pipelines to ensure the entire system (business + UI) is verified.
    
#### 4. MoviesAPIEndToEndTests (Testing target):
- Performs end-to-end integration tests against the real Apple RSS API. Runs manually or on demand — not on every CI/CD build to avoid hitting external services unnecessarily.

### Prerequisites

- Xcode 16.4+
- iOS 18.5+
- Swift 5.0+

### Installation

1. Clone the repository
2. Open `AppleShowsFeed.xcworkspace` in Xcode 
3. Build and run `AppleShowsFeedApp` scheme on iOS simulator.

## Future Enhancements

### Feature improvements
- [ ] Movie preview video player.
- [ ] Display links and navigation to iTunes store.
- [ ] Implement top TV Seasons.
- [ ] Implement top TV Series.

### Technical improvements
- [ ] Local cache integration: Local data persistence.
- [ ] Local image data integration: Local image data persistance.
- [ ] Localization
- [ ] Offline support.
- [ ] CI/CD pipeline.

### 🤝 Contributing
This project serves as a portfolio piece, but suggestions and improvements are welcome. Please feel free to open issues or submit pull requests.

### 📞 Contact

Created by Oswaldo Maestra
Last Updated: September 2025

