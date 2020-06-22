//
//  DetailViewController.swift
//  LootLogger
//
//  Created by Guillermo Padilla Lam on 14/06/20.
//  Copyright © 2020 gp Apps. All rights reserved.
//

import UIKit

class DetailViewController : UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var serialField: UITextField!
    @IBOutlet weak var valueField: UITextField!
    @IBOutlet weak var dateField: UILabel!
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }()
    
    let dateFomatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.endEditing(true)
        
        nameField.text = item.name
        serialField.text = item.serialNumber
        valueField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
        dateField.text = dateFomatter.string(from: item.dateCreated)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        item.name = nameField.text ?? ""
        item.serialNumber = serialField.text
        
        if let valueText = valueField.text,
            let value = numberFormatter.number(from: valueText){
            
            item.valueInDollars = value.intValue
        }
        
    }
}

extension DetailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
