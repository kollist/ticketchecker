//
//  SceneDelegate.swift
//  Ticket Checker
//
//  Created by Zaytech Mac on 17/10/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let vc = ResultViewController();
        vc.statusImage = UIImage(named: "InvalidTicketIcon")
        vc.statusTitle = "Ticket Already Scanned"
        vc.eventInstance = Event(uuid: "8212EPTRQWOS", owner_name: "Mohammed EL BANYAOUI", is_checked: true, is_expired: false, nb_of_checkers: 6, event_title: "All Hail the Buenos Aires Bodegón", event_description: "A reflection of the massive waves of immigrants that arrived in Argentina at the turn of the 19th century, these Italo-Hispano restaurants are brimming with character.", nb_of_persons: 1, channel: "ios", amount: 500, charge_uuid: "86T8AP28M99KG", created_at: "2024-10-16T17:43:36.000000Z")
        vc.ticketNumber = "8212EPTRQWOS"
        vc.statusColors = [UIColor(named: "InvalidTicketColorTwo")?.cgColor ?? UIColor.green.cgColor, UIColor(named: "InvalidTicketColorOne")?.cgColor ?? UIColor.systemGreen.cgColor]
        window.rootViewController = QRScannerViewController()
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

