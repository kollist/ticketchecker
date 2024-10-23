//
//  SuccessViewController.swift
//  Ticket Checker
//
//  Created by Zaytech Mac on 19/10/2024.
//

import UIKit

class ResultViewController: UIViewController, UIGestureRecognizerDelegate {

    var eventInstance: Event?
    var ticketNumber: String?
    let statusView = EventStatusView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "BgColor")
        config()
        if let event = eventInstance {
            print("Event Title: \(event.event_title)")
            print("Owner Name: \(event.owner_name)")
        }
    }
    
    func configEventStatusView() {
        if let event = eventInstance {
            let is_checked = event.nb_of_checks > 1 ? true : false
            statusView.config(checked: is_checked)
        }
        statusView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(statusView)
        NSLayoutConstraint.activate([
            statusView.topAnchor.constraint(equalTo: self.view.topAnchor),
            statusView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            statusView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            statusView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3)
        ])
    }
    func configScanAgain() {
        let btn = CustomButton()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goBackToScan))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        btn.addGestureRecognizer(tapGesture)
        btn.config("Scan Again")
        btn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(btn)
        NSLayoutConstraint.activate([
            btn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            btn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            btn.heightAnchor.constraint(equalToConstant: 50),
            btn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
    
    @objc func goBackToScan() {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func configEventData() {
        
            let eventView = EventView()
            eventView.translatesAutoresizingMaskIntoConstraints = false
            let eventDataDetailsView = EventDataDetailsView()
            eventDataDetailsView.translatesAutoresizingMaskIntoConstraints = false
            let eventTitleLabel = TitleLabel()
            eventTitleLabel.translatesAutoresizingMaskIntoConstraints = false
            if let event = self.eventInstance, let ticket = self.ticketNumber {
                eventTitleLabel.config(event.event_title)
                
                let eventRowOne = EventDetailRowView()
                eventRowOne.config(key: "Name:", value: event.owner_name, fontWeight: .bold)
                
                let eventRowTwo = EventDetailRowView()
                eventRowTwo.config(key: "Order Number:", value: ticket)
                
                let eventRowThree = EventDetailRowView()
                eventRowThree.config(key: "Date/time:", value: event.formatDate() ?? "")
                
                let eventRowFour = EventDetailRowView()
                eventRowFour.config(key: "Number of personnes:", value: "\(event.nb_of_persons) Personne\(event.nb_of_persons > 1 ? "s" : "")", fontWeight: .bold)
                
                let eventRowFive = EventDetailRowView()
                eventRowFive.config(key: "Price", value: "$\(event.amount)")
                
                // Add the rows to the stack view
                eventDataDetailsView.addEventRow(eventRowOne)
                eventDataDetailsView.addEventRow(eventRowTwo)
                eventDataDetailsView.addEventRow(eventRowThree)
                eventDataDetailsView.addEventRow(eventRowFour)
                eventDataDetailsView.addEventRow(eventRowFive, false)
            } else {
                eventTitleLabel.config("Title not available")
            }
            
            eventView.addSubview(eventTitleLabel)
            eventView.addSubview(eventDataDetailsView)
            self.view.addSubview(eventView)
            NSLayoutConstraint.activate([
                eventTitleLabel.topAnchor.constraint(equalTo: eventView.topAnchor, constant: 30),
                eventTitleLabel.leadingAnchor.constraint(equalTo: eventView.leadingAnchor, constant: 45),
                
                eventDataDetailsView.topAnchor.constraint(equalTo: eventTitleLabel.bottomAnchor, constant: 25),
                eventDataDetailsView.leadingAnchor.constraint(equalTo: eventView.leadingAnchor, constant: 45),
                eventDataDetailsView.trailingAnchor.constraint(equalTo: eventView.trailingAnchor, constant: -45),
                
                eventView.topAnchor.constraint(equalTo: self.statusView.bottomAnchor),
                eventView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                eventView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            ])
        
        
    }
    
    func config() {
        configEventStatusView()
        configScanAgain()
        configEventData()
    }

}
