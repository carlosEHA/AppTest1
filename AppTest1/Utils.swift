//
//  Utils.swift
//  AppTest1
//
//  Created by Carlos Eduardo Hernandez Aguilar on 05/05/18.
//  Copyright © 2018 Carlos Eduardo Hernandez Aguilar. All rights reserved.
//

import Foundation
import UIKit

class Utils{
}
extension UIViewController{
    func createAlert(view_controller: UIViewController, title: String, message: String) {
        let alertC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Aceptar", style: .default) { (action) in
        }
        alertC.addAction(OKAction)
        view_controller.present(alertC, animated: true, completion: nil)
    }
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}



