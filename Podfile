
# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

# Ignore all warnings from all pods
inhibit_all_warnings!

install! 'cocoapods', :disable_input_output_paths => true

use_frameworks!(true)

# Enable the stricter search paths and module map generation for all pods
# use_modular_headers!

# Pods for MonkeyTest
target 'MonkeyTest' do
    pod 'SwiftMonkey'
end 


def wavesSDKPod
    # pod 'WavesSDKExtensions', :git => 'https://github.com/wavesplatform/WavesSDK-iOS'
    # pod 'WavesSDK', :git => 'https://github.com/wavesplatform/WavesSDK-iOS'
    # pod 'WavesSDKCrypto', :git => 'https://github.com/wavesplatform/WavesSDK-iOS'
end

# load './Vendors/WavesSDK/Podfile'
    
workspace 'WavesWallet-iOS.xcworkspace'
project 'Vendors/WavesSDK/WavesSDK.xcodeproj'
project 'WavesWallet-iOS.xcodeproj'


abstract_target 'Shows' do
        
    
    # pod 'AppsFlyerFramework'
    
    # Pods for WavesWallet-iOS
    target 'WavesWallet-iOS' do
        # inherit! :search_paths

        project 'WavesWallet-iOS.xcodeproj'    
        
        # UI
        pod 'RxCocoa'
        
        pod 'TTTAttributedLabel'    
        pod 'UITextView+Placeholder'

        pod 'SwipeView'
        pod 'MGSwipeTableCell'

        pod 'UPCarouselFlowLayout'
        pod 'InfiniteCollectionView', :git => 'https://github.com/wavesplatform/InfiniteCollectionView.git', :branch => 'swift5'
        pod 'RESideMenu', :git => 'https://github.com/wavesplatform/RESideMenu.git'

        pod 'Skeleton'
        pod 'Charts'
        pod 'Koloda'

        pod 'IQKeyboardManagerSwift'
        pod 'TPKeyboardAvoiding'
        
        # Assisstant
        pod 'RxSwift'
        pod 'RxSwiftExt'
        pod 'RxOptional'
        pod 'RxGesture'
        pod 'RxFeedback'    

        pod 'IdentityImg', :git => 'https://github.com/wavesplatform/identity-img-swift.git'
        pod 'QRCode'
        pod 'QRCodeReader.swift', '~> 9.0.1'    
        pod 'SwiftDate'
        pod 'Kingfisher'

        # Code Gen
        pod 'SwiftGen', '~> 5.3.0'

        # Debug
        # pod 'Reveal-SDK', :configurations => ['Debug']
        pod 'AppSpectorSDK', :configurations => ['dev-debug', 'dev-adhoc', 'test-dev', 'test-prod']
        pod 'SwiftMonkeyPaws', :configurations => ['dev-debug', 'dev-adhoc']
        pod 'Bugly'
            
#         pod 'Sentry', :git => 'https://github.com/getsentry/sentry-cocoa.git'
#        pod 'Sentry', :git => 'https://github.com/getsentry/sentry-cocoa.git', :tag => '4.3.1'
    end
end

target 'DataLayer' do
    inherit! :search_paths  
    project 'WavesWallet-iOS.xcodeproj'
    
    # External Service
    pod 'Firebase/Core'
    pod 'Firebase/Database'
    pod 'Firebase/Auth'
    # pod 'Firebase/InAsppMessagingDisplay'

    pod 'AppsFlyerFramework'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'Amplitude-iOS'            
    pod 'Sentry'

    # DB
    pod 'RealmSwift'
    pod 'RxRealm'

    # Assisstant
    pod 'RxSwift'
    pod 'RxSwiftExt'
    pod 'RxOptional'
    pod 'CSV.swift'

    pod 'CryptoSwift'
    pod 'DeviceKit'
    pod 'KeychainAccess'

    pod 'RxSwift'
    pod 'Moya'
    pod 'Moya/RxSwift'
end

target 'DomainLayer' do
    # inherit! :search_paths
    project 'WavesWallet-iOS.xcodeproj'

    # DB
    pod 'RealmSwift'
    pod 'RxRealm'

    # Assisstant
    pod 'RxSwift'
    pod 'RxSwiftExt'
    pod 'RxOptional'        
    pod 'RxReachability'

    pod 'KeychainAccess'        

    # Waves    
    wavesSDKPod
    # pod 'Extensions', :path => '.'
    
    pod 'CryptoSwift'
end

target 'Extensions' do
    # inherit! :search_paths
    project 'WavesWallet-iOS.xcodeproj'    

    # Assisstant
    pod 'RxSwift'
    pod 'RxSwiftExt'
    pod 'RxOptional'
    pod 'DeviceKit'

    # Waves
    wavesSDKPod
end

target 'DomainLayerTests' do
    project 'WavesWallet-iOS.xcodeproj'
    inherit! :search_paths         
end

target 'DataLayerTests' do
    project 'WavesWallet-iOS.xcodeproj'    
end

target 'WavesSDK' do    
    project 'Vendors/WavesSDK/WavesSDK.xcodeproj'
    pod 'RxSwift'
    pod 'Moya'
    pod 'Moya/RxSwift'
end

target 'WavesSDKExtensions' do    
    project 'Vendors/WavesSDK/WavesSDK.xcodeproj'
    pod 'RxSwift'
    pod 'Moya'
    pod 'Moya/RxSwift'
end

target 'WavesSDKCrypto' do    
    project 'Vendors/WavesSDK/WavesSDK.xcodeproj'
    pod 'RxSwift'
    pod 'Moya'
    pod 'Moya/RxSwift'
end

post_install do |installer|
    
    installer.pods_project.targets.each do |target|        
        target.build_configurations.each do |config|

            config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = "YES"
            config.build_settings['SWIFT_VERSION'] = '4.2'
            
        end        
    end 

    remove_static_framework_duplicate_linkage({
        'DataLayer' => ['Fabric', 'Crashlytics',
            'AppsFlyerFramework',
            'Amplitude-iOS',
            'Amplitude_iOS',
            'FirebaseCore',
            'FirebaseDatabase',
            'FirebaseAuth',
            'FIRAnalyticsConnector',
            'FirebaseAnalytics',
            'FirebaseCoreDiagnostics',
            'FirebaseInstanceID',
            'GoogleAppMeasurement',
            'GTMSessionFetcher',
            'GoogleUtilities']
    })
end

## This code take from https://github.com/CocoaPods/CocoaPods/issues/7155#issuecomment-461395735
PROJECT_ROOT_DIR = File.dirname(File.expand_path(__FILE__))
PODS_DIR = File.join(PROJECT_ROOT_DIR, 'Pods')
PODS_TARGET_SUPPORT_FILES_DIR = File.join(PODS_DIR, 'Target Support Files')

# CocoaPods provides the abstract_target mechanism for sharing dependencies between distinct targets.
# However, due to the complexity of our project and use of shared frameworks, we cannot simply bundle everything under
# a single abstract_target. Using a pod in a shared framework target and an app target will cause CocoaPods to generate
# a build configuration that links the pod's frameworks with both targets. This is not an issue with dynamic frameworks,
# as the linker is smart enough to avoid duplicate linkage at runtime. Yet for static frameworks the linkage happens at
# build time, thus when the shared framework target and app target are combined to form an executable, the static
# framework will reside within multiple distinct address spaces. The end result is duplicated symbols, and global
# variables that are confined to each target's address space, i.e not truly global within the app's address space.
#
# Previously we avoided this by linking the static framework with a single target using an abstract_target, and then
# provided a shim to expose their interfaces to other targets. The new approach implemented here removes the need for
# shim by modifying the build configuration generated by CocoaPods to restrict linkage to a single target.
def remove_static_framework_duplicate_linkage(static_framework_pods)
  puts "Removing duplicate linkage of static frameworks"

  Dir.glob(File.join(PODS_TARGET_SUPPORT_FILES_DIR, "Pods-*")).each do |path|
    pod_target = path.split('-', -1).last

    static_framework_pods.each do |target, pods|
      next if pod_target == target
      frameworks = pods.map { |pod| identify_frameworks(pod) }.flatten

      Dir.glob(File.join(path, "*.xcconfig")).each do |xcconfig|
        lines = File.readlines(xcconfig)

        if other_ldflags_index = lines.find_index { |l| l.start_with?('OTHER_LDFLAGS') }
          other_ldflags = lines[other_ldflags_index]

          frameworks.each do |framework|
            other_ldflags.gsub!("-framework \"#{framework}\"", '')
          end

          File.open(xcconfig, 'w') do |fd|
            fd.write(lines.join)
          end
        end
      end
    end
  end
end

def identify_frameworks(pod)
  frameworks = Dir.glob(File.join(PODS_DIR, pod, "**/*.framework")).map { |path| File.basename(path) }

  if frameworks.any?
    return frameworks.map { |f| f.split('.framework').first }
  end

  return pod
end
