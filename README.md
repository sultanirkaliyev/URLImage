[![License](https://img.shields.io/cocoapods/l/SDWebImageSwiftUI.svg)](https://cocoapods.org/pods/SDWebImageSwiftUI)
[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)

## What's for

URLImage is a SwiftUI image loading framework.

It brings features like async image loading, memory/disk caching.

The framework provide the Image View struct with different states, like using progress, placeholder, error placeholder.

## Demo Project

[WallpaperApp](https://github.com/sultanirkaliyev/WallpaperApp) is a demo project designed to demonstrate the functionality of the URLImage framework.

## Features

- [x] Asynchronous image loading with support for progressive loading
- [x] Reusable download, never request single URL twice
- [x] Ability to create different variations of View
- [x] Progress indication during image loading
- [x] URLRequest with error handling when loading
- [x] Image caching to reduce network load and improve performance
- [x] Ability to start, stop, pause and resume image downloading

## Contribution

All issue reports, feature requests, contributions, and GitHub stars are welcomed. Hope for active feedback and promotion if you find this framework useful.

## Requirements

+ Xcode 14+
+ iOS 15+

## Installation

#### Swift Package Manager

URLImage is available through [Swift Package Manager](https://swift.org/package-manager/).
```swift
let package = Package(
    dependencies: [
        .package(url: "https://github.com/sultanirkaliyev/URLImage.git", from: "1.0.0")
    ],
)
```

#### CocoaPods

URLImage is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'URLImage', :git => 'https://github.com/sultanirkaliyev/URLImage.git', :branch=> 'master'
```

## Getting Started

```swift
import SwiftUI
import URLImage
```

## Usage

### Using `URLImage` to load network image

- [x] Supports placeholder for image loading
- [x] Supports progressive image loading
- [x] Displays a placeholder if image not loading
- [x] Provides an error placeholder if image loading fails

### Base usage of URLImage
```swift
var body: some View {
    URLImage(url: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRBmGCc9l-GwZbl6wrQp5MmvYifaOM5FlLXw&s")!) { image in
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
    }
    .frame(width: 200, height: 200)
}
```

### Usage of URLImage with progress view
```swift
var body: some View {
    URLImage(url: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRBmGCc9l-GwZbl6wrQp5MmvYifaOM5FlLXw&s")!) { image in
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
    } progressView: { progress in
        ProgressView()
        // or
        // ProgressView(value: progress)
    }
    .frame(width: 200, height: 200)
}
```

### Usage of URLImage with placeholder, if image not loaded
```swift
var body: some View {
    URLImage(url: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRBmGCc9l-GwZbl6wrQp5MmvYifaOM5FlLXw&s")!) { image in
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
    } placeholderView: {
        Image("image_placeholder")
            .resizable()
            .scaledToFill()
    }
    .frame(width: 200, height: 200)
}
```

### Usage of URLImage with error placeholder, if image not loaded
```swift
var body: some View {
    URLImage(url: URL(string: "https://encryptssed-tbn0.gstatic.com/images?q=tbn:ANd9GcRRBmGCc9l-GwZbl6wrQp5MmvYifaOM5FlLXw&s")!) { image in
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
    } errorPlaceholderView: {
        Image("image_failure")
            .resizable()
            .scaledToFill()
    }
    .frame(width: 200, height: 200)
}
```

## Screenshot

**iOS Demo**

![Simulator Screen Recording - iPhone 14 Pro - 2024-06-12 at 02 56 39](https://github.com/sultanirkaliyev/URLImage/assets/46129371/f7ca8543-c1b9-43b8-baf2-e0ebcbd4149a) ![Simulator Screen Recording - iPhone 14 Pro - 2024-06-12 at 02 57 53](https://github.com/sultanirkaliyev/URLImage/assets/46129371/3efbe95f-97cb-481b-90e1-2ec8d5065643)
![Simulator Screen Recording - iPhone 14 Pro - 2024-06-12 at 02 58 15](https://github.com/sultanirkaliyev/URLImage/assets/46129371/75b9c59a-16df-4b20-8a04-051c87a08cc6) ![Simulator Screen Recording - iPhone 14 Pro - 2024-06-12 at 02 59 01](https://github.com/sultanirkaliyev/URLImage/assets/46129371/43dfc773-636e-49b8-ad88-462a69b0a627) ![Simulator Screen Recording - iPhone 14 Pro - 2024-06-12 at 03 02 43](https://github.com/sultanirkaliyev/URLImage/assets/46129371/85eba846-f44b-4e93-85de-75ad84c0b0fc)


## License

URLImage is available under the MIT license. See the LICENSE file for more info.
