# Uncomment the next line to define a global platform for your project
# platform :ios, '12.0'

target 'NantesPVB' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for NantesPVB

  # Keyboard management in scrolls - ! last version 11/17 !
  pod 'TPKeyboardAvoiding', '= 1.3.2', :inhibit_warnings => true

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      if target.name == 'TPKeyboardAvoiding'
        target.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '4.1'
        end
      end
    end
  end

  
end
