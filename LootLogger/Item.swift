//
//  Item.swift
//  LootLogger
//
//  Created by Guillermo Padilla Lam on 10/06/20.
//  Copyright © 2020 gp Apps. All rights reserved.
//

import Foundation

class Item {
    var name: String
    var valueInDollars: Int
    var serialNumber: String?
    var dateCreated: Date
    var isFavorite: Bool
    
    init(name: String, serialNumber: String?, valueInDollars: Int) {
        self.name = name
        self.serialNumber = serialNumber
        self.valueInDollars = valueInDollars
        self.dateCreated = Date()
        self.isFavorite = false
    }

    convenience init(random: Bool = false) {
        if random {
            let adjectives = ["Fluffy", "Rusty", "Shiny"]
            let nouns = ["Bear", "Spork", "Mac"]
            
            let randomAdjective = adjectives.randomElement()!
            let randomNoun = nouns.randomElement()!
            
            let randomName = "\(randomAdjective) \(randomNoun)"
            let randomValue = Int.random(in: 0..<100)
            let randomSerialNumber = UUID().uuidString
            
            self.init(name: randomName, serialNumber: randomSerialNumber, valueInDollars: randomValue)
        } else {
            self.init(name: "", serialNumber: nil, valueInDollars: 0)
        }
    }
}

extension Item : Equatable {
    static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.dateCreated == rhs.dateCreated && lhs.name == rhs.name && lhs.serialNumber == rhs.serialNumber && lhs.valueInDollars == rhs.valueInDollars
    }
}
