//
//  FolderEntities.swift
//  VoiceMemoApp
//
//  Created by 千葉陽乃 on 2024/12/29.
//

import Foundation
import CoreData

@objc(FolderEntities)
public class FolderEntities: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var numberOfData: Int32
    @NSManaged public var title: String
    @NSManaged public var voicememos: Set<VoiceMemoEntities>?
}

extension FolderEntities {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FolderEntities> {
        return NSFetchRequest<FolderEntities>(entityName: "FolderEntities")
    }
}
