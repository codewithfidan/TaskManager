//
//  HomeView.swift
//  TaskManager
//
//  Created by Fidan Oruc on 10.12.22.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var model: TaskViewModel = .init()
    
    // MARK: Matched Geometry Namespace
    @Namespace var animation
    
    // MARK: Fetching Task
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Task.deadline, ascending: false)], predicate: nil, animation: .easeInOut) var tasks:  FetchedResults<Task>
 
    // MARK:  Environment Values
    @Environment(\.self) var environment
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack{
                VStack(alignment: .leading, spacing: 8) {
                    Text("Welcome Back")
                        .font(.callout)
                    Text("Here's Update Today.")
                        .font(.title2.bold())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                
                CustomSegmentedBar()
                    .padding(.top, 5)
                
                // MARK: Task View
                TaskView()
            }
            .padding()
        }
        .overlay(alignment: .bottom) {
            // MARK: Add button
            Button {
                model.openEditTask.toggle()
            } label: {
                Label {
                    Text("Add Task")
                        .font(.callout)
                        .fontWeight(.semibold)
                } icon: {
                    Image(systemName: "plus.app.fill")
                }
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(.black, in: Capsule())

            }
            // MARK: Linear Gradient BG
            .padding(.top, 10)
            .frame(maxWidth: .infinity)
            .background{
                LinearGradient(colors: [
                    .white.opacity(0.05),
                    .white.opacity(0.4),
                    .white.opacity(0.7),
                    .white
                ], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            }

        }
        .fullScreenCover(isPresented: $model.openEditTask) {
            model.resetTaskData()
        } content: {
            AddNewTask()
                .environmentObject(model)
        }

        
    }
    
    
    // MARK: Task View
    @ViewBuilder
    func TaskView() -> some View{

        
        LazyVStack(spacing: 20){
            
            DynamicFilteredView(currentTab: model.currentTab) { (task: Task) in
                TaskRowView(task: task)
            }
        }
        .padding(.top, 20)
    }
    
    // MARK: Task Row  View
    @ViewBuilder
    func TaskRowView(task: Task) -> some View{
        
        VStack(alignment: .leading, spacing: 10) {
            HStack{
                Text(task.type ?? "")
                    .font(.callout)
                    .padding(.vertical,5)
                    .padding(.horizontal)
                    .background{
                        Capsule()
                            .fill(.white.opacity(0.3))
                    }
                Spacer()
                
                // MARK: Edit button only for non completed tasks
                if !task.isCompleted && model.currentTab != "Failed"{
                    Button {
                        model.editTask = task
                        model.openEditTask = true
                        model.setUpTask()
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.black)
                    }

                }
            }
            
            Text(task.title ?? "")
                .font(.title2.bold())
                .foregroundColor(.black)
                .padding(.vertical,10)
            
            HStack(alignment: .bottom, spacing: 0) {
                VStack(alignment: .leading, spacing: 10) {
                    Label {
                        Text((task.deadline ?? Date()).formatted(date: .long, time: .omitted))
                    } icon: {
                        Image(systemName: "calendar")
                    }
                    .font(.caption)

                    
                    Label {
                        Text((task.deadline ?? Date()).formatted(date: .omitted, time: .shortened))
                    } icon: {
                        Image(systemName: "clock")
                    }
                    .font(.caption)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if !task.isCompleted && model.currentTab != "Failed"{
                    Button{
                        
                        // MARK: Updating Core Data
                        task.isCompleted.toggle()
                        try? environment.managedObjectContext.save()
                    } label: {
                        Circle()
                            .strokeBorder(.black, lineWidth: 1.5)
                            .frame(width: 25, height: 25)
                            .contentShape(Circle())
                    }

                }
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background{
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(task.color ?? "Yellow"))
        }
    }
    
    // MARK: Custom Segmented Bar
    @ViewBuilder
    func CustomSegmentedBar()-> some View{
        let tabs =  ["Today", "Upcoming", "Task Done", "Failed"]
        HStack(spacing: 10){
            ForEach(tabs, id: \.self){tab in
                Text(tab)
                    .font(.callout)
                    .bold()
                    .scaleEffect(0.9)
                    .foregroundColor(model.currentTab == tab ? .white : .black)
                    .padding(.vertical, 6)
                    .frame(maxWidth: .infinity)
                    .background{
                        if model.currentTab == tab{
                            Capsule()
                                .fill(.black)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                    .contentShape(Capsule())
                    .onTapGesture {
                        withAnimation(.linear(duration: 0.3)){
                            model.currentTab = tab
                        }
                            
                    }
            }
        }
        
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
