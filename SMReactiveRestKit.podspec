Pod::Spec.new do |s|
  s.name             = "SMReactiveRestKit"
  s.version          = "0.1.0"
  s.summary          = "ReactiveCocoa implementation for RestKit"
  s.description      = <<-DESC
  ReactiveCocoa implementation for RestKit.
                       Description coming soon
                       DESC
  s.homepage         = "http://www.stefanomondino.com"
  s.license          = 'MIT'
  s.author           = { "Stefano Mondino" => "stefano.mondino.dev@gmail.com" }
  s.source           = { :git => "https://github.com/stefanomondino/SMReactiveRestKit.git", :tag => s.version.to_s }
  s.social_media_url = 'http://www.stefanomondino.com'

  s.platform     = :ios, '5.0'
  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'
  s.requires_arc = true
  s.source_files = 'Classes'
  s.public_header_files = 'Classes/*.h'
  s.dependency 'ReactiveCocoa'
  s.dependency 'libextobjc/EXTScope'
  s.dependency 'RestKit'
end
