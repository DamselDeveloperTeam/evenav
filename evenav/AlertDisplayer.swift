//
//  AlertDisplayer.swift
//  evenav
//
//  Copyright © 2018 Koulutus. All rights reserved.
//

import Foundation
import UIKit


class AlertDisplayer {
    static var viewToDisplayAlert: UIViewController? = nil;
    
    static func noInternetConnectionRouteAlert() {
        DispatchQueue.main.async {
            let alertMessage = UIAlertController(title: "Internet Connection Unavailable", message: "Sorry, route finding is not available because there is no internet connection", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.viewToDisplayAlert?.present(alertMessage, animated: true, completion: nil)
        }
    }
    
    static func customAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alertMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.viewToDisplayAlert?.present(alertMessage, animated: true, completion: nil)
        }
    }
    
    static func syncAlert(title: String, message: String) {
        let alertMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.viewToDisplayAlert?.present(alertMessage, animated: true, completion: nil)
    }
    
}
