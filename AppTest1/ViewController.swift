//
//  ViewController.swift
//  AppTest1
//
//  Created by Carlos Eduardo Hernandez Aguilar on 05/05/18.
//  Copyright © 2018 Carlos Eduardo Hernandez Aguilar. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var pickerTextField: UITextField!
    @IBOutlet weak var continueOutlet: UIButton!
    
    var countriesArray:[String] = []
    var countries:[NSDictionary] = []
    var countrieSelected: Int = 0
    var identification:NSDictionary = [:]
    
    @IBAction func continueBtn(_ sender: Any) {
        let code: String = loadCode(selected: countrieSelected)
        getCodeWebService(code: code)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPickerView()
        getCountryWebService()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func setPickerView(){
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.backgroundColor = UIColor.white
        toolBar.tintColor = UIColor(red: 63/255, green: 143/255, blue: 255/255, alpha: 1)
        toolBar.layer.borderWidth = 0
        toolBar.layer.borderColor = UIColor(red: 63/255, green: 143/255, blue: 255/255, alpha: 1).cgColor
        toolBar.clipsToBounds = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Aceptar", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ViewController.clicDone))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        pickerTextField.inputView = pickerView
        pickerTextField.inputAccessoryView = toolBar
        
        pickerView.showsSelectionIndicator = true
        pickerView.clipsToBounds = true
        pickerTextField.layer.cornerRadius = 10
        pickerView.backgroundColor? = UIColor.white
        pickerView.selectRow(0, inComponent: 0, animated: true)
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.countriesArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.countriesArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerTextField.text = self.countriesArray[row]
        self.countrieSelected = row
        print("Seleccionado: \(self.countrieSelected) y Row: \(row)")
    }
    
    func getCountryWebService(){
        let loader = MBProgressHUD.showAdded(to: self.view, animated: true)
        loader.mode = MBProgressHUDMode.indeterminate
        loader.label.text = "Cargando datos"
        
        let url = "http://labs.docademic.com:3010/api/catalog/country/"
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success:
                loader.hide(animated: true)
                print(response)
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    print("JSON:",JSON)
                    let data = JSON.value(forKey: "data") as? NSObject
                    self.countries = data?.value(forKey: "countries") as! [NSDictionary]
                    
                    print("Paises: \(self.countries)")
                    
                    for countrie in self.countries{
                        print("Data: \(countrie)")
                        print("Nombre: \(countrie.value(forKey: "name")!)")
                        let name = countrie.value(forKey: "name") as! String
                        self.countriesArray.append(name)
                    }
                }
                
            case .failure:
                loader.hide(animated: true)
                self.createAlert(view_controller: self, title: "Error", message: "Ocurrió un error cargando los datos.")
                
                break
            }
        }
    }
    
    func loadCode(selected: Int) -> String{
        
        var codeCountry: String = ""
        let code = self.countries[countrieSelected]
        
        codeCountry = code.value(forKey: "code") as! String
        
        return codeCountry
    }
    
    @objc func clicDone(){
        if(self.countrieSelected == 0){
            self.pickerTextField.text = self.countriesArray[self.countrieSelected]
        }
        self.continueOutlet.isEnabled = true
        self.view.endEditing(true)
    }
    
    func getCodeWebService(code: String){
        let loader = MBProgressHUD.showAdded(to: self.view, animated: true)
        loader.mode = MBProgressHUDMode.indeterminate
        loader.label.text = "Cargando información"
        
        let url = "http://labs.docademic.com:3010/api/catalog/country/id/\(code)"
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success:
                loader.hide(animated: true)
                print(response)
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    print("JSON:",JSON)
                    let data = JSON.value(forKey: "data") as? NSObject
                    self.identification = data?.value(forKey: "identification") as! NSDictionary
                    
                    if((self.identification .count) == 0){
                        self.createAlert(view_controller: self, title: "Error", message: "Este país no tiene información que mostrar.")
                    }else{
                        let destination = self.storyboard?.instantiateViewController(withIdentifier: "infoCountryViewController") as! InfoCountryViewController
                        destination.infoCountry = self.identification
                        self.show(destination, sender: nil)
                    }
                }
                
            case .failure:
                loader.hide(animated: true)
                self.createAlert(view_controller: self, title: "Error", message: "Este país no tiene información que mostrar.")
                break
            }
        }
    }
}
