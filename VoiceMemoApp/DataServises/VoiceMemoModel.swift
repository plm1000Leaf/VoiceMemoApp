//
//  VoiceMemomodel.swift
//  VoiceMemoApp
//
//  Created by 千葉陽乃 on 2024/12/03.
//
import Foundation
import CoreData

struct VoiceMemoModel {
    static func addVoiceMemo(title: String, duration: Double, context: NSManagedObjectContext) {
        let newVoiceMemo = VoiceMemoEntities(context: context)
        newVoiceMemo.title = title
        newVoiceMemo.duration = duration
        newVoiceMemo.createdAt = Date()
        do {
            try context.save()
            print("VoiceMemo追加成功: \(title)")
        } catch {
            print("VoiceMemo追加中にエラーが発生しました: \(error)")
        }
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

