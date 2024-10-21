//
//  SuccessViewController.swift
//  Ticket Checker
//
//  Created by Zaytech Mac on 19/10/2024.
//

import UIKit

class ResultViewController: UIViewController {

    var statusTitle: String?
    var statusImage: UIImage?
    var statusColors: [CGColor]?
    var eventInstance: Event?
    var ticketNumber: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor  = .white
        config()
    }
    
    func configEventStatusView() {
        let statusView = EventStatusView()
        if let img = self.statusImage, let title = self.statusTitle, let colors = self.statusColors {
            statusView.config(icon: img, title: title, colors: colors)
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
    
    func configEventData() {
        let eventView = EventView()
        let eventDataDetailsView = EventDataDetailsView()
        let eventTitleLabel = TitleLabel()
        eventTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        if let event = eventInstance, let ticket = ticketNumber {
            eventTitleLabel.config(event.event_title)
            let eventRowOne = EventDetailRowStackView()
            eventRowOne.config(key: "Name:", value: event.owner_name, fontWeight: .bold)
            let eventRowTwo = EventDetailRowStackView()
            eventRowTwo.config(key: "Order Number:", value: ticket)
            let eventRowThree = EventDetailRowStackView()
            eventRowThree.config(key: "Date/time:", value: event.formatDate() ?? "")
            let eventRowFour = EventDetailRowStackView()
            eventRowFour.config(key: "Number of personnes:", value: "32 Personnes", fontWeight: .bold)
            let eventRowFive = EventDetailRowStackView()
            eventRowFive.config(key: "Price", value: "$\(event.amount)")
            
            eventDataDetailsView.addSubview(eventRowOne)
            eventDataDetailsView.addSubview(eventRowTwo)
            eventDataDetailsView.addSubview(eventRowThree)
            eventDataDetailsView.addSubview(eventRowFour)
            eventDataDetailsView.addSubview(eventRowFive)

            NSLayoutConstraint.activate([
                eventRowOne.topAnchor.constraint(equalTo: eventDataDetailsView.topAnchor, constant: 30),
                eventRowOne.leadingAnchor.constraint(equalTo: eventDataDetailsView.leadingAnchor, constant: 20),
                eventRowOne.trailingAnchor.constraint(equalTo: eventDataDetailsView.trailingAnchor, constant: -20),
                eventRowOne.heightAnchor.constraint(equalToConstant: 30),

                eventRowTwo.topAnchor.constraint(equalTo: eventRowOne.bottomAnchor, constant: 15),
                eventRowTwo.leadingAnchor.constraint(equalTo: eventDataDetailsView.leadingAnchor, constant: 20),
                eventRowTwo.trailingAnchor.constraint(equalTo: eventDataDetailsView.trailingAnchor, constant: -20),
                eventRowTwo.heightAnchor.constraint(equalToConstant: 30),
                
                eventRowThree.topAnchor.constraint(equalTo: eventRowTwo.bottomAnchor, constant: 15),
                eventRowThree.leadingAnchor.constraint(equalTo: eventDataDetailsView.leadingAnchor, constant: 20),
                eventRowThree.trailingAnchor.constraint(equalTo: eventDataDetailsView.trailingAnchor, constant: -20),
                eventRowThree.heightAnchor.constraint(equalToConstant: 30),
                
                eventRowFour.topAnchor.constraint(equalTo: eventRowThree.bottomAnchor, constant: 15),
                eventRowFour.leadingAnchor.constraint(equalTo: eventDataDetailsView.leadingAnchor, constant: 20),
                eventRowFour.trailingAnchor.constraint(equalTo: eventDataDetailsView.trailingAnchor, constant: -20),
                eventRowFour.heightAnchor.constraint(equalToConstant: 30),
                
                eventRowFive.topAnchor.constraint(equalTo: eventRowFour.bottomAnchor, constant: 15),
                eventRowFive.leadingAnchor.constraint(equalTo: eventDataDetailsView.leadingAnchor, constant: 20),
                eventRowFive.trailingAnchor.constraint(equalTo: eventDataDetailsView.trailingAnchor, constant: -20),
                eventRowFive.heightAnchor.constraint(equalToConstant: 30),
            ])
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
            
            eventView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 280),
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
