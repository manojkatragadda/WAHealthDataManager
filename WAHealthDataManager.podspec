#
# Be sure to run `pod lib lint WAHealthDataManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WAHealthDataManager'
  s.version          = '1.0.1'
  s.summary          = 'WAHealthDataManager will help user fetch the HealthKit data from iPhone'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
WAHealthDataManager will help user fetch HealthKit Data from iPhone for HeartRate, Step Count, Active Energy burned and Distance travelled walking & running.
                       DESC

  s.homepage         = 'https://github.com/manojkatragadda/WAHealthDataManager'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Manoj Katragadda' => 'manoj@webileapps.com' }
  s.source           = { :git => 'https://github.com/manojkatragadda/WAHealthDataManager.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'WAHealthDataManager/Classes/**/*'
  
  # s.resource_bundles = {
  #   'WAHealthDataManager' => ['WAHealthDataManager/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
