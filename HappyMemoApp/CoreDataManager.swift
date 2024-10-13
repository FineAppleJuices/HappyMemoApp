//
//  CoreDataManager.swift
//  HappyMemoApp
//
//  Created by 신혜연 on 10/13/24.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    // 모델의 이름고 같은지 확인
    let persistentContainer =  NSPersistentContainer(name: "MemoModel")
    
    init() {
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - CRUD 작업
    
    // Create
    func createMemo(memo: MemoModel) {
        let entity = memo.mapToEntityInContext(context)
        saveContext()
    }
    
    // Read (모든 메모 가져오기)
    func fetchAllMemos() -> [MemoModel] {
        let fetchRequest: NSFetchRequest<MemoEntity> = MemoEntity.fetchRequest()
        
        do {
            let memoEntities = try context.fetch(fetchRequest)
            return memoEntities.map { MemoModel.mapFromEntity($0) }
        } catch {
            print("Fetch failed: \(error)")
            return []
        }
    }
    
    // Update
    func updateMemo(memo: MemoModel) {
        let fetchRequest: NSFetchRequest<MemoEntity> = MemoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", memo.id)
        
        do {
            let memoEntities = try context.fetch(fetchRequest)
            if let memoEntity = memoEntities.first {
                memoEntity.title = memo.title
                memoEntity.content = memo.content
                memoEntity.modifiedAt = memo.modifiedAt
                memoEntity.category = memo.category.rawValue
                saveContext()
            }
        } catch {
            print("Update failed: \(error)")
        }
    }
    
    // Delete
    func deleteMemo(memo: MemoModel) {
        let fetchRequest: NSFetchRequest<MemoEntity> = MemoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", memo.id)
        
        do {
            let memoEntities = try context.fetch(fetchRequest)
            if let memoEntity = memoEntities.first {
                context.delete(memoEntity)
                saveContext()
            }
        } catch {
            print("Delete failed: \(error)")
        }
    }
    
    // Save Context (변경 사항 저장)
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

