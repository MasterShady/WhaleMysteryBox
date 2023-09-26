//
//  TabbarVC.swift
//  gerental
//
//  Created by 刘思源 on 2022/12/8.
//

import Foundation
import UIKit

extension UITabBar{
    func updateAppearance(_ update:(UITabBarAppearance)->()){
        let appearance = self.standardAppearance
        update(appearance)
        if #available(iOS 15.0, *) {
            self.scrollEdgeAppearance = appearance
        } else {
        
        }
    }
}

@objcMembers class TabbarVC : UITabBarController{
    
    
//    private let initializer: Void = {
//        let selectedAttributes: [NSAttributedString.Key: Any] = [
//            .font: UIFont.boldSystemFont(ofSize: 10),
//            .foregroundColor: UIColor.init(hexColor: "#333333")
//        ]
//        UITabBarItem.appearance().setTitleTextAttributes(selectedAttributes, for: .selected)
//
//        let normalAttributes: [NSAttributedString.Key: Any] = [
//            .font: UIFont.boldSystemFont(ofSize: 10),
//            .foregroundColor: UIColor.red
//        ]
//        UITabBarItem.appearance().setTitleTextAttributes(normalAttributes, for: .normal)
//
//
//    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let tabbar = DFTabbar()
//        tabbar.roundButtonClickHandler = {
//            UserStore.checkLoginStatusThen {
//                let vc = NavVC(rootViewController: CreatePostVC())
//                self.present(vc, animated: true)
//            }
//        }
//        self.setValue(tabbar, forKey: "tabBar")
        tabBar.isTranslucent = true
        tabBar.tintColor = .init(hexColor: "#333333")
//        tabBar.shadowImage = nil
        
        
       
//        tabBar.updateAppearance {
//            $0.configureWithOpaqueBackground()
//            $0.backgroundColor = .kExLightGray
//        }
        
        self.addChilds()
    }
    
        func addChilds(){
            
            let childs : [(String,String,UIViewController)] = [
                ("home","逛逛",HomeVC()),
                ("publish","发布",PublicVC()),
                ("mine","我的",MineVC())
            ]
            
            for child in childs {
                let normalImage = UIImage(named: "tabbar_" + child.0)!
                let selectedImage = UIImage(named: "tabbar_" + child.0 + "_s")!
                
                let vc = NavVC(rootViewController: child.2)
                vc.tabBarItem.image = normalImage.withRenderingMode(.alwaysOriginal)
                vc.tabBarItem.selectedImage = selectedImage.withRenderingMode(.alwaysOriginal)
                vc.tabBarItem.title = child.1
                self.addChild(vc)
    
            }
    
        }
    
    
    
}
