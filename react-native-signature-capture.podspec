require 'json'
version = JSON.parse(File.read('package.json'))["version"]

Pod::Spec.new do |s|

  s.name           = package['name']
  s.version        = package['version']
  s.summary        = package['description']
  s.description    = package['description']
  s.license        = package['license']
  s.author         = package['author']
  s.homepage       = package['homepage']
  s.platform       = :ios, "9.0"
  s.source         = { :git => "https://github.com/RepairShopr/react-native-signature-capture", :tag => s.version }
  s.source_files   = 'ios/*.{h,m}'
  s.dependency 'React'

end
