platform :ios, '9.0'

workspace ‘MobileSSO’
project ‘MobileSSOFramework/MobileSSOFramework.xcodeproj'
project ‘MobileSSODemo/MobileSSODemo.xcodeproj'

use_frameworks!

# Common pods
# Note: when doing actual app development, these are best defined as dependencies in the .podspec file. Then only relevant modules
# will be visible at the app project level.

def common_pods
    pod 'AppAuth', '0.9.1'
    pod 'Alamofire', '4.5'
    pod 'ObjectMapper', '3.0.0'
    pod 'SwiftKeychainWrapper', '3.0.1'
    pod 'ReachabilitySwift', '3'
end

target 'MobileSSOFramework' do
    common_pods
    project 'MobileSSOFramework/MobileSSOFramework.xcodeproj'
    
    target 'MobileSSOFrameworkTests' do
        
    end
end

target 'MobileSSODemo' do
    common_pods
    project 'MobileSSODemo/MobileSSODemo.xcodeproj'
    
    target 'MobileSSODemoTests' do
        
    end
    
    target 'MobileSSODemoUITests' do
        
    end
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.0'
        end
    end
end
