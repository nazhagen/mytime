//
//  File.swift
//  My Time (SQL)
//
//  Created by Nazeli Hagen on 12/3/17.
//  Copyright © 2017 Nazeli Hagen. All rights reserved.
//
//  Credit to https://www.sitepoint.com/managing-data-in-ios-apps-with-sqlite/# for init, insert, delete, get SQL code examples
//  and https://github.com/stephencelis/SQLite.swift for SQL wrapper functionality

import SQLite
import Foundation

class myDB {
    static let instance = myDB()
    private let db: Connection?
    
    private let eventTable = Table("eventTable")
    private let id = Expression<Int64>("id")
    private let name = Expression<String>("name")
    private let type = Expression<String>("type")
    private let date = Expression<String>("date")
    private let length = Expression<Int?>("length")
    
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        do {
            db = try Connection("\(path)/myDB.sqlite3")
        } catch {
            db = nil
            print ("Unable to open database")
        }
        
        createTable()
    }
    
    func createTable() {
        do {
            try db!.run(eventTable.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(name)
                table.column(date)
                table.column(type)
                table.column(length)
            })
        } catch {
            print("Unable to create table")
        }
    }
    
    // The below functions handle all insertion, deletion, and retrieval in connection to the database
    
    func addEvent(cname: String, cduedate: Date, ctype: String, clength: Int) -> Int64? {
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss +SSSS"
        do {
            let insert = eventTable.insert(name <- cname, date <- formatter.string(from: cduedate), type <- ctype, length <- clength)
            let id = try db!.run(insert)
            
            return id
        } catch {
            print("Insert failed")
            return -1
        }
    }
    
    func addEvent(cname: String, cduedate: Date, ctype: String, cdate: Date, clength: Int) -> Int64? {
        formatter.dateFormat = "MM/dd hh:mm a"
        let dueDateName = formatter.string(from: cduedate)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss +SSSS"
        do {
            let insert = eventTable.insert(name <- "work on " + cname + " due " + dueDateName, date <- formatter.string(from: cdate), type <- ctype, length <- clength)
            let id = try db!.run(insert)
            
            return id
        } catch {
            print("Insert failed")
            return -1
        }
    }
    
    func getEvents() -> [Event] {
        var allEvents = [Event]()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss +SSSS"
        do {
            for event in try db!.prepare(self.eventTable) {
                allEvents.append(Event(
                    id: event[id],
                    name: event[name],
                    dueDate: formatter.date(from: event[date])!,
                    type: event[type],
                    timeNeeded: event[length]!))
            }
        } catch {
            print("Select failed")
        }
        
        return allEvents
    }
    
    func deleteEvent(cid: Int64) -> Bool {
        do {
            let event = eventTable.filter(id == cid)
            try db!.run(event.delete())
            return true
        } catch {
            print("Delete failed")
        }
        return false
    }
}

