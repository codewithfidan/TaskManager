//
//  AddNewTask.swift
//  TaskManager
//
//  Created by Fidan Oruc on 10.12.22.
//

import SwiftUI

struct AddNewTask: View {
    @EnvironmentObject var model:  TaskViewModel
    
    // MARK: All Environment Values in one Variable
    @Environment(\.self) var environment
    @Namespace var animation
    
    var body: some View {
        
        VStack(spacing: 12){
            
            Text("Edit Task")
                .font(.title3.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    Button {
                        environment.dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title3)
                            .foregroundColor(.black)
                    }

                }
                .overlay(alignment: .trailing){
                    Button {
                        if let editTask = model.editTask{
                            environment.managedObjectContext.delete(editTask)
                            try? environment.managedObjectContext.save()
                            environment.dismiss()
                        }
                        
                    } label: {
                        Image(systemName: "trash")
                            .font(.title3)
                            .foregroundColor(.red)
                    }
                    .opacity(model.editTask == nil ? 0 : 1)
                }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Task Color")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                // MARK: Sample card colors
                let colors: [String] = ["Yellow", "Green", "Blue", "Purple", "Red", "Orange"]
                
                
                HStack(spacing: 12){
                    ForEach(colors, id: \.self){ color in
                        Circle()
                            .fill(Color(color))
                            .frame(width: 25, height: 25)
                            .background{
                                if model.taskColor == color{
                                    Circle()
                                        .strokeBorder(.gray)
                                        .padding(-5)
                                        
                                }
                            }
                            .contentShape(Circle())
                            .onTapGesture {
                                model.taskColor = color
                            }
                    }
                }
                .padding(.top, 10)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 30)
            
            Divider()
                .padding(.vertical, 10)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Task Deadline")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(model.taskDeadline.formatted(date: .abbreviated, time: .shortened))
                    .font(.callout)
                    .fontWeight(.semibold)
                    .padding(.top, 8)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay(alignment: .bottomTrailing) {
                Button {
                    model.showDatePicker.toggle()
                } label: {
                    Image(systemName: "calendar")
                        .foregroundColor(.black)
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Task Title")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                TextField("", text: $model.taskTitle)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)
                
            }
            .padding(.top, 10)
            
            Divider()
            
            // MARK: Sample Task Types
            let taskTypes: [String] = ["Basic", "Urgent", "Important"]
            VStack(alignment: .leading, spacing: 12) {
                Text("Task Type")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                HStack(spacing: 12){
                    ForEach(taskTypes, id: \.self){ type in
                        
                        Text(type)
                            .font(.callout)
                            .fontWeight(.semibold)
                            .padding(.vertical,8)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(model.taskType == type ? .white : .black)
                            .background{
                                if model.taskType == type{
                                    Capsule()
                                        .fill(.black)
                                        .matchedGeometryEffect(id: "TYPE", in: animation)
                                }else{
                                    Capsule()
                                        .strokeBorder(.black)
                                }
                            }
                            .contentShape(Capsule())
                            .onTapGesture {
                                withAnimation(.linear(duration: 0.3)){
                                    model.taskType = type
                                }
                            }
                    }
                }
                .padding(.top,8)
                
            }
            .padding(.vertical, 10)
            
            Divider()
            
            // MARK: Save Button
            
            Button {
                // MARK: If Success Closing View
                if model.addTask(context: environment.managedObjectContext){
                    environment.dismiss()
                }
            } label: {
                Text("Save Task")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .foregroundColor(.white)
                    .background{
                        Capsule()
                            .fill(.black)
                    }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 10)
            .disabled(model.taskTitle == "")
            .opacity(model.taskTitle == "" ? 0.6 : 1)

            
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
        .overlay {
            ZStack{
                if model.showDatePicker{
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                        .onTapGesture {
                            model.showDatePicker = false
                        }
                    
                    // MARK: Disabling Past Dates
                    DatePicker.init("", selection: $model.taskDeadline, in: Date.now...Date.distantFuture)
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                        .padding()
                        .background(.white, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .padding()
                }
            }
            .animation(.easeInOut, value: model.showDatePicker)
        }
    }
}

struct AddNewTask_Previews: PreviewProvider {
    static var previews: some View {
        AddNewTask()
            .environmentObject(TaskViewModel())
    }
}
