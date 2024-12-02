//
//  Folder+CoreDataClass.swift
//  VoiceMemoApp
//
//  Created by 千葉陽乃 on 2024/12/02.
//
//

import Foundation
import CoreData

@objc(Folder)
public class FolderEntities: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var numberOfData: Int32
    @NSManaged public var voicememos: NSSet?
}

@objc(VoiceMemo)
public class VoiceMemoEntities: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var filePath: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var duration: Double
    @NSManaged public var location: String?
    @NSManaged public var folder: FolderEntities?
}


