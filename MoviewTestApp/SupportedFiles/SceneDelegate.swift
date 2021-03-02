//
//  SceneDelegate.swift
//  MoviewTestApp
//
//  Created by Nifantiev Leonid Dev on 02.03.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    private lazy var applicationCoordinator: CoordinatorInterface = makeCoordinator()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        configure(scene)
        applicationCoordinator.start()
    }
    
    private func makeCoordinator() -> CoordinatorInterface {
        guard let window = window else { fatalError("window is not created") }
        let router = Router(window: window)
        return AppCoordinator(router: router)
    }
    
    private func configure(_ scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
    }


}

