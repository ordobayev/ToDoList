//
//  SceneDelegate.swift
//  ToDoList
//
//  Created by Aslan Arapbaev on 6/25/20.
//  Copyright © 2020 aslanarapbaev. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let dataModel = DataModel()


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        let navigationController = window?.rootViewController as! UINavigationController
        let controller = navigationController.viewControllers[0] as! GroupViewController
        controller.dataModel = dataModel

    }

    func sceneDidDisconnect(_ scene: UIScene) {
        print("sceneDidDisconnect")
        saveData()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print("sceneDidBecomeActive")
    }

    func sceneWillResignActive(_ scene: UIScene) {
        print("sceneWillResignActive")
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        print("sceneWillEnterForeground")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print("sceneDidEnterBackground")
        saveData()
    }
    
    // MARK: - Helper Methods
    
    func saveData() {
        dataModel.saveChecklists()
    }

}

