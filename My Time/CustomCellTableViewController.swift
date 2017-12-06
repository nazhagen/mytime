//
//  CustomCellTableViewController.swift
//  My Time
//
//  Created by Nazeli Hagen on 11/25/17.
//  Copyright © 2017 Nazeli Hagen. All rights reserved.
//

import UIKit
import Foundation

// List of events for selected date
var events = [Event]()

let formatter = DateFormatter()

class CustomCellTableViewController: UITableViewController {
    
    @IBOutlet var myTableView: UITableView!
    
    let timeformatter = DateFormatter()
    
    // properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList(note:)),name:NSNotification.Name.init(rawValue: "updateTableView"), object: nil)
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // https://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        // Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @objc func loadList(note: NSNotification){
        myTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        myTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCustomTableCell", for: indexPath) as! CustomTableCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let event = events[indexPath.row]
        timeformatter.dateFormat = "hh:mm a"
        // String that says at what time of event/to do is that day
        let eventTime = " at " + timeformatter.string(from: event.dueDate)
        
        // Include time of event or time to do is due
        if event.type == "Event" {
            cell.myText.backgroundColor = UIColor.green
        }
        else {
            cell.myText.backgroundColor = UIColor.yellow
        }
        cell.myText.text = event.name + eventTime
        
        // Configure the cell...
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Free time of that event
            formatter.dateFormat = "yyyy MM dd HH:mm"
            var date = events[indexPath.row].date
            var time = formatter.string(from: date)
            let endDate = formatter.string(from: date.addingTimeInterval(TimeInterval((events[indexPath.row].timeNeeded)*60*60)))
            while time != endDate
            {
                allTime[time] = nil
                // Increments by 1 minute
                date = date.addingTimeInterval(60)
                time = formatter.string(from: date)
            }
            // Remove from list instance, database, and list of events for that day
            var i = 0
            while !allEvents[i].isEqual(event1: events[indexPath.row]) {
                i += 1
            }
            allEvents.remove(at: i)
            _ = myDB.instance.deleteEvent(cid: events[indexPath.row].id!)
            events.remove(at: indexPath.row)
            myTableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
}

