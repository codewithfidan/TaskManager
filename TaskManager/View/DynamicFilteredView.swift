//
//  DynamicFilteredView.swift
//  TaskManager
//
//  Created by Fidan Oruc on 11.12.22.
//

import SwiftUI
import CoreData

struct DynamicFilteredView <Content: View, T>: View where T: NSManagedObject  {
   // MARK: Core data request
    
    @FetchRequest var request: FetchedResults<T>
    let content: (T) -> Content
    
    // MARK: Building custom ForEach which will give CoreData object to build View
    init(currentTab: String, @ViewBuilder content: @escaping (T) -> Content){
        
        
        // MARK: Predicate to filter current date tasks
        let calendar = Calendar.current
        var predicate: NSPredicate!
        
        if currentTab == "Today"{
            
             let today = calendar.startOfDay(for: Date())
            let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
             
             // Filter key
             let filterkey = "deadline"
             
             // This will fetch task between today and tomorrow which is 24 HRS
            // 0- false, 1- true
             predicate = NSPredicate(format: "\(filterkey) >= %@ AND \(filterkey) < %@ AND isCompleted == %i", argumentArray: [today, tomorrow, 0])
             
        }else if currentTab == "Upcoming"{
            
            let today = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: Date())!)
            let tomorrow = Date.distantFuture
            
            // Filter key
            let filterkey = "deadline"
            
            // This will fetch task between today and tomorrow which is 24 HRS
           // 0- false, 1- true
            predicate = NSPredicate(format: "\(filterkey) >= %@ AND \(filterkey) < %@ AND isCompleted == %i", argumentArray: [today, tomorrow, 0])
        }else if currentTab == "Failed"{
           
            let today = calendar.startOfDay(for: Date())
            let past = Date.distantPast
            
            // Filter key
            let filterkey = "deadline"
            
            // This will fetch task between today and tomorrow which is 24 HRS
           // 0- false, 1- true
            predicate = NSPredicate(format: "\(filterkey) >= %@ AND \(filterkey) < %@ AND isCompleted == %i", argumentArray: [past, today, 0])
        }else{
            
        }
  
        // Initializing request with NSPredicate
        // Adding sort
        _request = FetchRequest(entity: T.entity(), sortDescriptors: [.init(keyPath: \Task.deadline, ascending: false)], predicate: predicate)
        self.content = content
    }
    
    
    var body: some View{
        Group{
            if request.isEmpty{
                Text("No task  found!")
                    .font(.system(size: 16))
                    .fontWeight(.light)
                    .offset(y: 100)
            }else{
                
                
                ForEach(request, id: \.objectID){ object in
                    self.content(object)
                    
                }
            }
        }
    }
}


