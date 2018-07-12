//
//  ViewController.swift
//  Bitcoin Price Tracker
//
//  Created by Vaibhav Nandam on 7/12/18.
//  Copyright © 2018 Vaibhav Nandam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let symbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""
    var symbol = ""
  
    

    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        symbol = symbolArray[row]
        getCurrency(url: finalURL)
    }
    
    // MARK: Networking
    
    func getCurrency(url : String) {
        Alamofire.request(finalURL, method: .get).responseJSON { response in
            if response.result .isSuccess {
                print("got the result")
                let jsonValue = JSON(response.result.value!)
                self.parseCurrencyValue(json: jsonValue)
                
            }else{
                print("\(String(describing: response.error))")
            }
        }
    }
    
    // MARK: JSON Parsing
    
    func parseCurrencyValue(json : JSON) {
        let currencyValue = json ["ask"].double
        print(currencyValue!)
        updateUI(finalValue: currencyValue!)
        
    }
    
    
    func updateUI(finalValue : Double) {
        currencyLabel.text = symbol + "\(finalValue)"
        
    }


}

