//
//  Checklist.swift
//  TimmiesRun
//
//  Created by Nicole Groeger on 2024-06-20.
//

import UIKit

class Checklist: NSObject, Codable {
    var name = ""
    var items = [ChecklistItem]()
    var iconName = "No Icon"

    init(name: String, iconName: String = "No Icon") {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    func countUncheckedItems() -> Int {
        return items.reduce(0) {
            cnt,item in cnt + (item.checked ? 0 : 1)
        }
    }
}
