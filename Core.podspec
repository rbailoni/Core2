#
# Be sure to run `pod lib lint Core2.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Core2'
  s.version          = '0.1.1'
  s.summary          = 'Módulo responsável por realizar as chamadas de Network e Protocols.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Módulo responsável por fazer as chamadas de Network e Protocols
que serão usados como base para os projetos desenvolvidos.
                       DESC

  s.homepage         = 'https://github.com/rbailoni/Core2'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ricardo Bailoni' => 'rbailoni@rbailoni.com.br' }
  s.source           = { :git => 'https://github.com/rbailoni/Core2.git', :tag => s.version.to_s }
  s.social_media_url = 'https://linkedin.com/in/rbailoni'

  s.ios.deployment_target = '15.0'
  s.swift_version = '5.9'
  s.source_files = 'Sources/Network/**/*.swift', 'Sources/Protocols/**/*.swift'
  
  s.subspec 'Network' do |sp|
    sp.source_files = 'Sources/Network/**/*.swift'
    sp.ios.deployment_target = '15.0'
  end
  
  s.subspec 'Protocols' do |sp|
    sp.source_files = 'Sources/Protocols/**/*.swift'
    sp.ios.deployment_target = '15.0'
  end
  
  # s.resource_bundles = {
  #   'Core2' => ['Core2/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3' 
end
