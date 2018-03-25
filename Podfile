platform :ios, '9.0'
use_frameworks!

target 'UREClub' do

  pod 'SWRevealViewController'

  pod 'INSPersistentContainer'

  pod 'Alamofire', '~> 4.5.1'

  pod 'SwiftSoup'

  pod 'SDWebImage', '~> 4.1.2'

  pod 'SkyFloatingLabelTextField', '~> 3.0'

  pod 'KeychainSwift', '~> 10.0'

  pod 'ALCameraViewController'

  pod 'OneSignal', '>= 2.6.2', '< 3.0'

end

target 'OneSignalNotificationServiceExtension' do
  pod 'OneSignal', '>= 2.6.2', '< 3.0'
end

post_install do |installer|
    plist_buddy = "/usr/libexec/PlistBuddy"
    
    installer.pods_project.targets.each do |target|
        puts target.name
        
        name = "#{target.platform_name}"
        
        if name == 'ios'
            puts "Updating #{target.platform_name}"
            
            plist = "Pods/Target Support Files/#{target}/Info.plist"
            
            `#{plist_buddy} -c "Add UIRequiredDeviceCapabilities array" "#{plist}"`
            `#{plist_buddy} -c "Add UIRequiredDeviceCapabilities:0 string arm64" "#{plist}"`
            else
            puts "Didn't match #{target.platform_name}"
        end
    end
end
