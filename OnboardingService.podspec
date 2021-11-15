Pod::Spec.new do |spec|

  spec.name         = "OnboardingService"
  spec.version      = "1.0.23"
  spec.summary      = "A short description of OnboardingService."
  spec.homepage     = "http://EXAMPLE/OnboardingService"
  spec.license      = "MIT"
  spec.author       = { "Franklin Gaspar" => "franklin.gaspar@hotmail.com" }

  spec.swift_version    = "5.0"
  spec.platform         = :ios, "11.0"

  spec.source           = { :git => "https://github.com/franklingaspar/OnboardingService.git", :tag => "#{spec.version}" }

  spec.source_files     = "OnboardingService/**/*.{h,m,swift,xib,storyboard}"
 
  spec.dependency "Alamofire", "5.4.4"
  spec.dependency "OnboardingModelsTeste", "~> 1.0.0"
  
end
