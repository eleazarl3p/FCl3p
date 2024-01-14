//
//  Mensajero.swift
//  FCl3p
//
//  Created by Eleazar Geneste on 10/11/23.
//

import UIKit
import SwiftUI
struct Mensajero {
    let toAddress : String
    let subject : String
    let messageHeader : String
    var data = [String: Data]()
    //var data: Data?
    var fileName: String = ""
    var body : String = """
    Application : Field Check App
    
    """
    
    func send(openUrl: OpenURLAction) {
        let urlString = "mailto:\(toAddress)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")"
        guard let url = URL(string: urlString) else { return }
        openUrl(url) { accepted in
            if !accepted {
                print("""
                This device does not support email
                Body:\(body)
                """)
            } else {
                
            }
        }
    }
}
