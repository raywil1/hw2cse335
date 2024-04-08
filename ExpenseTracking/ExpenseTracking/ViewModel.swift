//
//  ViewModel.swift
//  ExpenseTracking
//
//  Created by Rayhan on 4/7/24.
//

import Foundation
import CoreData

class ActivityViewModel: ObservableObject {
    @Published var activities: [Activity] = []
    @Published var threshold: Double = 0.0
    
    private let viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchActivities()
    }
    
    func fetchActivities() {
        let request = Activity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Activity.date, ascending: false)]
        
        do {
            activities = try viewContext.fetch(request)
        } catch {
            print("Error fetching activities: \(error)")
        }
    }
    
    func addActivity(amount: Double, type: String) {
        let newActivity = Activity(context: viewContext)
        newActivity.amount = amount
        newActivity.type = type
        newActivity.date = Date()
        
        saveContext()
    }
    
    func deleteActivity(at offsets: IndexSet) {
        offsets.map { activities[$0] }.forEach(viewContext.delete)
        saveContext()
    }
    
    func saveContext() {
        do {
            try viewContext.save()
            fetchActivities()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func isOverThreshold() -> Bool {
        let totalSpending = activities.filter { $0.type == "spending" }.reduce(0) { $0 + $1.amount }
        return totalSpending > threshold
    }
}
