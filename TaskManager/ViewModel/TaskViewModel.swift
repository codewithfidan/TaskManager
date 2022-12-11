//
//  TaskViewModel.swift
//  TaskManager
//
//  Created by Fidan Oruc on 10.12.22.
//

import SwiftUI
import CoreData

class TaskViewModel: ObservableObject {
    @Published var currentTab: String = "Today"
    
    
    // MARK: New Task Properties
    @Published var openEditTask: Bool = false
    @Published var taskTitle: String = ""
    @Published var taskColor: String = "Yellow"
    @Published var taskDeadline: Date = Date()
    @Published var taskType: String = "Basic"
    @Published var showDatePicker: Bool = false
    
    // MARK: Editing Exicting Task Data
    @Published var editTask: Task?
    
    // MARK: Adding Task to Core Data
    
    func addTask(context: NSManagedObjectContext) -> Bool{
        
        // MARK: Updating existing data in CoreData
        
        var task: Task!
        if let editTask = editTask {
            task = editTask
        }else{
            task = Task(context: context)
        }
        
        
        task.title = taskTitle
        task.color = taskColor
        task.type = taskType
        task.deadline = taskDeadline
        task.isCompleted = false
        
        
        if let _ = try? context.save(){
            return true
        }
        return false
    }
    
    
    // MARK: Resetting Data
    func resetTaskData(){
        taskType = "Basic"
        taskColor = "Yellow"
        taskTitle = ""
        taskDeadline = Date()
    }
    
    // MARK: If editTask is available then setting existing data
    func setUpTask(){
        if let editTask = editTask {
            taskType = editTask.type ?? "Basic"
            taskColor = editTask.color ?? "Yellow"
            taskTitle = editTask.title ?? ""
            taskDeadline = editTask.deadline ?? Date()
        }
    }
    
}
