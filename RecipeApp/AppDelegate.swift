//
//  AppDelegate.swift
//  RecipeApp
//
//  Created by Anuar Nordin on 01/03/2021.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let defaultRealmPath = Realm.Configuration.defaultConfiguration.fileURL!
        print(defaultRealmPath)
        
        return true
    }




}

