//
//  ItemStore.swift
//  LootLogger
//
//  Created by Guillermo Padilla Lam on 10/06/20.
//  Copyright © 2020 gp Apps. All rights reserved.
//

import UIKit

class ItemStore {
    var allItems = [Item]()
    
    let itemArchiveUrl: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("items.plist")
    }()
    
    init() {
        do {
            
            let data = try Data(contentsOf: itemArchiveUrl)
            let unarchiver = PropertyListDecoder()
            let items = try unarchiver.decode([Item].self, from: data)
            allItems = items
        } catch {
            print("Error reading in saved items: \(error)")
        }
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIScene.didEnterBackgroundNotification, object: nil)
    }
    
    @discardableResult func createItem() -> Item {
        let newItem = Item(random: true)
        
        allItems.append(newItem)
        
        return newItem
    }
    
    func removeItem(_ item: Item) {
        if let index = allItems.firstIndex(of: item) {
            allItems.remove(at: index)
        }
    }
    
    func moveItem(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        let item = allItems[fromIndex]
        
        allItems.remove(at: fromIndex)
        
        allItems.insert(item, at: toIndex)
    }
    
    @objc func saveChanges() throws {
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(allItems)
            
            try data.write(to: itemArchiveUrl, options: .atomic)
            print("Saved all of the items")
        } catch  {
            print("Error encoding all items: \(error)")
            throw RuntimeError.readingDataError("Error reading in saved items: \(error)")
        }
        
    }
}
