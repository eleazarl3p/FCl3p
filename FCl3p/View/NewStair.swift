//
//  NewStair.swift
//  FCl3p
//
//  Created by Eleazar Geneste on 10/10/23.
//

import SwiftUI

struct NewStair: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var mc
    
    @State private var stairName : String = ""
    
    @Bindable var project : Project
    
    enum FocusField: Hashable {
        case field
    }
    
    @FocusState private var focusedField: FocusField?
    
    var body: some View {
        
        NavigationStack {
            Form {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(Color(.label))
                    }
    
                }
                .listRowSeparator(.hidden)
                
                TextField("Stair Identifier", text: $stairName)
                                .padding(.horizontal, 10)
                                .frame(height: 50)
                                .background(.gray.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 5)))
                
                                .focused($focusedField, equals: .field)
                                .onAppear {
                                    self.focusedField = .field
                                }
                
                HStack {
                    Spacer()
                    Button ("Add") {
                        if !stairName.isEmpty {
                            let newStair = Stair(name: stairName)
                            withAnimation {
                                project.add(newStair)
                            }
    
                            dismiss()
                        }
                    }
                    .buttonStyle(.bordered)
                    .accentColor(Color(.label))
                    .disabled(stairName.isEmpty)
                    Spacer()
                }
                .listRowSeparator(.hidden)
                .padding(10)
    
            }
        }

    }
}

//#Preview {
//    NewStair()
//}
