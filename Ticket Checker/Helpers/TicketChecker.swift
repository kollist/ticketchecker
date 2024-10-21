//
//  TicketChecker.swift
//  Ticket Checker
//
//  Created by Zaytech Mac on 21/10/2024.
//

import Foundation
import UIKit

import UIKit

class TicketChecker {
    func checkETicket(ticketNumber: String, completion: @escaping (Result<Event, Error>) -> Void) {
        guard let url = URL(string: "https://api-v2-sandbox.smartonlineorders.com/v2/public/check-eticket") else {
            print("Invalid URL")
            return
        }

        // Create a URL request
        var request = URLRequest(url: url)
        request.httpMethod = "POST" // Use POST or GET as needed
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the request body (if needed)
        let body: [String: Any] = [
            "ticket_number": ticketNumber // Add any other required parameters
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Error serializing JSON: \(error)")
            return
        }

        // Send the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for errors
            if let error = error {
                print("Error with request: \(error)")
                completion(.failure(error))
                return
            }

            // Check for response data
            guard let data = data else {
                print("No data received")
                completion(.failure(NSError(domain: "NoDataError", code: 0, userInfo: nil)))
                return
            }

            // Handle response: Attempt to decode the JSON into the Event object
            do {
                let event = try JSONDecoder().decode(Event.self, from: data)
                completion(.success(event))
            } catch {
                print("Error decoding JSON: \(error)")
                completion(.failure(error))
            }
        }

        task.resume() // Start the task
    }
}
