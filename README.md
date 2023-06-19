# EventLimiter

Simple classes for efficiently handling events.

<br>

## Contents
- [EventLimiter](#eventlimiter)
  - [Contents](#contents)
  - [Requirements](#requirements)
  - [Overview](#overview)
  - [Installation](#installation)
    - [Swift Package Manager](#swift-package-manager)
    - [Manually](#manually)
  - [Usage](#usage)
    - [QuickStart](#quickstart)

## Requirements
- iOS 13.0+
- tvOS 13.0+
- macOS 10.15+
- watchOS 6.0+
- Swift 5.0+

## Overview
Simple classes for efficiently handling events.
You can use the Debouncer and Throttler to handle events.

## Installation

### Swift Package Manager
[Swift Package Manager](https://www.swift.org/package-manager/) is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

To integrate `EventLimiter` into your Xcode project using Swift Package Manager, add it to the dependencies value of your Package.swift:

```swift
dependencies: [
    .package(url: "https://github.com/baekteun/EventLimiter.git", .upToNextMajor(from: "1.0.0"))
]
```

### Manually
If you prefer not to use either of the aforementioned dependency managers, you can integrate CombineFlow into your project manually.

<br>

## Usage

### QuickStart
```swift
let debouncer = Debouncer(for: 0.3)
debouncer {
    self.search(keyword: keyword)
}
debouncer.cancel()
```

```swift
let throttler = Throttler(for: 1, latest: false)
throttler {
    self.reachedBottom()
}
throttler.cancel()
```