//
//  DateExtension.swift
//  HashChat
//
//  Created by shilani on 03/10/2024.
//

import Foundation

extension Date {
    
    func formattedDateString() -> String {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        
        if calendar.isDateInToday(self) {
            dateFormatter.dateFormat = "HH:mm a"
        }
        else if calendar.isDateInThisWeek(self) {
            dateFormatter.dateFormat = "EEEE"  // Example: Monday
        }
        else if calendar.isDateInThisYear(self) {
            dateFormatter.dateFormat = "MMMM d"  // Example: October 3, 02:45 PM
        }
        else {
            dateFormatter.dateFormat = "d.MM.yyyy"
        }
        
        return dateFormatter.string(from: self)
    }
}

extension Calendar {
    func isDateInThisWeek(_ date: Date) -> Bool {
        return self.isDate(date, equalTo: Date(), toGranularity: .weekOfYear)
    }
    
    func isDateInThisYear(_ date: Date) -> Bool {
        return self.isDate(date, equalTo: Date(), toGranularity: .year)
    }
}
