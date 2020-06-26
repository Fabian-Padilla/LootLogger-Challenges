//
//  EditDate.swift
//  LootLogger
//
//  Created by Guillermo Padilla Lam on 23/06/20.
//  Copyright © 2020 gp Apps. All rights reserved.
//

import UIKit

class EditDateController : UIViewController {
    
    
    @IBOutlet weak var dateItem: UIDatePicker!
    
    
    var item: Item!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dateItem.setDate(item.dateCreated, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        item.dateCreated = dateItem.date
    }
}
