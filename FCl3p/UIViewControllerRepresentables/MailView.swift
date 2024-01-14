//
//  MailView.swift
//  FCl3p
//
//  Created by Eleazar Geneste on 10/11/23.
//

import SwiftUI
import UIKit
import MessageUI

// Credit for this struct goes to https://swiftuirecipes.com/blog/send-mail-in-swiftui

typealias MailViewCallback = ((Result<MFMailComposeResult, Error>) -> Void)?

struct MailView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentation
    @Binding var supportEmail: Mensajero
    let callback: MailViewCallback
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var presentation: PresentationMode
        @Binding var data: Mensajero
        let callback: MailViewCallback
        
        init(presentation: Binding<PresentationMode>,
             data: Binding<Mensajero>,
             callback: MailViewCallback) {
            _presentation = presentation
            _data = data
            self.callback = callback
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            if let error = error {
                callback?(.failure(error))
            } else {
                callback?(.success(result))
            }
            $presentation.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(presentation: presentation, data: $supportEmail, callback: callback)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let mvc = MFMailComposeViewController()
        mvc.mailComposeDelegate = context.coordinator
        mvc.setSubject(supportEmail.subject)
        mvc.setToRecipients([supportEmail.toAddress])
        mvc.setMessageBody(supportEmail.body, isHTML: false)
        //mvc.addAttachmentData(supportEmail.data!, mimeType: "text/plain", fileName: supportEmail.fileName)
        for (filename, data) in supportEmail.data {
            //mvc.addAttachmentData(data, mimeType: "text/plain", fileName: filename)
            mvc.addAttachmentData(data, mimeType: "application/json", fileName: filename.trimmingCharacters(in: .whitespacesAndNewlines) + ".json")
            //mvc.addAttachmentData(data, mimeType: "application/pdf", fileName: filename)
        }
        
        mvc.accessibilityElementDidLoseFocus()
        return mvc
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {
    }
    
    static var canSendMail: Bool {
        MFMailComposeViewController.canSendMail()
    }
}

