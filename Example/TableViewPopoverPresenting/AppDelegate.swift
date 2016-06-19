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

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        guard let window = window else {
            return false
        }

        window.rootViewController = UINavigationController(rootViewController: ViewController())
        window.makeKeyAndVisible()
        return true
    }
}

