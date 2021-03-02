//
//  Router.swift
//  MVVMTest
//
//  Created by Xcode user on 19.02.2021.
//  Copyright © 2021 Genesis. All rights reserved.
//

import UIKit

protocol RouterInterface {
    func setRootModule(viewController: UIViewController)
    func push(viewController: UIViewController)
    func back()
}

class Router: RouterInterface {
    
    var rootViewController: UINavigationController?
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func setRootModule(viewController: UIViewController) {
        self.rootViewController = UINavigationController(rootViewController: viewController)
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
    
    func push(viewController: UIViewController) {
        rootViewController?.pushViewController(viewController, animated: true)
    }
    
    func back() {
        rootViewController?.popViewController(animated: true)
    }
}
