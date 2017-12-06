//
//  Event.swift
//  My Time
//
//  Created by Nazeli Hagen on 11/25/17.
//  Copyright © 2017 Nazeli Hagen. All rights reserved.
//

import UIKit

class Event {
    
    var dueDate: Date
    var priority: Int = 0
    var timeNeeded: Int = 0
    var name: String = ""
    var timeOfDay: String = ""
    var type: String = ""
    let id: Int64?
    var date: Date
    
    init(id: Int64, name: String, dueDate: Date, type: String, timeNeeded: Int)
    {
        self.id = id
        self.name = name
        self.dueDate = dueDate
        self.timeNeeded = timeNeeded
        self.priority = 0
        self.timeOfDay = ""
        self.type = type
        self.date = dueDate
    }
    
    init(id: Int64, name: String, dueDate: Date, type: String, date: Date, timeNeeded: Int)
    {
        self.id = id
        self.name = name
        self.dueDate = dueDate
        self.timeNeeded = timeNeeded
        self.priority = 0
        self.timeOfDay = ""
        self.type = type
        self.date = date
    }
    
    init(id: Int64, name: String, dueDate: Date,timeNeeded: Int, priority: Int, timeOfDay: String, type: String) {
        self.id = id
        self.name = name
        self.dueDate = dueDate
        self.date = dueDate
        self.timeNeeded = timeNeeded
        self.priority = priority
        self.timeOfDay = timeOfDay
        self.type = type
    }
    
    init(id: Int64, name: String, dueDate: Date,timeNeeded: Int, priority: Int, timeOfDay: String, type: String, date: Date) {
        self.id = id
        self.name = name
        self.dueDate = dueDate
        self.date = date
        self.timeNeeded = timeNeeded
        self.priority = priority
        self.timeOfDay = timeOfDay
        self.type = type
    }
    
    func isEqual(event1: Event) -> Bool {
        if self.id == event1.id {
            return true
        }
        return false
    }
    
}

