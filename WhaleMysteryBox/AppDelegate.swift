//
//  AppDelegate.swift
//  WhaleMysteryBox
//
//  Created by 刘思源 on 2023/9/25.
//

import UIKit
import IQKeyboardManagerSwift
import ThinkingSDK
import Meiqia

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        if window == nil{
            window = UIWindow(frame: UIScreen.main.bounds)
        }
        window?.rootViewController = TabbarVC()
        window?.makeKeyAndVisible()
        
        initThinkSDK()
        initMeiqia()
        
        return true
    }
    
    
    func initThinkSDK(){
        //ThinkingAnalyticsSDK.setLogLevel(.debug)
        ThinkingAnalyticsSDK.start(withAppId: "0f0d35332c244d18b7d7e200a6d20e61", withUrl: "bR/xGSkN5L02AYcCe7GntUEv8tSjb4F1O0/ZHNHcU5Y=".aes256decode())
        let instance = ThinkingAnalyticsSDK.sharedInstance()!
        
        instance.superProperty.registerSuperProperties([
            "app_id":"500180000",
            "app_channel": "appstore_",
            "app_version_name": "1.0.0.0",
            "is_jail_break": DeviceHelper.isJailBreak,
            "hasSimCard" : DeviceHelper.hasSIMCard
        ])
        
        instance.addWebViewUserAgent()
        instance.enableAutoTrack([.eventTypeAll])
    }

    
    func initMeiqia(){
        MQManager.initWithAppkey("0cbc0918134feac1965011b10cf2f459") { clientId, error in
            if(error == nil){
                print("美洽sdk init success")
            } else {
                print(error!)
            }
        }
    }


}

