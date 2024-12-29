//
//  VoiceMemoEntities+CoreDataProperties.swift
//  VoiceMemoApp
//
//  Created by 千葉陽乃 on 2024/12/02.
//
import Foundation
import CoreData

extension VoiceMemoEntities {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VoiceMemoEntities> {
        return NSFetchRequest<VoiceMemoEntities>(entityName: "VoiceMemoEntities")
    }
    @NSManaged public var isDelete: Bool
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var filePath: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var duration: Double
    @NSManaged public var location: String?
}

