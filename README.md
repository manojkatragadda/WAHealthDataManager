# WAHealthDataManager

[![CI Status](https://img.shields.io/travis/Manoj Katragadda/WAHealthDataManager.svg?style=flat)](https://travis-ci.org/Manoj Katragadda/WAHealthDataManager)
[![Version](https://img.shields.io/cocoapods/v/WAHealthDataManager.svg?style=flat)](https://cocoapods.org/pods/WAHealthDataManager)
[![License](https://img.shields.io/cocoapods/l/WAHealthDataManager.svg?style=flat)](https://cocoapods.org/pods/WAHealthDataManager)
[![Platform](https://img.shields.io/cocoapods/p/WAHealthDataManager.svg?style=flat)](https://cocoapods.org/pods/WAHealthDataManager)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
Add HealthKit as part of your project's Capabilities under app target - Signing and Capabilities Tab. Ensure that you've enabled Clinical Records checkbox.
Update plist to include the following details:
<key>NSHealthClinicalHealthRecordsShareUsageDescription</key>
<string>Health Kit Read in needed to fetch the details. Enter as much details as you can here.</string>
<key>NSHealthShareUsageDescription</key>
<string>Health Kit share details are also needed for this project setup</string>

## Installation

WAHealthDataManager is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'WAHealthDataManager'
```

## Author

Manoj Katragadda, manoj@webileapps.com

## License

WAHealthDataManager is available under the MIT license. See the LICENSE file for more info.
