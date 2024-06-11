[![License](https://img.shields.io/cocoapods/l/SDWebImageSwiftUI.svg)](https://cocoapods.org/pods/SDWebImageSwiftUI)
[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)

## What's for

URLImage is a SwiftUI image loading framework.

It brings features like async image loading, memory/disk caching.

The framework provide the Image View struct with different states, like using progress, placeholder, error placeholder.

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

+ iOS Demo
+ 

