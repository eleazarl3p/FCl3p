//
//  ContentView.swift
//  FCl3p
//
//  Created by Eleazar Geneste on 10/10/23.
//

import SwiftUI
import SwiftData

struct ProjectListView: View {
    @Environment(\.modelContext) var mc
    @State var showNewProject = false
    
    @Query(sort: \Project.dateCreated, order: .reverse) var projects : [Project]
    
    //@State private var path : [Project] = []
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(projects) { project in
                    NavigationLink(value: project) {
                        HStack {
                            Button(action: {
                                withAnimation {
                                    mc.insert(project.copy())
                                }
                                
                            }, label: {
                                Label("Copy", systemImage: "doc.on.doc")
                            }).buttonStyle(BorderlessButtonStyle())
                            Spacer()
                            Item(name: project.name, dateCreated: project.dateCreated)
                            
                        }
                    }
                }
                .onDelete(perform: deleteProject)
            }
            .navigationTitle("📜 Projects")
            .navigationDestination(for: Project.self) { project in
                StairListView(project: project)
            }
            .toolbar {
                ToolbarItemGroup {
                    Button {
                        showNewProject.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                    
                }
                
            }
            .sheet(isPresented: $showNewProject) {
                NewProject()
                    .presentationDetents([.medium])
            }
            
        }
    }
    
    func deleteProject(_ indexset : IndexSet) {
        for index in indexset {
            let project = projects[index]
            mc.delete(project)
        }
    }
}

#Preview {
    NavigationStack {
        ProjectListView()
    }
}
