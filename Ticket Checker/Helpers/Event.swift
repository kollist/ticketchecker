//
//  Event.swift
//  Ticket Checker
//
//  Created by Zaytech Mac on 21/10/2024.
//

import Foundation


class Event: Codable {
    var uuid: String
    var owner_name: String
    var is_checked: Bool
    var is_expired: Bool
    var nb_of_checkers: Int
    var event_title: String
    var event_description: String
    var nb_of_persons: Int
    var channel: String
    var amount: Double
    var charge_uuid: String
    var created_at: String
    
    init(uuid: String, owner_name: String, is_checked: Bool, is_expired: Bool, nb_of_checkers: Int, event_title: String, event_description: String, nb_of_persons: Int, channel: String, amount: Double, charge_uuid: String, created_at: String) {
        self.uuid = uuid
        self.owner_name = owner_name
        self.is_checked = is_checked
        self.is_expired = is_expired
        self.nb_of_checkers = nb_of_checkers
        self.event_title = event_title
        self.event_description = event_description
        self.nb_of_persons = nb_of_persons
        self.channel = channel
        self.amount = amount
        self.charge_uuid = charge_uuid
        self.created_at = created_at
    }
    
    func formatDate() -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ" // Match the input format
        inputFormatter.locale = Locale(identifier: "en_US_POSIX") // Ensure correct locale for parsing
        inputFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Use GMT for ISO dates

        // Convert the string to a Date object
        guard let date = inputFormatter.date(from: self.created_at) else {
            return nil
        }
        
        // Output Formatter: Create the format you need
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "E, MMM dd | h:mm a" // Output format
        outputFormatter.amSymbol = "AM"
        outputFormatter.pmSymbol = "PM"
        outputFormatter.timeZone = TimeZone.current // Use local timezone

        // Convert the Date object back to the formatted string
        let formattedDate = outputFormatter.string(from: date)
        
        return formattedDate
    }
}
