//
//  FirstViewController.swift
//  My Time
//
//  Created by Nazeli Hagen on 11/23/17.
//  Copyright © 2017 Nazeli Hagen. All rights reserved.
//
//  Credit to https://patchthecode.github.io/ for all JTAppleCalendar functionality

import UIKit
import JTAppleCalendar

var allEvents = [Event]()

var allTime = [String: Bool]()

class FirstViewController: UIViewController {
    
    let outsideMonthColor = UIColor.gray
    let monthColor = UIColor.black
    let selectedMonthColor = UIColor.blue
    let currentDateSelectedViewColor = UIColor.cyan
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.scrollToDate(Date())
        calendarView.selectDates([Date()])
        
        // Get events from database
        allEvents = myDB.instance.getEvents()

        // Map time schedule from events
        formatter.dateFormat = "yyyy MM dd HH:mm"
        for event in allEvents {
            var date = event.dueDate
            var time = formatter.string(from: date)
            let endDate = formatter.string(from: event.dueDate.addingTimeInterval(TimeInterval((event.timeNeeded)*60*60)))
            while time != endDate
            {
                allTime[time] = true
                // Increments by 1 minute
                date = date.addingTimeInterval(60)
                time = formatter.string(from: date)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        allEvents = myDB.instance.getEvents()
        if (calendarView.selectedDates.first != nil) {
            displayEventsFor(date: calendarView.selectedDates.first!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Set text color in selected cells, cells outside defined month, and month cells
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCell else { return }
        if validCell.isSelected {
            validCell.dateLabel.textColor = selectedMonthColor
        }
        else
        {
            if cellState.dateBelongsTo == .thisMonth
            {
                validCell.dateLabel.textColor = monthColor
            }
            else
            {
                validCell.dateLabel.textColor = outsideMonthColor
            }
            
        }
    }
    
    // Highlights cell when clicked (make selected view visible)
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCell else { return }
        if validCell.isSelected {
            validCell.selectedView.isHidden = false
        }
        else
        {
            validCell.selectedView.isHidden = true
        }
        
    }
    
    // Displays events with a date within the 24 hours of that day
    func displayEventsFor(date: Date) {
        events.removeAll()
        for event in allEvents {
            let eventDate = event.dueDate
            if (eventDate.compare(date.addingTimeInterval(86399)) == ComparisonResult.orderedSame || eventDate.compare(date.addingTimeInterval(86399)) == ComparisonResult.orderedAscending) && (eventDate.compare(date) == ComparisonResult.orderedDescending || eventDate.compare(date) == ComparisonResult.orderedSame) {
                events.append(event)
            }
            events.sort { $0.dueDate < $1.dueDate }
        }
    }
    
}

extension FirstViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2017 01 01")!
        let endDate = formatter.date(from: "2018 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        
        calendar.scrollDirection = UICollectionViewScrollDirection.horizontal
        calendar.scrollingMode = ScrollingMode.stopAtEachCalendarFrame
        return parameters
    }
}

extension FirstViewController: JTAppleCalendarViewDelegate {
    
    // Display the cell
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        sharedFunctionToConfigureCell(myCustomCell: cell, cellState: cellState, date: date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        sharedFunctionToConfigureCell(myCustomCell: cell, cellState: cellState, date: date)
        return cell
    }
    
    // Configure cell
    func sharedFunctionToConfigureCell(myCustomCell: CustomCell, cellState: CellState, date: Date) {
        myCustomCell.dateLabel.text = cellState.text
        handleCellSelected(view: myCustomCell, cellState: cellState)
        handleCellTextColor(view: myCustomCell, cellState: cellState)
    }
    
    // When cell is selected
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        // Checks to make sure cell is not nill
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        displayEventsFor(date: date)
        // Send a notifaction to CustomCellTableViewController to update table view
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateTableView"), object: nil)
    }
    
    // When cell is deselected
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        // Checks to make sure cell is not nill
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    // Update month and year at top when calendar scrolls to new month
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        formatter.dateFormat = "yyyy"
        yearLabel.text = formatter.string(from: date)
        
        formatter.dateFormat = "MMMM"
        monthLabel.text = formatter.string(from: date)
    }
    
}


