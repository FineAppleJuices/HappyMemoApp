//
//  Model.swift
//  HappyMemoApp
//
//  Created by 신혜연 on 9/19/24.
//

import UIKit

enum Category: String, CaseIterable {
    case work = "업무"
    case personal = "개인"
    case ideas = "아이디어"
    case todos = "할 일"
    
    static var orderedCategories: [Category] {
        return [.personal, .ideas, .work, .todos]
    }
}

struct Memo: Equatable {
    var id: String = UUID().uuidString
    var title: String
    var content: String
    var category: Category
}
