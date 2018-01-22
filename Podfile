platform :ios, '9.0'
use_frameworks!

target 'UREClub' do

  pod ‘SWRevealViewController’
  
  pod 'INSPersistentContainer'

  pod 'Alamofire', '~> 4.5.1'

  pod 'SwiftSoup'
  
  pod 'SDWebImage', '~> 4.1.2'

end

post_install do |installer|
    myTargets = ['POEditorAPI'] # 'Alamofire'
    
    installer.pods_project.targets.each do |target|
        if myTargets.include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.2'
            end
        end
    end
end



