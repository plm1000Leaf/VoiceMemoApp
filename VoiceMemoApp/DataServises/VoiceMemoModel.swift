//
//  VoiceMemomodel.swift
//  VoiceMemoApp
//
//  Created by 千葉陽乃 on 2024/12/03.
//
import Foundation
import CoreData

struct VoiceMemoModel {
    
    static func addVoiceMemo(title: String, duration: Double, context: NSManagedObjectContext,location: String? = nil) {
        let newVoiceMemo = VoiceMemoEntities(context: context)
        newVoiceMemo.title = title
//        let date = Date()
        newVoiceMemo.duration = duration
        newVoiceMemo.createdAt = Date()
        newVoiceMemo.location = location
        
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

    
    static func deleteVoiceMemo(_ voiceMemo: VoiceMemoEntities, context: NSManagedObjectContext) {
        context.delete(voiceMemo)
        do {
            try context.save()
            print("VoiceMemo削除成功: \(voiceMemo.title ?? "No Title")")
        } catch {
            print("VoiceMemo削除中にエラーが発生しました: \(error)")
        }
    }
    
}

