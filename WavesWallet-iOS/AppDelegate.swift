//
//  AppDelegate.swift
//  WavesWallet-iOS
//
//  Created by Alexey Koloskov on 20/04/2017.
//  Copyright © 2017 Waves Platform. All rights reserved.
//

import RESideMenu
import RxSwift
import IQKeyboardManagerSwift
import UIKit

import AppsFlyerLib

import WavesSDKExtensions
import WavesSDK

import Extensions
import DomainLayer
import DataLayer

import Firebase

#if DEBUG || TEST
import AppSpectorSDK
#endif

#if DEBUG
import SwiftMonkeyPaws
#endif

#if DEBUG
enum UITest {
    static var isEnabledonkeyTest: Bool {
        return CommandLine.arguments.contains("--MONKEY_TEST")
    }
}
#endif

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var disposeBag: DisposeBag = DisposeBag()
    var window: UIWindow?

    var appCoordinator: AppCoordinator!
    lazy var migrationInteractor: MigrationUseCaseProtocol = UseCasesFactory.instance.migration
    
    #if DEBUG 
    var paws: MonkeyPaws?
    #endif
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Bugly.start(withAppId: "3609479c0b")
//        FirebaseApp.configure()
        let documentPaths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .allDomainsMask, true)
        print(documentPaths)
        guard let googleServiceInfoPath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") else {
            return false
        }
//        let googleServiceInfoPath = ""
//        guard let appsflyerInfoPath = Bundle.main.path(forResource: "Appsflyer-Info", ofType: "plist") else {
//            return false
//        }
        let appsflyerInfoPath = ""
        let amplitudeInfoPath = ""
//        guard let amplitudeInfoPath = Bundle.main.path(forResource: "Amplitude-Info", ofType: "plist") else {
//            return false
//        }

        guard let sentryIoInfoPath = Bundle.main.path(forResource: "Sentry-io-Info", ofType: "plist") else {
            return false
        }

        let resourses = RepositoriesFactory.Resources(googleServiceInfo: googleServiceInfoPath,
                                                      appsflyerInfo: appsflyerInfoPath,
                                                      amplitudeInfo: amplitudeInfoPath,
                                                      sentryIoInfoPath: sentryIoInfoPath)
        let repositories = RepositoriesFactory(resources: resourses)

        UseCasesFactory.initialization(repositories: repositories,
                                          authorizationInteractorLocalizable: AuthorizationInteractorLocalizableImp())
        
        setupUI()
        setupServices()
        
        let router = WindowRouter.windowFactory(window: self.window!)
        
        appCoordinator = AppCoordinator(router)

        migrationInteractor
            .migration()
            .subscribe(onNext: { (_) in

            }, onError: { (_) in

            }, onCompleted: {
                self.appCoordinator.start()
            })
            .disposed(by: disposeBag)
    
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {
        appCoordinator.applicationDidEnterBackground()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {
        appCoordinator.applicationDidBecomeActive()        
//        AppsFlyerTracker.shared().trackAppLaunch()
    }

    func applicationWillTerminate(_ application: UIApplication) {}

    func application(_ application: UIApplication,
                     open url: URL,
                     sourceApplication: String?,
                     annotation: Any) -> Bool {
        return false
    }
}

extension AppDelegate {
    
    func setupUI() {
        Swizzle(initializers: [UIView.passtroughInit, UIView.insetsInit, UIView.shadowInit]).start()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .basic50
        
        #if DEBUG
        if UITest.isEnabledonkeyTest {
            paws = MonkeyPaws(view: window!)
        }
        #endif
        
        IQKeyboardManager.shared.enable = true
        UIBarButtonItem.appearance().tintColor = UIColor.black
        Language.load()
    }
    
    func setupServices() {
//        #if DEBUG || TEST
//
//        SweetLogger.current.add(plugin: SweetLoggerConsole(visibleLevels: [.warning, .debug, .error, .network],
//                                                           isShortLog: true))
//        SweetLogger.current.visibleLevels = [.warning, .debug, .error]
//
//        AppsFlyerTracker.shared()?.isDebug = false
//
//        if let path = Bundle.main.path(forResource: "AppSpector-Info", ofType: "plist"),
//            let apiKey = NSDictionary(contentsOfFile: path)?["API_KEY"] as? String {
//            let config = AppSpectorConfig(apiKey: apiKey)
//            AppSpector.run(with: config)
//        }
//
//
//        #else
//        SweetLogger.current.add(plugin: SweetLoggerSentry(visibleLevels: [.error]))
//        SweetLogger.current.visibleLevels = [.warning, .debug, .error]
//        AppsFlyerTracker.shared()?.isDebug = false
//        #endif
    }

    class func shared() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    var menuController: RESideMenu {
        return self.window?.rootViewController as! RESideMenu
    }
}
