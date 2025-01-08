//
//  VoiceMemomodel.swift
//  VoiceMemoApp
//
//  Created by 千葉陽乃 on 2024/12/03.
//
import Foundation
import CoreData
import SwiftUI

struct VoiceMemoModel {
    

//    メモの追加と削除
    static func addVoiceMemo(title: String, duration: Double, context: NSManagedObjectContext,location: String? = nil, filePath: String? = nil) {
        let newVoiceMemo = VoiceMemoEntities(context: context)
        newVoiceMemo.title = title
        newVoiceMemo.duration = duration
        newVoiceMemo.createdAt = Date()
        newVoiceMemo.location = location
        newVoiceMemo.filePath = filePath
        newVoiceMemo.isDelete = false
        newVoiceMemo.isFav = false
        
        do {
            try context.save()
            print("VoiceMemo追加成功: \(title)")
        } catch {
            print("VoiceMemo追加中にエラーが発生しました: \(error)")
        }
    }
    
    static func seekBarDeleteVoiceMemo(_ voiceMemo: VoiceMemoEntities, context: NSManagedObjectContext) {
        if let folderID = voiceMemo.folderID,
           let folder = fetchFolderByID(folderID, context: context) {
            context.delete(voiceMemo)
            updateNumberOfData(for: folder, context: context)
        } else {
            context.delete(voiceMemo)
        }

        do {
            try context.save()
            print("VoiceMemo削除成功: \(voiceMemo.title ?? "No Title")")
        } catch {
            print("VoiceMemo削除中にエラーが発生しました: \(error)")
        }
        
    }
    
    
//フォーマット
    static func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    
    static func formatListTime(from duration: Double) -> String {
       let minutes = Int(duration) / 60
       let seconds = Int(duration) % 60
       return String(format: "%02d:%02d", minutes, seconds)
   }
    static func formatRecordingTime(from duration: Double) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    
// フォルダ移動
    static func moveToDeletedFolder(_ voiceMemo: VoiceMemoEntities, context: NSManagedObjectContext) {
        voiceMemo.isDelete = true // 削除済みとしてマーク
        do {
            try context.save()
            print("VoiceMemoを削除済みフォルダに移動しました: \(voiceMemo.title ?? "No Title")")
        } catch {
            print("削除済みフォルダへの移動中にエラーが発生しました: \(error)")
        }
        
        
    }
    static func moveSelectedMemosToDeletedFolder(
        selectedMemos: Set<NSManagedObjectID>,
        voiceMemos: FetchedResults<VoiceMemoEntities>,
        context: NSManagedObjectContext
    ) {
        var affectedFolders: Set<UUID> = []

        // 削除フラグを設定
        selectedMemos.forEach { objectID in
            if let memo = voiceMemos.first(where: { $0.objectID == objectID }) {
                memo.isFav = false
                memo.isDelete = true
                if let folderID = memo.folderID {
                    affectedFolders.insert(folderID)
                }
            }
        }

        // 保存処理
        do {
            try context.save()
            print("削除フラグが正常に設定されました。")

            // numberOfData を更新
            for folderID in affectedFolders {
                if let folder = fetchFolderByID(folderID, context: context) {
                    updateNumberOfData(for: folder, context: context)
                }
            }
        } catch {
            print("削除済みフォルダへの移動中にエラー: \(error)")
        }
    }
//    static func moveSelectedMemosToDeletedFolder(selectedMemos:Set<NSManagedObjectID>,voiceMemos: FetchedResults<VoiceMemoEntities>,context: NSManagedObjectContext) {
//        selectedMemos.forEach { objectID in
//            if let memo = voiceMemos.first(where: { $0.objectID == objectID }) {
//                memo.isFav = false
//                memo.isDelete = true // 削除フラグを立てる
//            
//            }
//        }
//        do {
//            try context.save()
//        } catch {
//            print("削除済みフォルダへの移動中にエラー: \(error)")
//        }
//    }
//    
    static func moveSelectedMemosToFavFolder(selectedMemos:Set<NSManagedObjectID>,voiceMemos: FetchedResults<VoiceMemoEntities>,context: NSManagedObjectContext) {
        selectedMemos.forEach { objectID in
            if let memo = voiceMemos.first(where: { $0.objectID == objectID }) {
                memo.isFav = true
            }
        }
        do {
            try context.save()
        } catch {
            print("削除済みフォルダへの移動中にエラー: \(error)")
        }
    } 
    
    static func moveSelectedMemosToFolder(selectedFolder: FolderEntities, selectedMemos: Set<NSManagedObjectID>, context: NSManagedObjectContext,voiceMemos: FetchedResults<VoiceMemoEntities>) {
        selectedMemos.forEach { objectID in
            if let memo = context.object(with: objectID) as? VoiceMemoEntities {
                memo.folderID = selectedFolder.id // フォルダIDを更新
            }
            updateNumberOfData(for: selectedFolder, context: context)
        }
        
        let folderMemosCount = voiceMemos.filter { $0.folderID == selectedFolder.id }.count
        selectedFolder.numberOfData = Int32(folderMemosCount)
        
        do {
            try context.save()
            print("メモがフォルダ \(selectedFolder.title) に移動しました")
        } catch {
            print("フォルダへの移動中にエラー: \(error)")
        }
    }
    
    // フォルダのメモ数を更新
    static func updateNumberOfData(for folder: FolderEntities, context: NSManagedObjectContext) {
        let request: NSFetchRequest<VoiceMemoEntities> = VoiceMemoEntities.fetchRequest()
        request.predicate = NSPredicate(format: "folderID == %@ AND isDelete == NO", folder.id as CVarArg)

        do {
            let memoCount = try context.count(for: request)
            folder.numberOfData = Int32(memoCount)
            try context.save()
            print("Folder \(folder.title) の numberOfData を更新しました: \(memoCount)")
        } catch {
            print("numberOfData の更新中にエラー: \(error)")
        }
    }
    
    static func fetchFolderByID(_ id: UUID, context: NSManagedObjectContext) -> FolderEntities? {
        let request: NSFetchRequest<FolderEntities> = FolderEntities.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            return try context.fetch(request).first
        } catch {
            print("フォルダ取得中にエラー: \(error)")
            return nil
        }
    }


    }

    


