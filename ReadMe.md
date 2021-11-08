# SlidingSelector

[![GitHub license](https://img.shields.io/github/license/galarius/GSSlidingSelector.svg)](https://github.com/galarius/GSSlidingSelector/blob/master/LICENSE)
![platform](https://img.shields.io/badge/platform-ios-lightgrey.svg)
![language](https://img.shields.io/badge/language-swift-orange.svg)

`SlidingSelector` is a controller for selecting an element from a small array with swipe gestures.

![](assets/screen.png)

*Inspired by [Figure](https://itunes.apple.com/us/app/figure-make-music-beats/id511269223) app*

## Example

| Appetize Live Demo | Gif |
| --- |--- |
| [Tap to play on Appetize](https://appetize.io/app/5uv9qzk6n1z6qut4f82x5rht80?device=iphonexsmax&scale=75&orientation=portrait&osVersion=12.1&deviceColor=black) | [Gif Example](assets/example.gif) |

## Installation

### Existing iOS Project

1. Using Xcode 11 go to File > Swift Packages > Add Package Dependency
2. Paste the project URL: https://github.com/Galarius/SlidingSelector.git
3. Import `SlidingSelector`

### Swift Package Manager

```swift
// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "YourProject",
  platforms: [
       .iOS(.v9),
  ],
  dependencies: [
    .package(url: "https://github.com/Galarius/SlidingSelector.git")
  ],
  targets: [
    .target(name: "YourProject", dependencies: ["SlidingSelector"])
  ]
)
```

And then import wherever needed: `import SlidingSelector`

## Usage

The example project is located under `Example` folder.

## License

1. `SlidingSelector` is released under the MIT license. See [LICENSE](https://github.com/galarius/SlidingSelector/blob/master/LICENSE) for details.

2. Images of planets surfaces are provided on the terms of personal, non commercial use by `bytecodeminer` from [alphacoders.com](https://wall.alphacoders.com/big.php?i=725422).

3. Icons are provided on the terms of `Creative Commons (Attribution 3.0 Unported)` license from iconfinder.com: 
    * [App Icon](https://www.iconfinder.com/icons/2119346/scientific_solar_system_icon)
    * [Swap Left Image](https://www.iconfinder.com/icons/329395/finger_gesture_hand_left_one_swipe_icon)
    * [Swap Right Image](https://www.iconfinder.com/icons/329394/finger_gesture_hand_one_right_swipe_icon)
