Pod::Spec.new do |s|
  s.name             = "SPXControls"
  s.version          = "1.0.1"
  s.summary          = "Provides custom controls used throughout my applications."
  s.homepage         = "https://github.com/shaps80/SPXControls"
#s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Shaps Mohsenin" => "shapsuk@me.com" }
  s.source           = { :git => "https://github.com/shaps80/SPXControls.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/shaps'
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source_files = 'Pod/Classes/**/*'
  s.dependency 'SPXDefines'
  s.dependency 'SPXDataValidators'
end
