//
//  SecondViewController.swift
//  My Time
//
//  Created by Nazeli Hagen on 11/23/17.
//  Copyright © 2017 Nazeli Hagen. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func datePickerChanged(_ sender: Any) {}
    
    @IBOutlet weak var segmentEventToDo: UISegmentedControl!
    
    // Switches from add event screen to add to do screen (label and visibility changes)
    @IBAction func switchToggled(_ sender: Any) {
        
        if titleLabel.text == "New Event" {
            titleLabel.text = "New To Do"
        }
        else { titleLabel.text = "New Event" }
        
        if timeOrLengthLabel.text == "Time Needed:" {
            timeOrLengthLabel.text = "Length:"
        }
        else { timeOrLengthLabel.text = "Time Needed:" }
        
        if dateLabel.text == "Date" {
            dateLabel.text = "Due Date"
        }
        else { dateLabel.text = "Date" }
        
        if addbutton.currentTitle == "Add Event" {
            addbutton.setTitle("Add To Do", for: UIControlState.normal)
        }
        else { addbutton.setTitle("Add Event", for: UIControlState.normal) }
        
        if input.placeholder == "Event" {
            input.placeholder = "To Do"
        }
        else { input.placeholder = "Event" }
        
        if repeatsWeekly.isHidden && `for`.isHidden && weeks.isHidden && weeksRepeated.isHidden && weeklySwitch.isHidden {
            repeatsWeekly.isHidden = false
            `for`.isHidden = false
            weeks.isHidden = false
            weeksRepeated.isHidden = false
            weeklySwitch.isHidden = false
        }
        else {
            repeatsWeekly.isHidden = true
            `for`.isHidden = true
            weeks.isHidden = true
            weeksRepeated.isHidden = true
            weeklySwitch.isHidden = true
        }
        
    }
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeOfDayLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var timeOrLengthLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeNeeded: UITextField!
    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var addbutton: UIButton!
    @IBOutlet weak var priority: UITextField!
    @IBOutlet weak var timeOfDay: UITextField!
    @IBOutlet weak var weeklySwitch: UISwitch!
    @IBOutlet weak var weeksRepeated: UITextField!
    @IBOutlet weak var repeatsWeekly: UILabel!
    @IBOutlet weak var `for`: UILabel!
    @IBOutlet weak var weeks: UILabel!
    
    @IBAction func addevent(_ sender: Any) {
        // Check if event/to do name field is empty before adding
        if input.text != "" {
            var type = ""
            if segmentEventToDo.selectedSegmentIndex == 1 {
                type = "To Do"
            }
            else {
                type = "Event"
            }
            var date = datePicker.date
            if type == "To Do" {
                // Start at current time
                date = Date()
                var timeFound = 0
                formatter.dateFormat = "yyyy MM dd HH:mm"
                while timeFound < Int(timeNeeded.text!)!*60 {
                    if allTime[formatter.string(from: date)] != nil {
                        timeFound = 0
                    }
                    else {
                        timeFound += 1
                    }
                    // Increase date by one minute
                    date.addTimeInterval(60)
                    if date.compare(datePicker.date) == ComparisonResult.orderedSame {
                        break
                    }
                }
                // Set date/time back the amount of time needed (and found) to set it to beginning of time found
                date.addTimeInterval(TimeInterval(Int(timeNeeded.text!)!*(-60)*(60)))
                // Add event to database and array
                if let id = myDB.instance.addEvent(cname: input.text!, cduedate: datePicker.date, ctype: type, cdate: date, clength: Int(timeNeeded.text!)!)
                {
                    allEvents.append(Event(id: id, name: input.text!, dueDate: datePicker.date, type: type, date: date, timeNeeded: Int(timeNeeded.text!)!))
                }
                // Add event to map of times
                formatter.dateFormat = "yyyy MM dd HH:mm"
                var time = formatter.string(from: date)
                let endDate = formatter.string(from: date.addingTimeInterval(TimeInterval(Int(timeNeeded.text!)!*60*60)))
                while time != endDate
                {
                    allTime[time] = true
                    // Increments by 1 minute
                    date = date.addingTimeInterval(60)
                    time = formatter.string(from: date)
                }
            }
            else if weeklySwitch.isOn {
                formatter.timeZone = Calendar.current.timeZone
                formatter.locale = Calendar.current.locale
                let endDate = date.addingTimeInterval(TimeInterval(604800*Int(weeksRepeated.text!)!))
                while date.compare(endDate) == ComparisonResult.orderedAscending {
                    // Add event to database and array
                    if let id = myDB.instance.addEvent(cname: input.text!, cduedate: date, ctype: type, clength: Int(timeNeeded.text!)!)
                    {
                        allEvents.append(Event(id: id, name: input.text!, dueDate: date, type: type, timeNeeded: Int(timeNeeded.text!)!))
                    }
                    // Add event to map of times
                    formatter.dateFormat = "yyyy MM dd HH:mm"
                    var time = formatter.string(from: date)
                    let endDateString = formatter.string(from: date.addingTimeInterval(TimeInterval(Int(timeNeeded.text!)!*60*60)))
                    while time != endDateString
                    {
                        allTime[time] = true
                        // Increments by 1 minute
                        date = date.addingTimeInterval(60)
                        time = formatter.string(from: date)
                    }
                    // Go back to beginning of event (start time)
                    date.addTimeInterval(TimeInterval(Int(timeNeeded.text!)!*(-60)*60))
                    // Add a week
                    date.addTimeInterval(604800)
                    weeksRepeated.text = ""
                }
            }
            else {
                // Insert event into database and into list instance
                if let id = myDB.instance.addEvent(cname: input.text!, cduedate: date, ctype: type, clength: Int(timeNeeded.text!)!)
                {
                    allEvents.append(Event(id: id, name: input.text!, dueDate: date, type: type, timeNeeded: Int(timeNeeded.text!)!))
                }
                // Add event to map of times
                formatter.dateFormat = "yyyy MM dd HH:mm"
                var time = formatter.string(from: date)
                let endDate = formatter.string(from: date.addingTimeInterval(TimeInterval(Int(timeNeeded.text!)!*60*60)))
                while time != endDate
                {
                    allTime[time] = true
                    // Increments by 1 minute
                    date = date.addingTimeInterval(60)
                    time = formatter.string(from: date)
                }
            }
            
            input.text = ""
            timeNeeded.text = ""
            priority.text = ""
            timeOfDay.text = ""
            weeklySwitch.setOn(false, animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        timeOfDay.isHidden = true
        priority.isHidden = true
        priorityLabel.isHidden = true
        timeOfDayLabel.isHidden = true
        
        // https://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        // Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

