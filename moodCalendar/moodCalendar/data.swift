//
//  data.swift
//  moodCalendar
//
//  Created by LisaBebe11 on 5/5/18.
//  Copyright © 2018 LisaBebe11. All rights reserved.
//

/*
 This is where you will be getting your data from a different source.
 */

import UIKit
import EventKit

class Data {
    
    private static let eventStore = EKEventStore()
    private static let calendarName = "My App's Custom Calendar" // Rename your calendar to whatever you want
    private static let calendarKey = "CustomCalendar"
    
    /*
     An app can create it's own "Calendar" in the iPhone's Calendar app.
     If you go into the Calendar app and tap the "Calendars" button at the bottom,
     you will see all the custom calendars in there for things like Birthdays and Holidays, etc.
     */
    private static func getCustomCalendar() -> EKCalendar {
        // Check if Calendar already exists
        if let calendarIdentifier = UserDefaults.standard.value(forKey: calendarKey) as? String {
            if let customCalendar = eventStore.calendar(withIdentifier: calendarIdentifier) {
                return customCalendar
            }
        }
        
        // Calendar doesn't already exist so create a new one
        let customCalendar = EKCalendar(for: .event, eventStore: eventStore)
        customCalendar.title = calendarName
        customCalendar.cgColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1).cgColor
        
        for source in eventStore.sources {
            if source.sourceType == EKSourceType.local {
                customCalendar.source = source
            }
        }
        
        // Save the calendar, adds it to the phone
        do {
            try eventStore.saveCalendar(customCalendar, commit: true)
            UserDefaults.standard.set(customCalendar.calendarIdentifier, forKey: calendarKey)
        } catch {
            print("Error creating customCalendar: ", error.localizedDescription)
        }
        
        return customCalendar
    }
    
    /*
     "Events" are just the name for calendar entries.
     */
    static func getEvents(for date: Date, completion: @escaping ([Model]) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            var data = [Model]()
            
            eventStore.requestAccess(to: .event) { (granted, error) in
                if let error = error {
                    print("There was an error accessing Event Store: \(error)")
                    data.append(Model(eventIdentifier: "-1", title: "Error", description: error.localizedDescription, location: "", StartDateTime: nil))
                }
                
                if granted {
                    // Only get events in our own custom calendar
                    let predicate = eventStore.predicateForEvents(withStart: date.startOfDay, end: date.endOfDay!, calendars: [getCustomCalendar()])
                    let events = eventStore.events(matching: predicate)
                    
                    for event in events {
                        data.append(Model(eventIdentifier: event.eventIdentifier, title: event.title, description: event.notes, location: "", StartDateTime: event.startDate))
                    }
                }
                
                DispatchQueue.main.async {
                    completion(data)
                }
            }
        }
    }
    
    static func getEvent(identifier: String) -> EKEvent? {
        return eventStore.event(withIdentifier: identifier)
    }
    
    static func saveEvent(title: String, description: String?, location: String?, startDate: Date) -> String? {
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.notes = description
        event.location = location
        event.calendar = getCustomCalendar()
        event.startDate = startDate
        event.endDate = Calendar.current.date(byAdding: .minute, value: 60, to: startDate)
        
        do {
            try eventStore.save(event, span: .thisEvent)
        } catch {
            print("Error saving event: ", error.localizedDescription)
        }
        
        return event.eventIdentifier
    }
    
    static func deleteEvent(eventIdentifier: String) -> Bool {
        do {
            if let event = getEvent(identifier: eventIdentifier) {
                try eventStore.remove(event, span: EKSpan.thisEvent)
                return true
            } else {
                return false
            }
        } catch {
            print("Error deleting event: ", error.localizedDescription)
            return false
        }
    }
}

