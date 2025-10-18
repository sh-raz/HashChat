//
//  TimestampLabel.swift
//  HashChat
//
//  Created by shilani on 19/08/2024.
//

import UIKit

class TimestampLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        self.font = UIFont.preferredFont(forTextStyle: .footnote)
        textColor = .secondaryLabel
        textAlignment = .center
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func formatTimestampForChats(_ timestamp: Date) -> String {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()

        if calendar.isDateInToday(timestamp) {
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: timestamp)
            
        } else if calendar.isDate(timestamp, equalTo: Date(), toGranularity: .weekOfYear) {
            dateFormatter.dateFormat = "EEEE" // Day of the week (e.g., "Friday")
            return dateFormatter.string(from: timestamp)
        
        } else if calendar.isDate(timestamp, equalTo: Date(), toGranularity: .year) {
            dateFormatter.dateFormat = "MMMM d" // Month name and day (e.g., "August 15")
            return dateFormatter.string(from: timestamp)
        
        } else {
            dateFormatter.dateFormat = "yyyy:MM:dd" // Year:Month:Day (e.g., "2023:08:15")
            return dateFormatter.string(from: timestamp)
        }
    }
    
    /*
        func formatTimestamp(_ timestamp: Date) -> String {
              let calendar = Calendar.current
              if calendar.isDateInToday(timestamp) {
                  let formatter = DateFormatter()
                  formatter.dateFormat = "'Today at' h:mm a"
                  return formatter.string(from: timestamp)
              } else if calendar.isDateInYesterday(timestamp) {
                  let formatter = DateFormatter()
                  formatter.dateFormat = "'Yesterday at' h:mm a"
                  return formatter.string(from: timestamp)
              } else {
                  let formatter = DateFormatter()
                  formatter.dateFormat = "MMMM d, yyyy 'at' h:mm a"
                  return formatter.string(from: timestamp)
              }
          }
     */
    
}
