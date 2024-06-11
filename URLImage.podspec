Pod::Spec.new do |spec|

  spec.name         = "URLImage"
  spec.version      = "1.0.0"
  spec.summary      = "URLImage CocoaPods library written in Swift"

  spec.description  = "URLImage is a SwiftUI image loading framework."

  spec.homepage     = "https://github.com/sultanirkaliyev/URLImage"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "sultan.irkaliyev" => "sultan.irkaliyev@gmail.com" }

  spec.ios.deployment_target = "15.0"
  spec.platform     = :ios, "15.0"
  spec.swift_version = "4.2"

  spec.source        = { :git => "https://github.com/sultanirkaliyev/URLImage.git", :tag => "#{spec.version}" }
  spec.source_files  = "Sources/URLImage/**/*.swift"

end