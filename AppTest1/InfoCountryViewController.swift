//
//  InfoCountryViewController.swift
//  AppTest1
//
//  Created by Carlos Eduardo Hernandez Aguilar on 05/05/18.
//  Copyright © 2018 Carlos Eduardo Hernandez Aguilar. All rights reserved.
//

import Foundation
import UIKit

class InfoCountryViewController: UIViewController, UITextFieldDelegate{
    
    var infoCountry: NSDictionary = [:]
    var urlHelp:String = ""
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var urlHelpOutlet: UIButton!
    
    @IBAction func urlHelpBtn(_ sender: Any) {
        if(!urlHelp.isEmpty){
            let url = URL(string: urlHelp)
            UIApplication.shared.open(url!, options: [:])
        }
    }
    @IBAction func acceptBtn(_ sender: Any) {
        let inputType = self.inputField.text as! String
        let pattern:String = self.infoCountry.value(forKey: "pattern") as! String
        
        if validInput(inputType, pattern){
            self.createAlert(view_controller: self, title: "", message: "Datos correctos.")
        }else{
            self.createAlert(view_controller: self, title: "Error", message: "La información no cumple con el formato correcto.")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Información de pais:\(self.infoCountry)")
        self.hideKeyboard()
        self.inputField.delegate = self
        let inputType:String = self.infoCountry.value(forKey: "input_type") as! String
        self.setKeyboard(inputType: inputType)
        self.setData()
    }
    
    func setData(){
        if let url = (self.infoCountry.value(forKey: "help_url") as? String){
            self.urlHelp = url
            self.urlHelpOutlet.setTitle(url,for: .normal)
        }
        if let nameInput = (self.infoCountry.value(forKey: "name") as? String){
            self.inputField.placeholder = nameInput
        }
    }
    
    func validInput(_ inputText: String, _ pattern: String) -> Bool {
        let stringTest = NSPredicate(format:"SELF MATCHES %@", pattern)
        let result = stringTest.evaluate(with: inputText)
        return result
    }
    
    func setKeyboard(inputType: String){
        if(inputType == "number"){
            self.inputField.keyboardType = .numberPad
        }else if(inputType == "capital"){
            self.inputField.autocapitalizationType = .allCharacters
        }else{
            self.inputField.keyboardType = .default
        }
    }
}
