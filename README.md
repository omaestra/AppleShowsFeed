# ``AppleShowsFeed``

A native iOS application showcasing top movies from the iTunes Store RSS feed, built with SwiftUI and modern iOS development practices.

## 🎯 Overview

Apple Shows Feed is a SwiftUI-based iOS application that displays trending movies from the iTunes Store, featuring a clean architecture with comprehensive testing and international support. This project demonstrates proficiency in iOS development, architectural patterns, and production-ready code practices.

### 🏗️ Architecture

Basic clean architecture featuring SOLID principles. Showcasing separation of concerns and dependency injection.
MVVM design pattern for SwiftUI, defining clear separation between views and business logic.

```
AppleShowsFeed/           # macOS framework to keep Business Logic isolated and testing fast.
├── Movie/
│   ├── Domain/           # Business logic & entities
│   │   ├── Movie.swift   # Core movie model
│   │   └── MovieLoader.swift # Business interface
│   └── API/              # External interfaces
│       ├── HTTPClient.swift # Network abstraction
│       ├── URLSessionHTTPClient.swift # URLSession network implementation
│       ├── RemoteMovieLoader.swift # Remote Data fetching
│       └── MoviesMapper.swift # JSON mapping
│
└── AppleShowsFeedApp/    # iOS Application project.
    ├── Domain/           # App-specific business rules
    ├── View/             # SwiftUI views
    ├── ViewModel/        # Presentation logic
    └── Router.swift      # Navigation management
```

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
- [ ] Implement top TV series.

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
Swift Version: 5.0
iOS Deployment Target: 15.0+

