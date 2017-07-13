require 'json'
package = JSON.parse(File.read('package.json'))

Pod::Spec.new do |s|

s.name            = package["name"]
s.version         = package["version"]
s.summary         = package["description"]
s.license         = package["license"]
s.homepage        = package["homepage"]
s.author          = { package["author"] => "https://github.com/RepairShopr" }
s.platform        = :ios, "9.0"
s.source          = { :git => "https://github.com/RepairShopr/react-native-signature-capture.git" }
s.source_files    = "ios/*.{h,m}"
s.preserve_paths  = "**/*.js"
s.dependency 'React'

end
