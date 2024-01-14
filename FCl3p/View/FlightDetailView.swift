//
//  FlightDetailView.swift
//  FCl3p
//
//  Created by Eleazar Geneste on 10/11/23.
//

import SwiftUI

struct FlightDetailView: View {
    
    let num_post = [0,1,2,3,4,5,6,7,8,9,10]
    let alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    let embedType = ["none", "plate", "sleeve"]
    let pattern_schema : String = "0.0, 0/0, 0-0, 0 0-0"
    
    let title_width = 160.0
    let id_width = 160.0
    let wheel_dim = WheelSize()
    
    @Bindable var flight: Flight

    
    
    @FocusState private var focusedField: Field?
    @FocusState private var isFocusedLfp: Int?
    @FocusState private var isFocusedUfp: Int?
    @FocusState private var isFocusedBaluster: Int?
    
    @State var lfpPostCount: Int
    @State var ufpPostCount: Int
    @State var balusterCount: Int
    @State private var tempLfp : Int = 0
    
   
    @Binding var validData : Bool
    
    var body: some View {
        List {
            // FIRST SECTION
            Section{
                HStack{
                    Text("Riser :").frame(width: title_width, alignment: .leading)
                        .font(.headline)
                    TextField("Riser", text: $flight.riser, prompt: Text(pattern_schema))
                        .inputText
                        .focused($focusedField, equals: .riser)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(focusedField == .riser && !checkFields(flight.riser, for: "riser") ? Color.red : Color.secondary.opacity(0.7))
                        )
                }
                
                HStack{
                    Text("Bevel :").frame(width: title_width, alignment: .leading)
                        .font(.headline)
                    TextField("Bevel", text: $flight.bevel, prompt: Text(pattern_schema))
                        .inputText
                        .focused($focusedField, equals: .bevel)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(focusedField == .bevel && !checkFields(flight.bevel, for: "bevel") ? Color.red : Color.secondary.opacity(0.7))
                        )
                    //Text("in.")
                }
                
                HStack{
                    Text("Last Nose :").frame(width: title_width, alignment: .leading)
                        .font(.headline)
                    TextField("lastNose", text: $flight.lastNose, prompt: Text(pattern_schema))
                        .inputText
                        .focused($focusedField, equals: .lastNose)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(focusedField == .lastNose && !checkFields(flight.lastNose, for: "lastNose") ? Color.red : Color.secondary.opacity(0.7))
                        )
                }
                
                HStack{
                    Text("Nose Post Center :").frame(width: title_width, alignment: .leading)
                        .font(.headline)
                    TextField("ntp", text: $flight.noseToPost, prompt: Text(pattern_schema))
                        .inputText
                        .focused($focusedField, equals: .noseToPost)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(focusedField == .noseToPost && !checkFields(flight.noseToPost, for: "noseToPost") ? Color.red : Color.secondary.opacity(0.7))
                        )
                }
                
            } // END FIRST SECTION
            
            // BOTTOM CROTCH SECTION
            Section {
                Toggle("Bottom Crotch :", isOn: $flight.bottomCrotch.exist.animation())
                    .onChange(of: flight.bottomCrotch.exist, { _, newValue in
                        if newValue {
                            let total = flight.lfpPosts.reduce(0.0) { result, post in
                                result + post.dDistance
                            }
                            
                            if total >= flight.bottomCrotch.dDistance {
                                flight.bottomCrotch.distance = String(total + 18.0)
                            }
                        } else {
                            flight.bottomCrotch.hasPost = false
                        }
                        
                        
                    })
                    .font(.headline)
                    .tint(Color.secondary)
                
                if flight.bottomCrotch.exist{
                    Section {
                        HStack{
                            Text("Distance :").frame(width: title_width, alignment: .leading)
                                .font(.headline)
                            TextField("", text: $flight.bottomCrotch.distance, prompt: Text(pattern_schema))
                                .inputText
                                .focused($focusedField, equals: .bottomCrotch)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(focusedField == .bottomCrotch && !checkFields(flight.bottomCrotch.distance, for: "bottomCrotch") ? Color.red : Color.secondary.opacity(0.7) )
                                )
                        }
                        
                        Toggle("Has Post :", isOn: $flight.bottomCrotch.hasPost)
                            .font(.headline)
                            .tint(Color.secondary)
                    }
                }
            } header: {
                Text("Bottom Crotch")
            } // END BOTTOM CROTCH SECTION
            
            // LOWER FLAT POST
            Section ("Lower Flat Post") {
                
                Picker("Quantity :", selection: $lfpPostCount) {
                    ForEach(0...10, id: \.self) {
                        Text("\($0)")
                    }
                }.disabled(!validData)
                    .font(.headline)
                    .onChange(of: lfpPostCount, { oldValue, newValue in
                        if newValue > flight.lfpPosts.count {
                            for i in flight.lfpPosts.count..<newValue {
                                flight.lfpPosts.append(Post(name: "B\(i+1)"))
                            }
                        } else if newValue < flight.lfpPosts.count {
                            while flight.lfpPosts.count > newValue {
                                flight.lfpPosts.removeLast()
                            }
                        }
                        
                        // If user want to add new post after and bottom Crotch exist;  prevent sum post distance
                        // to be greter than bc distance
                        if flight.bottomCrotch.exist {
                            for index in 0..<newValue {
                                let cumulative = flight.lfpPosts[0...index].reduce(0.0) { result, post in
                                    result + post.dDistance }
                                
                                if cumulative > flight.bottomCrotch.dDistance {
                                    lfpPostCount = index
                                    break
                                }
                            }
                        }
                    })
                
                if lfpPostCount > 0 {
                    HStack{
                        Text("ID")
                            .frame(maxWidth: id_width, alignment: .leading)
                        Text("Distance")
                            .frame(maxWidth: 120, alignment: .center)
                        Spacer()
                    }.font(.headline)
                    
                    ForEach(Array(flight.lfpPosts.enumerated()), id:\.1.id) { index, post in
                        HStack {
                            HStack{
                                Text(post.name)
                                Spacer()
                            }
                            .frame(maxWidth: id_width)
                            .multilineTextAlignment(.leading)
                            TextField("", text: $flight.lfpPosts[index].distance, prompt: Text(pattern_schema))
                                .inputText
                                .focused($isFocusedLfp, equals: index)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(isFocusedLfp == index && !checkFields(flight.lfpPosts[index].distance, for: "lfpPost", index: index) ? Color.red : Color.secondary.opacity(0.7))
                                )
                            Spacer()
                        }
                    }
                    HStack {
                        Text("Embedded Type :")
                            .font(.headline)
                            .frame(width: title_width, alignment: .leading)
                        
                        Picker("", selection: $flight.lfpEmbType) {
                            ForEach(EmbeddedType.allCases) {embT in
                                Text(embT.rawValue)
                                    .tag(embT)
                            }
                        }.labelsHidden()
                            .padding(.horizontal, -10)
                        Spacer()
                    }
                }
            } // END LOWER FLAT POST
            
            // TOP CROTCH SECTION
            Section("Top Crotch") {
                Toggle("Top Crotch :", isOn: $flight.topCrotch.exist.animation())
                    .onChange(of: flight.topCrotch.exist, { _, newValue in
                        if newValue {
                            let total = flight.ufpPosts.reduce(0.0) { result, post in
                                result + post.dDistance
                            }
                            
                            if total >= flight.topCrotch.dDistance {
                                flight.topCrotch.distance = String(total + 18.0)
                            }
                            
                            //                                if flight.topCrotch.dDistance < 12 {
                            //                                    flight.topCrotch.distance = "12.0"
                            //                                }
                        } else {
                            flight.topCrotch.hasPost = false
                        }
                    })
                    .font(.headline)
                    .tint(Color.secondary)
                
                if flight.topCrotch.exist {
                    Section {
                        HStack{
                            Text("Distance :").frame(width: title_width, alignment: .leading)
                                .font(.headline)
                            TextField("", text: $flight.topCrotch.distance, prompt: Text(pattern_schema))
                                .inputText
                                .focused($focusedField, equals: .topCrotch)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(focusedField == .topCrotch && !checkFields(flight.topCrotch.distance, for: "topCrotch")  ? Color.red : Color.secondary.opacity(0.7))
                                )
                        }
                        
                        Toggle("Has Post :", isOn: $flight.topCrotch.hasPost)
                            .font(.headline)
                            .tint(Color.secondary)
                    }
                }
            } // END TOP CROTCH SECTION
            
            // UPPER FLAT POST
            Section ("UpperFlat Post") {
                Picker("Quantity :", selection: $ufpPostCount) {
                    ForEach(0...10, id: \.self) {
                        Text("\($0)")
                    }
                }.disabled(!validData)
                    .font(.headline)
                    .padding(.horizontal, 0)
                    .onChange(of: ufpPostCount, { _, newValue in
                        if newValue > flight.ufpPosts.count {
                            for i in flight.ufpPosts.count..<newValue {
                                flight.ufpPosts.append(Post(name: "U\(i+1)"))
                            }
                        } else if newValue < flight.ufpPosts.count {
                            while flight.ufpPosts.count > newValue {
                                flight.ufpPosts.removeLast()
                            }
                        }
                        // If user want to add new post after and top Crotch exist;  prevent sum post distance
                        // to be greter than tc distance
                        if flight.topCrotch.exist {
                            for index in 0..<newValue {
                                let cumulative = flight.ufpPosts[0...index].reduce(0.0) { result , post in
                                    result + post.dDistance
                                }
                                if cumulative > flight.topCrotch.dDistance {
                                    ufpPostCount = index
                                    break
                                }
                            }
                        }
                    })
                
                
                if ufpPostCount > 0 {
                    HStack(alignment: .top){
                        Text("ID")
                            .frame(maxWidth: id_width, alignment: .leading)
                        //Spacer()
                        Text("Distance")
                            .frame(maxWidth: 120.0, alignment: .center)
                        Spacer()
                        
                    }.font(.headline)
                    
                    ForEach(Array(flight.ufpPosts.enumerated()), id:\.1.id) { index, post in
                        HStack {
                            HStack{
                                Text(post.name)
                                Spacer()
                            }
                            .frame(maxWidth: id_width)
                            .multilineTextAlignment(.leading)
                            //Spacer()
                            TextField("", text: $flight.ufpPosts[index].distance, prompt: Text(pattern_schema))
                                .inputText
                                .focused($isFocusedUfp, equals: index)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(isFocusedUfp == index && !checkFields(flight.ufpPosts[index].distance, for: "ufpPost", index: index) ? Color.red : Color.secondary.opacity(0.7) )
                                )
                            Spacer()
                        }
                    }
                    
                    HStack {
                        Text("Embedded Type :")
                            .font(.headline)
                            .frame(width: title_width, alignment: .leading)
                        Picker("", selection: $flight.ufpEmbType) {
                            ForEach(EmbeddedType.allCases) {embT in
                                Text(embT.rawValue)
                                    .tag(embT)
                            }
                        }
                        .labelsHidden()
                        .padding(.horizontal, -10)
                        //Spacer()
                    }
                    //.frame(maxWidth: 200.0)
                }
            }  // END UPPER FLAT POST
            
            // BALUSTERS
            Section("Balusters") {
                Picker("Quantity :", selection: $balusterCount) {
                    ForEach(0...26, id: \.self) {
                        Text("\($0)")
                    }
                }.disabled(!validData)
                    .font(.headline)
                    .onChange(of: balusterCount, { _, newValue in
                        
                        if newValue > flight.balusters.count {
                            for i in flight.balusters.count..<newValue {
                                flight.balusters.append(Baluster(name: alphabet[i]))
                            }
                        } else if newValue < flight.balusters.count  {
                            while flight.balusters.count > newValue {
                                flight.balusters.removeLast()
                            }
                        }
                    })
                
                if balusterCount > 0 {
                    HStack(alignment: .top) {
                        Text("Id")
                            .frame(maxWidth: title_width, alignment: .leading)
                        
                        Text("Distance")
                            .frame(maxWidth: 120, alignment: .center)
                        Spacer()
                    }
                    .font(.headline)
                    
                    ForEach(Array(flight.balusters.enumerated()), id:\.1.id) { index,  baluster in
                        
                        HStack {
                            HStack{
                                Text(baluster.name)
                                Spacer()
                            }
                            .frame(maxWidth: title_width)
                            .multilineTextAlignment(.leading)
                            
                            TextField("", text: $flight.balusters[index].distanceFirstNose,
                                      prompt: Text(pattern_schema)
                            )
                            .inputText
                            .focused($isFocusedBaluster, equals: index)
                            
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(isFocusedBaluster == index && !checkFields(flight.balusters[index].distanceFirstNose, for: "baluster", index: index) ? Color.red : Color.secondary.opacity(0.7))
                            )
                            Spacer()
                        }
                    }
                    
                    HStack {
                        Text("Embedded Type :")
                            .font(.headline)
                            .frame(width: title_width, alignment: .leading)
                        Picker("", selection: $flight.balusterEmbType) {
                            ForEach(EmbeddedType.allCases) {embt in
                                Text(embt.rawValue)
                                    .tag(embt)
                            }
                        }.labelsHidden()
                            .padding(.horizontal, -10)
                        //.pickerStyle(.wheel)
                    }
                }
            } // END BALUSTER
        }
        .onChange(of: focusedField,  { oldFocus , newValue in
            
            if oldFocus != nil {
                switch oldFocus {
                case .riser:
                    if !checkFields(flight.riser, for: "riser") {
                        focusedField = oldFocus
                        validData = false
                        return
                    }
                case .bevel:
                    if !checkFields(flight.bevel, for: "bevel") {
                        focusedField = oldFocus
                        validData = false
                        return
                    }
                case .lastNose:
                    if !checkFields(flight.lastNose, for: "lastNose") {
                        focusedField = oldFocus
                        validData = false
                        return
                    }
                case .noseToPost:
                    if !checkFields(flight.lastNose, for: "noseToPost") {
                        focusedField = oldFocus
                        validData = false
                        return
                    }
                case .bottomCrotch:
                    if !checkFields(flight.bottomCrotch.distance, for: "bottomCrotch") {
                        focusedField = oldFocus
                        validData = false
                        return
                    }
                case .topCrotch:
                    if !checkFields(flight.topCrotch.distance, for: "topCrotch") {
                        focusedField = oldFocus
                        validData = false
                        return
                    }
                default:
                    print(oldFocus as Any)
                }
            }
            
            switch focusedField {
            case .riser:
                flight.riser = ""
                validData = false
                return
            case .bevel:
                flight.bevel = ""
                validData = false
                return
            case .lastNose:
                flight.lastNose = ""
                validData = false
                return
            case .noseToPost:
                flight.noseToPost = ""
                validData = false
                return
            case .bottomCrotch:
                flight.bottomCrotch.distance = ""
                validData = false
                return
            case .topCrotch:
                flight.topCrotch.distance = ""
                validData = false
                return
            default:
                print(oldFocus as Any)
                break
            }
            
            
            validData = true
        })
        .onChange(of: isFocusedLfp, { oldFocus ,  newValue in
            
            if oldFocus != nil {
                if !checkFields(flight.lfpPosts[oldFocus!].distance, for: "lfpPost") {
                    isFocusedLfp = oldFocus
                    validData = false
                    return
                }
            }
            
            if newValue != nil {
                flight.lfpPosts[newValue!].distance = ""
                validData = false
                return
            }
            validData = true
            
        })
        .onChange(of: isFocusedUfp, { oldFocus ,  newValue in
            
            if oldFocus != nil {
                if !checkFields(flight.ufpPosts[oldFocus!].distance, for: "ufpPost") {
                    isFocusedUfp = oldFocus
                    validData = false
                    return
                }
            }
            
            if newValue != nil {
                flight.ufpPosts[newValue!].distance = ""
                validData = false
                return
            }
            validData = true
        })
        .onChange(of: isFocusedBaluster, { oldFocus , newValue in
            
            if oldFocus != nil {
                if !checkFields(flight.balusters[oldFocus!].distanceFirstNose, for: "baluster", index: oldFocus!) {
                    isFocusedBaluster = oldFocus
                    validData = false
                    return
                }
            }
            if newValue != nil {
                flight.balusters[newValue!].distanceFirstNose = ""
                validData = false
                return
            }
            validData = true
        })
   
    }
    
    func checkFields(_ input: String, for name: String, index : Int = 1000) -> Bool {
        
        switch name {
            
        case "riser":
            guard isValidInput(input: input) else {
                focusedField = .riser
                return false
            }
            
            if flight.dRiser > 8 ||  flight.dRiser < 5 {
                focusedField = .riser
                return false
            }
            
        case "bevel":
            guard isValidInput(input: input) else {
                focusedField = .bevel
                return false
            }
            if flight.dBevel > 8 ||  flight.dBevel < 5 {
                focusedField = .bevel
                return false
            }
            
        case "lastNose":
            guard isValidInput(input: input) else {
                focusedField = .lastNose
                return false
            }
            
            if flight.dLastNose < 13 {
                focusedField = .lastNose
                return false
            }
            
            if flight.balusters.count > 0 {
                let totalSteps = Int (round(flight.dLastNose / sqrt(144 + (flight.dRiser * flight.dRiser))))
                let lastBaluster = Int (round(flight.balusters.last!.dDistanceFirstNose / sqrt(144 + (flight.dRiser * flight.dRiser))))
                
                if totalSteps <= lastBaluster {
                    focusedField = .lastNose
                    return false
                }
            }
            
        case "noseToPost":
            guard isValidInput(input: input) else {
                focusedField = .noseToPost
                return false
            }
            
            if flight.dNoseToPost > 6.5 || flight.dNoseToPost < 5.0 {
                focusedField = .noseToPost
                return false
            }
        case "bottomCrotch":
            guard isValidInput(input: input) else {
                focusedField = .bottomCrotch
                return false
            }
            let total = flight.lfpPosts.reduce(0.0) { partialResult, post in
                partialResult + post.dDistance
            }
            
            if total > 0 && total >= flight.bottomCrotch.dDistance {
                focusedField = .bottomCrotch
                return false
            }
            
        case "topCrotch":
            guard isValidInput(input: input) else {
                focusedField = .topCrotch
                return false
            }
            
            let total = flight.ufpPosts.reduce(0.0) { partialResult, post in
                partialResult + post.dDistance
            }
            
            if total > 0 && total >= flight.topCrotch.dDistance {
                focusedField = .topCrotch
                return false
            }
            
        case "lfpPost":
            guard isValidInput(input: input) else {
                isFocusedLfp = index
                return false
            }
            
            // sum of lower flat post must not me greater or equal to bottom crotch distance
            if flight.bottomCrotch.exist{
                let total = flight.lfpPosts.reduce(0.0) { partialResult, post in
                    partialResult + post.dDistance
                }
                if total > flight.bottomCrotch.dDistance {
                    isFocusedLfp = index
                    return false
                }
            }
            
            
            
        case "ufpPost":
            guard isValidInput(input: input) else {
                isFocusedUfp = index
                return false
            }
            
            // sum of upper flat post must not me greater or equal to top crotch distance
            if flight.topCrotch.exist {
                let total = flight.ufpPosts.reduce(0.0) { partialResult, post in
                    partialResult + post.dDistance
                }
                
                if total >= flight.topCrotch.dDistance {
                    isFocusedUfp = index
                    return false
                }
            }
            
            if flight.ufpPosts.count > 0 && flight.ufpPosts.first!.dDistance < 0 {
                isFocusedUfp = index
                return false
            }
            
        case "baluster":
            guard isValidInput(input: input) else {
                isFocusedBaluster = index
                return false
            }
            
            if flight.balusters.count > 0 {
                let totalSteps = Int(round(flight.dLastNose / sqrt(144 + (flight.dRiser * flight.dRiser))))
                
                let balusterStep = Int(round(flight.balusters[index].dDistanceFirstNose / sqrt(144 + (flight.dRiser * flight.dRiser))))
                
                if  balusterStep >= totalSteps || flight.balusters[index].dDistanceFirstNose > flight.dLastNose {
                    isFocusedBaluster = index
                    return false
                }
            }
            
            
        default:
            print("No implemantation for case : \(name)")
            
        }
        
        return true
    }
    
    func isValidInput(input: String) -> Bool {
        let patterns = [//"^$", // Matches ""
            "^\\d+$", // Matches "3"
            "^\\d+\\.\\d{1,4}$", // Matches "3.30"
            "^\\d+\\-\\d{1,2}$", // Matches "3-0"
            "^\\d+\\s\\d{1,2}/\\d{1,2}$", // Matches "3 6/4"
            "^\\d+-\\d{1,2}\\s\\d{1,2}$", // Matches "3-0 5"
            "^\\d+-\\d{1,2}\\s\\d{1,2}/\\d{1,2}$", // Matches "3-0 5/2"
            "^\\d{1,2}/\\d{1,2}$", // Matches "3/2"
        ]
        
        return patterns.contains { pattern in
            let regex = try! NSRegularExpression(pattern: pattern)
            let range = NSRange(location: 0, length: input.utf16.count)
            return regex.firstMatch(in: input, options: [], range: range) != nil
        }
    }
    
    func isValidForm () -> Bool {
        
        if focusedField != nil || isFocusedLfp != nil || isFocusedUfp != nil || isFocusedBaluster != nil  {
            flight.valid = false
            
            return false
        }
        
        return true
    }
    
}


struct CustomTextField : ViewModifier {
    let textboxWidth = 100.0
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: textboxWidth)
            .padding(EdgeInsets(top: 10, leading: 15, bottom: 5, trailing: 10))
            .keyboardType(.numbersAndPunctuation)
    }
}
extension View {
    var inputText : some View {
        modifier(CustomTextField())
    }
}

enum Field: String, Hashable {
    case riser = "Riser"
    case bevel = "Bevel"
    case lastNose = "LastNose"
    case bottomCrotch = "bottomCrotch"
    case topCrotch = "topCrotch"
    case noseToPost = "noseToPost"
}

struct WheelSize {
    let width = 125.0
    let height = 40.0
}

//#Preview {
//    FlightDetailView()
//}
