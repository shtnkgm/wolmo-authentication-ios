//
//  AppDelegate.swift
//  AuthenticationDemo
//
//  Created by Daniela Riesgo on 3/16/16.
//  Copyright © 2016 Wolox. All rights reserved.
//

import UIKit
import Authentication
import FacebookCore
import ReactiveSwift
import Result

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var sessionService = ExampleSessionService(email: "example@mail.com", password: "password")
    lazy var authenticationCoordinator: AuthenticationCoordinator<ExampleUser, ExampleSessionService> = self.createCoordinator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        sessionService.currentUser
            .signal
            .filter { $0 == nil }
            .flatMap(.latest) { [unowned self] _ -> SignalProducer<(), LoginProviderErrorType> in
                    return self.authenticationCoordinator.currentLoginProvider?.logOut() ?? SignalProducer(value: ())
                }
            .observeResult { [unowned self] in
                    switch $0 {
                    case .success: self.authenticationCoordinator.start()
                    case .failure: break
                    }
                }
        authenticationCoordinator.start()

        //You need to call this so the SDK is launched correctly (and for example to have facebook recognize a previous login).
        // http://stackoverflow.com/a/30072323
        return SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // swiftlint:disable line_length
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        // swiftlint:enable line_length
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // swiftlint:disable line_length
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        // swiftlint:enable line_length
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return SDKApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
}

extension AppDelegate {

    func createCoordinator() -> AuthenticationCoordinator<ExampleUser, ExampleSessionService> {
        let loginConfiguration = LoginViewConfiguration(logoImage: UIImage(named: "default")!, colorPalette: ColorPalette())
        let signupConfiguration = SignupViewConfiguration(termsAndServicesURL: URL(string: "https://www.wolox.com.ar/")!,
                                                          colorPalette: ColorPalette(), showLoginProviders: true)
        let loginProviders: [LoginProvider] = [FacebookLoginProvider(), ExampleFailLoginProvider(), ExampleSuccessLoginProvider()]
        let componentsFactory = AuthenticationComponentsFactory(loginConfiguration: loginConfiguration,
                                                                signupConfiguration: signupConfiguration,
                                                                loginProviders: loginProviders) { [unowned self] in
            let storyboard = UIStoryboard(name: "Main", bundle: .none)
            let controller = storyboard.instantiateViewController(withIdentifier: "ExampleMainViewController") as! ExampleMainViewController // swiftlint:disable:this force_cast
            controller.sessionService = self.sessionService
            return controller
        }
        let authenticationCoordinator = AuthenticationCoordinator(sessionService: sessionService,
                                                                  window: window!,
                                                                  initialScreen: .signup,
                                                                  componentsFactory: componentsFactory)
        return authenticationCoordinator
    }

}

struct ColorPalette: ColorPaletteType {
    
    var textfieldBackground: UIColor = .cyan
    
}
