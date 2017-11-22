Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '9.0'
s.name = "VaultITMobileSSOFramework"
s.summary = "VITMobileSSOFramework is a library that can be used to easily integrate OpenID Connect based login and logout to your iOS application."
s.requires_arc = true

s.version = "0.4.9"

s.license = { :type => "Apache License 2.0", :file => "LICENSE" }
s.author = { "VaultIT" => "vaultit-support@nixu.com" }

s.homepage = "https://git.vaultit.org/nordiceid/mobilesso-ios-sdk"

s.source = { :git => "https://git.vaultit.org/nordiceid/mobilesso-ios-sdk.git", :tag => "#{s.version}" }

s.dependency 'AppAuth', '0.9.1'
s.dependency 'Alamofire', '4.5'
s.dependency 'ObjectMapper', '3.1.0'
s.dependency 'SwiftKeychainWrapper', '3.0.1'
s.dependency 'ReachabilitySwift', '3'

s.source_files = "MobileSSOFramework/MobileSSOFramework/**/*.swift"

# If any resources are added in the future, uncomment the line below.
# If no resources exist, the line will not validate.
# s.resources = "MobileSSOFramework/MobileSSOFramework/**/*.{png,jpeg,jpg,storyboard,xib}"

end
