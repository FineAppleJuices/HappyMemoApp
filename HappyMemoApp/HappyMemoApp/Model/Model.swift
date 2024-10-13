//
//  Model.swift
//  HappyMemoApp
//
//  Created by 신혜연 on 9/19/24.
//

import UIKit
import CoreData

enum Category: String, CaseIterable {
    case work = "업무"
    case personal = "개인"
    case ideas = "아이디어"
    case todos = "할 일"
    
    static var orderedCategories: [Category] {
        return [.personal, .ideas, .work, .todos]
    }
}

struct MemoModel: Identifiable, Equatable {
    let id: String
    var title: String
    var content: String
    let createdAt: Date = Date()
    var modifiedAt: Date?
    var category: Category
}

extension MemoModel {
    // 현재 모델을 엔티티로 변환하는 메서드
    func mapToEntityInContext(_ context: NSManagedObjectContext) -> MemoEntity {
        
        let memo: MemoEntity = .init(context: context)
        memo.id = self.id
        memo.title = self.title
        memo.content = self.content
        memo.createdAt = self.createdAt
        if let modifiedAt = self.modifiedAt {
            memo.modifiedAt = modifiedAt
        }
        memo.category = self.category.rawValue
        
        return memo
    }
    
    // 엔티티를 모델로 변환하는 메서드, 강제 업래핑을 통해 nil 값일 때의 처리를 하고 있음
    static func mapFromEntity(_ entity: MemoEntity) -> Self {
        return .init(id: entity.id!, title: entity.title!, content: entity.content!, modifiedAt: entity.modifiedAt ?? nil, category: Category(rawValue: entity.category!) ?? Category.todos)
    }
    
}
