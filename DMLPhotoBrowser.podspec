#
# Be sure to run `pod lib lint DMLPhotoBrowser.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DMLPhotoBrowser'
  s.version          = '0.1.4'
  s.summary          = 'DMLPhotoBrowser.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
The image browser supports both local and network.
                       DESC

  s.homepage         = 'https://github.com/MrDML/DMLPhotoBrowser'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'MrDML' => 'dml1630@163.com' }
  s.source           = { :git => 'https://github.com/MrDML/DMLPhotoBrowser.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'DMLPhotoBrowser/Classes/**/*'
  
  # s.resource_bundles = {
  #   'DMLPhotoBrowser' => ['DMLPhotoBrowser/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
    s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
    s.dependency 'FLAnimatedImage', '~> 1.0.12'
    s.dependency 'SDWebImage', '~> 4.1.0'
end
