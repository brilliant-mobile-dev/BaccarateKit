Pod::Spec.new do |spec|

  spec.name         = "BaccarateKit"
  spec.version      = "1.0.0"
  spec.summary      = "BaccarateKit is a powerful iOS library built using UIKit and Storyboards."
  spec.description  = "BaccarateKit is a powerful iOS library built using UIKit and Storyboards, designed to simplify common tasks in iOS app development."

  spec.homepage     = "https://github.com/brilliant-mobile-dev/BaccarateKit"
  spec.license      = "MIT"
  spec.author       = { "Rith" => "rith@lomatechnology.com" }
  spec.source       = { :git => "https://github.com/brilliant-mobile-dev/BaccarateKit.git", :tag => spec.version.to_s }
  spec.swift_versions = "5.0"
  spec.source_files = "Baccarate/**/*.{swift,m,h}"
  spec.resources    = "Baccarate/**/*.{xcassets,json,png,jpeg,plist,storyboard,xib,strings}"
  spec.requires_arc = true
  spec.static_framework = true
  spec.framework  = "Foundation"
  spec.cocoapods_version = '>= 1.15.2'
  spec.ios.deployment_target = '15.0'

  # Install dependency
  spec.dependency "Alamofire"
  spec.dependency 'MBProgressHUD'
  spec.dependency 'SocketRocket'
  spec.dependency 'SpreadsheetView'
  spec.dependency 'SDWebImage'
  spec.dependency 'IQKeyboardManagerSwift', '~> 6.1.1'
  spec.dependency 'DropDown'
  spec.dependency 'MarqueeLabel'
  spec.dependency 'lottie-ios'
  spec.dependency 'SideMenu'
  spec.dependency 'ZFPlayer', '~> 4.0'
  spec.dependency 'ZFPlayer/ControlView', '~> 4.0'
  spec.dependency 'ZFPlayer/AVPlayer', '~> 4.0'
  spec.dependency 'ZFPlayer/ijkplayer', '~> 4.0'

end
