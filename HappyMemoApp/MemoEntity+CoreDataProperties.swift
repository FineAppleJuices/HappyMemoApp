//
//  MemoEntity+CoreDataProperties.swift
//  HappyMemoApp
//
//  Created by 신혜연 on 10/13/24.
//
//

import Foundation
import CoreData


extension MemoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MemoEntity> {
        return NSFetchRequest<MemoEntity>(entityName: "MemoEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var category: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var modifiedAt: Date?

}

extension MemoEntity : Identifiable {

}
