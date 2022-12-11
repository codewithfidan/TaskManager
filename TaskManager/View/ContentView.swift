//
//  ContentView.swift
//  TaskManager
//
//  Created by Fidan Oruc on 10.12.22.
//

import SwiftUI


struct ContentView: View {
    
    var body: some View {
        
        NavigationView{
            
            HomeView()
                .navigationTitle("Task Manager")
                .navigationBarTitleDisplayMode(.inline)
        }
        
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
