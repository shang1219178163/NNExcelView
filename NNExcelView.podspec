
Pod::Spec.new do |s|
  s.name             = 'NNExcelView'
  s.version          = '0.1.0'
  s.summary          = 'A short description of NNExcelView.'
  s.description      = 'TODO: Add long description of the pod here.'

  s.homepage         = 'https://github.com/shang1219178163/NNExcelView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'shang1219178163' => 'shang1219178163@gmail.com' }
  s.source           = { :git => 'https://github.com/shang1219178163/NNExcelView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.swift_version = "5.0"
  s.requires_arc = true

  s.frameworks = 'UIKit', 'CoreFoundation', 'CoreText', 'CoreGraphics', 'CoreImage',
    'CoreLocation','CoreTelephony', 'GLKit','QuartzCore', 'WebKit'

  s.source_files = 'NNExcelView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'NNExcelView' => ['NNExcelView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
