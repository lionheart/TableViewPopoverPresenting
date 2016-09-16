//
//  AppDelegate.swift
//  TableViewPopoverPresenting
//
//  Created by Dan Loewenherz on 06/19/2016.
//  Copyright (c) 2016 Dan Loewenherz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else {
            return false
        }

        window.rootViewController = UINavigationController(rootViewController: ViewController())
        window.makeKeyAndVisible()
        return true
    }
}

