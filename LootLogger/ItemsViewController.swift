//
//  ItemsViewController.swift
//  LootLogger
//
//  Created by Guillermo Padilla Lam on 10/06/20.
//  Copyright © 2020 gp Apps. All rights reserved.
//

import UIKit

class ItemsViewController : UITableViewController {
    
    var itemStore: ItemStore!
    
    let moreThan50Section = 0
    let otherSection = 1
    
    @IBAction func addNewItem(_ sender: UIButton) {
        
        let newItem = itemStore.createItem()
        
        //  I get the section of the new item
        let section = getSectionOf(item: newItem)
        print("+ price: \(newItem.valueInDollars)")
        //  I calculate the index based on the array of items in the same section
        if let index = itemStore.allItems.filter({ getSectionOf(item: $0) == section }).firstIndex(of: newItem) {
            print(" - index: \(index), section: \(section)")
            let indexPath = IndexPath(row: index, section: section)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func toggleEditingMode(_ sender: UIButton) {
        
        if isEditing {
            sender.setTitle("Edit", for: .normal)
            
            setEditing(false, animated: true)
        } else {
            sender.setTitle("Done", for: .normal)
            
            setEditing(true, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let moreThan50SectionCount = itemStore.allItems.filter { getSectionOf(item: $0) == moreThan50Section } .count
        
        if section == moreThan50Section {
            
            return moreThan50SectionCount
        } else {
            
            return itemStore.allItems.count - moreThan50SectionCount
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // insted of create a new UITableViewCell, lets use reuse
        //let tableCell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        let item = itemStore.allItems.filter{ getSectionOf(item: $0) == indexPath.section } [indexPath.row]
        
        tableCell.textLabel?.text = item.name
        tableCell.detailTextLabel?.text = "$\(item.valueInDollars)"
        
        
        return tableCell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            // I filter by section before get the index
            let item = itemStore.allItems.filter{ getSectionOf(item: $0) == indexPath.section }[indexPath.row]
            
            itemStore.removeItem(item)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        //  get the item
        let arrayBySection = itemStore.allItems.filter{ getSectionOf(item: $0) == sourceIndexPath.section }
        
        let originalSourceItem = arrayBySection[sourceIndexPath.row]
        
        let originalSourceIndex = itemStore.allItems.firstIndex(of: originalSourceItem)
        
        
        let originalDestinationItem = arrayBySection[destinationIndexPath.row]
        
        let originalDestinationIndex = itemStore.allItems.firstIndex(of: originalDestinationItem)
        
        itemStore.moveItem(from: originalSourceIndex!, to: originalDestinationIndex!)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == moreThan50Section {
            return "More than $50"
        } else {
            return "$50 or less"
        }
    }
    
    func getSectionOf(item :Item) -> Int {
        
        return item.valueInDollars > 50 ? moreThan50Section : otherSection
    }
}
