//
//  ContentView.swift
//  ExpenseTracking
//
//  Created by Rayhan on 4/7/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var activityViewModel: ActivityViewModel
    @State private var newActivityAmount: String = ""
    @State private var newActivityType: String = "spending"
    
    init(context: NSManagedObjectContext) {
        _activityViewModel = StateObject(wrappedValue: ActivityViewModel(context: context))
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Activities")) {
                    ForEach(activityViewModel.activities) { activity in
                        HStack {
                            Text(activity.type ?? "")
                            Spacer()
                            Text(String(format: "%.2f", activity.amount))
                        }
                    }
                    .onDelete(perform: activityViewModel.deleteActivity)
                }
                
                Section(header: Text("Add Activity")) {
                    HStack {
                        TextField("Amount", text: $newActivityAmount)
                            .keyboardType(.decimalPad)
                        
                        Picker("Type", selection: $newActivityType) {
                            Text("Spending").tag("spending")
                            Text("Saving").tag("saving")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    Button(action: addActivity) {
                        Text("Add")
                    }
                }
                
                Section(header: Text("Threshold")) {
                    HStack {
                        Text("Threshold")
                        Spacer()
                        TextField("Threshold", value: $activityViewModel.threshold, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Expense Tracking")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .alert(isPresented: .constant(activityViewModel.isOverThreshold())) {
                Alert(title: Text("Over Threshold"), message: Text("You have exceeded your spending threshold."), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func addActivity() {
        guard let amount = Double(newActivityAmount) else { return }
        activityViewModel.addActivity(amount: amount, type: newActivityType)
        newActivityAmount = ""
        newActivityType = "spending"
    }
}

struct ActivitiesView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Activity.date, ascending: false)],
        animation: .default
    )
    private var activities: FetchedResults<Activity>
    
    var body: some View {
        List {
            ForEach(activities) { activity in
                HStack {
                    Text(activity.type ?? "")
                    Spacer()
                    Text(String(format: "%.2f", activity.amount))
                }
            }
        }
        .navigationTitle("Activities")
    }
}
