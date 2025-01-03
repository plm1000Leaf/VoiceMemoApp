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

    static func addVoiceMemo(title: String, duration: Double, context: NSManagedObjectContext,location: String? = nil) {
        let newVoiceMemo = VoiceMemoEntities(context: context)
        newVoiceMemo.title = title
        newVoiceMemo.duration = duration
        newVoiceMemo.createdAt = Date()
        newVoiceMemo.location = location
        newVoiceMemo.isDelete = false
        newVoiceMemo.isFav = false
        
        do {
            try context.save()
            print("VoiceMemo追加成功: \(title)")
        } catch {
            print("VoiceMemo追加中にエラーが発生しました: \(error)")
        }
    }
    
    static func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    
    static func formatTime(from duration: Double) -> String {
       let minutes = Int(duration) / 60
       let seconds = Int(duration) % 60
       return String(format: "%02d:%02d", minutes, seconds)
   }

    
    static func seekBarDeleteVoiceMemo(_ voiceMemo: VoiceMemoEntities, context: NSManagedObjectContext) {
        context.delete(voiceMemo)
        do {
            try context.save()
            print("VoiceMemo削除成功: \(voiceMemo.title ?? "No Title")")
        } catch {
            print("VoiceMemo削除中にエラーが発生しました: \(error)")
        }
        
    }
    
    static func moveToDeletedFolder(_ voiceMemo: VoiceMemoEntities, context: NSManagedObjectContext) {
        voiceMemo.isDelete = true // 削除済みとしてマーク
        do {
            try context.save()
            print("VoiceMemoを削除済みフォルダに移動しました: \(voiceMemo.title ?? "No Title")")
        } catch {
            print("削除済みフォルダへの移動中にエラーが発生しました: \(error)")
        }
        
        
    }
    
    static func moveSelectedMemosToDeletedFolder(selectedMemos:Set<NSManagedObjectID>,voiceMemos: FetchedResults<VoiceMemoEntities>,context: NSManagedObjectContext) {
        selectedMemos.forEach { objectID in
            if let memo = voiceMemos.first(where: { $0.objectID == objectID }) {
                memo.isFav = false
                memo.isDelete = true // 削除フラグを立てる
            }
        }
        do {
            try context.save()
        } catch {
            print("削除済みフォルダへの移動中にエラー: \(error)")
        }
    }
    
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
    }

    


