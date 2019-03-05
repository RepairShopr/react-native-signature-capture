require "json"
	
	package = JSON.parse(File.read(File.join(__dir__, "package.json")))
	
	Pod::Spec.new do |s|
	  s.name         = "react-native-signature-capture"
	  s.version      = package["version"]
	  s.summary      = package["description"]
	  s.author       = package["author"]
	  s.homepage     = package["homepage"]
	  s.license      = package["license"]
    s.source       = { :git => "https://github.com/xoagop/react-native-signature-capture", :tag => "#{s.version}" }

	  s.platform                = :ios, "8.4"
    s.ios.deployment_target   = '8.0'
    
    s.preserve_paths  = 'LICENSE', 'package.json'
    s.source_files    = "ios/*.{h,m}"
    s.dependency "React"
	end