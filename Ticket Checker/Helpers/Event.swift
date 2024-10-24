//
//  Event.swift
//  Ticket Checker
//
//  Created by Zaytech Mac on 21/10/2024.
//

import Foundation


class Event: Codable {
    
    var uuid: String?
    var owner_name: String?
    var is_checked: Bool?
    var is_expired: Bool?
    var nb_of_checks: Int?
    var event_title: String?
    var event_description: String?
    var nb_of_persons: Int?
    var channel: String?
    var amount: Double?
    var charge_uuid: String?
    var created_at: String?
    var event_date: String?
    
    init(uuid: String? = nil, owner_name: String? = nil, is_checked: Bool? = nil, is_expired: Bool? = nil, nb_of_checks: Int? = nil, event_title: String? = nil, event_description: String? = nil, nb_of_persons: Int? = nil, channel: String? = nil, amount: Double? = nil, charge_uuid: String? = nil, created_at: String? = nil, event_date: String? = nil) {
        self.uuid = uuid
        self.owner_name = owner_name
        self.is_checked = is_checked
        self.is_expired = is_expired
        self.nb_of_checks = nb_of_checks
        self.event_title = event_title
        self.event_description = event_description
        self.nb_of_persons = nb_of_persons
        self.channel = channel
        self.amount = amount
        self.charge_uuid = charge_uuid
        self.created_at = created_at
        self.event_date = event_date
    }
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case owner_name
        case is_checked
        case is_expired
        case nb_of_checks
        case event_title
        case event_description
        case nb_of_persons
        case channel
        case amount
        case charge_uuid
        case created_at
        case event_date
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uuid = try container.decode(String.self, forKey: .uuid)
        self.owner_name = try container.decode(String.self, forKey: .owner_name)
        self.is_checked = try container.decode(Bool.self, forKey: .is_checked)
        self.is_expired = try container.decode(Bool.self, forKey: .is_expired)
        self.nb_of_checks = try container.decode(Int.self, forKey: .nb_of_checks)
        self.event_title = try container.decode(String.self, forKey: .event_title)
        self.event_description = try container.decode(String.self, forKey: .event_description)
        self.nb_of_persons = try container.decode(Int.self, forKey: .nb_of_persons)
        self.channel = try container.decode(String.self, forKey: .channel)
        self.amount = try container.decode(Double.self, forKey: .amount)
        self.charge_uuid = try container.decode(String.self, forKey: .charge_uuid)
        self.created_at = try container.decode(String.self, forKey: .created_at)
        self.event_date = try container.decode(String.self, forKey: .event_date)
    }
    
    func formatDate() -> String? {
        // ISO8601DateFormatter().
        if let eDate = self.event_date {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
            inputFormatter.locale = Locale(identifier: "en_US_POSIX")
            inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            
            guard let date = inputFormatter.date(from: eDate) else {
                return nil
            }
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "E, MMM dd | h:mm a"
            outputFormatter.amSymbol = "AM"
            outputFormatter.pmSymbol = "PM"
            outputFormatter.timeZone = TimeZone.current
            
            let formattedDate = outputFormatter.string(from: date)
            
            return formattedDate
        }
        return nil
    }
}
