//
//  Persistence.swift
//  EventHub
//
//  Created by Manish Kumar on 23/01/25.
//

import CoreData

struct PersistenceController {
    
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Event(context: viewContext)
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "EventHub")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func deleteAllEvents() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Event.fetchRequest()
        let context = PersistenceController.shared.container.viewContext
        
        do {
            let results = try context.fetch(fetchRequest)
            
            for object in results {
                if let personToDelete = object as? NSManagedObject {
                    context.delete(personToDelete)
                }
            }
            try context.save()
        } catch {
            print("Failed to delete all persons: \(error.localizedDescription)")
        }
    }
}

