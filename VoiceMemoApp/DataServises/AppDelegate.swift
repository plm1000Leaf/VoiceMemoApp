//
//  AppDelegate.swift
//  VoiceMemoApp
//
//  Created by 千葉陽乃 on 2024/12/02.
//

import UIKit
import CoreData


class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    


    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "VoiceMemoApp") // モデル名に置き換え
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}