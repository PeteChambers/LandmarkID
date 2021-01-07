//
//  Extension-UIViewController.swift
//  Landmark ID
//
//  Created by Pete Chambers on 04/01/2021.
//  Copyright © 2020 Pete Chambers. All rights reserved.
//

import UIKit

extension UIViewController {
    // alert message
    func alert(message: String, title: String = "", buttonTitle : String = "Ok") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alertChoice(message: String, title: String = "", buttonOneTitle : String = "No", buttonTwoTitle : String = "Yes", handler: @escaping ((UIAlertAction) -> Void)) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let noAction = UIAlertAction(title: buttonOneTitle, style: .cancel, handler: nil)
        let yesAction = UIAlertAction(title: buttonTwoTitle, style: .destructive, handler: handler)
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
