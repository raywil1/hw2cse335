//
//  Persistence.swift
//  ExpenseTracking
//
//  Created by Rayhan on 4/7/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        
        for _ in 0..<10 {
            let newActivity = Activity(context: viewContext)
            newActivity.amount = Double.random(in: 1...100)
            newActivity.type = Bool.random() ? "spending" : "saving"
            newActivity.date = Date()
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
        
        guard let modelURL = Bundle.main.url(forResource: "ExpenseTracking", withExtension: "momd") else {
            fatalError("Unable to find the model file.")
        }
        
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to load the model.")
        }
        
        container = NSPersistentContainer(name: "ExpenseTracking", managedObjectModel: model)
        
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
}
