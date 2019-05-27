require 'json'
package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name                = "RSSignatureCapture"
  s.version             = package["version"]
  s.description         = package["description"]
  s.summary             = <<-DESC
                            React Native library for capturing signature
                            User signs the app and presses the save button to return a base64 encoded png and filePath.
                          DESC
  s.homepage            = package['homepage']
  s.license             = package['license']
  s.authors             = package['author']
  s.source              = { :git => "https://github.com/RepairShopr/react-native-signature-capture.git", :tag => "v#{s.version}" }
  s.platform            = :ios, "8.0"
  s.source_files        = "ios/**/*.{h,m}"
  s.dependency          'React'
end