//
//  FolderModel.swift
//  VoiceMemoApp
//
//  Created by 千葉陽乃 on 2025/01/05.
//

import Foundation
import CoreData
import SwiftUI

struct FolderModel {
    static func saveFolder(viewContext: NSManagedObjectContext,
                           textFieldText: String) -> UUID? {
        let newFolder = FolderEntities(context: viewContext)
        let newID = UUID()
        newFolder.id = newID
        newFolder.title = textFieldText
        newFolder.numberOfData = 0 // デフォルト値を設定
        do {
            try viewContext.save() // Core Data に保存
            return newID
        } catch {
            print("Error saving folder: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func deleteFolder(_ folder: FolderEntities, viewContext: NSManagedObjectContext) {
       viewContext.delete(folder)
       do {
           try viewContext.save()
       } catch {
           print("Error deleting folder: \(error.localizedDescription)")
       }
   }
    
    
}
