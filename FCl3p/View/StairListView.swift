//
//  StairListView.swift
//  FCl3p
//
//  Created by Eleazar Geneste on 10/10/23.
//

import SwiftUI
import SwiftData
import MessageUI


class EmailHelper: NSObject {
    // singleton
    static let shared = EmailHelper()
    private override init() {}
}

struct StairListView: View {
    @Environment(\.modelContext) var mc
    
    @Bindable var project : Project
    
    @State private var showNewStair = false
    @State var showMail = false
    @State var mensajero = Mensajero(toAddress: "egenestel3p@gmail.com", subject: "Field Check", messageHeader: "In Attach ...")
    
    
    var sortedStairs : [Stair] {
        project.stairs.sorted(by: { a, b in
            a.dateCreated  > b.dateCreated
        })
    }
    
    var body: some View {
        VStack{
            List {
                Section ("Stairs"){
                    ForEach(sortedStairs) { stair in
                        NavigationLink(value: stair) {
                            HStack {
                                Toggle(isOn: Binding(get: { stair.toSend }, set: { value in
                                    stair.toSend = value
                                })) {
                                    
                                }.buttonStyle(BorderlessButtonStyle())
                                    .tint(Color.secondary)
                                    .frame(maxWidth: 50)
                                    .padding(.trailing, 15)
                                    .padding(.leading, -15)
                                
                                Button(action: {
                                    withAnimation {
                                        project.add(stair.copy())
                                    }
                                }, label: {
                                    Label("Copy", systemImage: "doc.on.doc")
                                }).buttonStyle(BorderlessButtonStyle())
                                Spacer()
                                Item(name: stair.name, dateCreated: stair.dateCreated)
                            }
                            
                        }
                    }
                    .onDelete(perform: { indexSet in
                        for index in indexSet {
                            project.stairs.remove(at: index)
                        }
                    })
                }
            }
            
            Button {
                let stairToSend = project.stairs.filter { stair in
                    stair.toSend == true
                }

                if !stairToSend.isEmpty {
                    let encoder = JSONEncoder()
                    encoder.outputFormatting = JSONEncoder.OutputFormatting.sortedKeys.union([.withoutEscapingSlashes, .prettyPrinted])
                    
                    mensajero.body = "Project : \(project.name) \n\n Stairs : "
                    
                    do {
                        for stair in stairToSend {
                            let jsonData = try? encoder.encode(stair)
                            mensajero.data[stair.name] = jsonData
                            mensajero.body += " \(stair.name), "
                        }
                        
                        if MailView.canSendMail {
                            showMail.toggle()
                        } else {
                            let jsonData = try encoder.encode(stairToSend.last)
                            if let jsonString = String(data: jsonData, encoding: .utf8) {
                                print(jsonString)
                            }
                        }
                        
                    } catch {
                        print("Error converting json string")
                    }
                }
            } label: {
                Label("Send", systemImage: "paperplane.fill")
                    .foregroundColor(Color(.label))
            }

        }
        .navigationTitle($project.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Stair.self, destination: { stair in
            FlightListView(stair: stair)
        })
        .toolbar(content: {
            ToolbarItem {
                Button(action: {
                    showNewStair.toggle()
                }, label: {
                    Image(systemName: "plus")
                })
            }
        })
        .sheet(isPresented: $showNewStair) {
            NewStair(project: project)
                .presentationDetents([.medium])
        }
    }
}

//#Preview {
//    StairListView(project: Project(name: ""))
//        .modelContainer(for: Project.self)
//}
    
