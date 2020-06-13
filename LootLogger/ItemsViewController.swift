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
    
    var isEmptySectionMoreThan50: Bool {
        get { return itemStore.allItems.filter{getSectionOf(item: $0) == moreThan50Section}.count == 0 }
    }
    
    var isEmptyOtherSection: Bool {
        get { return itemStore.allItems.filter{getSectionOf(item: $0) == otherSection}.count == 0 }
    }
    
    func addEmptyStoreRow(indexPath: IndexPath) {
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    override func viewDidLoad() {
        addEmptyStoreRow(indexPath: IndexPath(row: 0, section: moreThan50Section))
        addEmptyStoreRow(indexPath: IndexPath(row: 0, section: otherSection))
    }
    
    @IBAction func addNewItem(_ sender: UIButton) {
        
        let _isEmptySectionMoreThan50 = isEmptySectionMoreThan50
        let _isEmptyOtherSection = isEmptyOtherSection
        
        let newItem = itemStore.createItem()
        
        //  I get the section of the new item
        let section = getSectionOf(item: newItem)
        
        //  when empty rows, don´t add another one
        if (section == moreThan50Section && _isEmptySectionMoreThan50) ||
            (section == otherSection && _isEmptyOtherSection) {
            tableView.reloadData()
            return
        }
        
        //  I calculate the index based on the array of items in the same section
        if let index = itemStore.allItems.filter({ getSectionOf(item: $0) == section }).firstIndex(of: newItem) {
            
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
        
        if (section == moreThan50Section && isEmptySectionMoreThan50) ||
            (section == otherSection && isEmptyOtherSection) {
            return 1
        } else {
            
            let moreThan50SectionCount = itemStore.allItems.filter { getSectionOf(item: $0) == moreThan50Section } .count
            
            if section == moreThan50Section {
                
                return moreThan50SectionCount
            } else {
                
                return itemStore.allItems.count - moreThan50SectionCount
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        // insted of create a new UITableViewCell, lets use reuse
        //let tableCell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
     
        if (indexPath.section == moreThan50Section && isEmptySectionMoreThan50) ||
            (indexPath.section == otherSection && isEmptyOtherSection) {
        
            tableCell.textLabel?.text = "No items!"
            tableCell.detailTextLabel?.text = ""
        } else {
            
            let item = itemStore.allItems.filter{ getSectionOf(item: $0) == indexPath.section } [indexPath.row]
            
            tableCell.textLabel?.text = item.name
            tableCell.detailTextLabel?.text = "$\(item.valueInDollars)"
        }
        
        return tableCell
    
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            if (indexPath.section == moreThan50Section && isEmptySectionMoreThan50) ||
                (indexPath.section == otherSection && isEmptyOtherSection) {
                return
            }
            
            // I filter by section before get the index
            let item = itemStore.allItems.filter{ getSectionOf(item: $0) == indexPath.section }[indexPath.row]
            
            itemStore.removeItem(item)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        if (sourceIndexPath.section == moreThan50Section && isEmptySectionMoreThan50) ||
            (sourceIndexPath.section == otherSection && isEmptyOtherSection) {
            return
        }
        
        if sourceIndexPath.section != destinationIndexPath.section { return }
        
        let arrayBySection = itemStore.allItems.filter{ getSectionOf(item: $0) == sourceIndexPath.section }
        
        let originalSourceItem = arrayBySection[sourceIndexPath.row]
        let originalSourceIndex = itemStore.allItems.firstIndex(of: originalSourceItem)
        
        
        let originalDestinationItem = arrayBySection[destinationIndexPath.row]
        let originalDestinationIndex = itemStore.allItems.firstIndex(of: originalDestinationItem)
        
        itemStore.moveItem(from: originalSourceIndex!, to: originalDestinationIndex!)
        
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        
        if (sourceIndexPath.section == moreThan50Section && isEmptySectionMoreThan50) ||
            (sourceIndexPath.section == otherSection && isEmptyOtherSection) {
            return sourceIndexPath
        }
        
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            return sourceIndexPath
        } else {
            return proposedDestinationIndexPath
        }
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
