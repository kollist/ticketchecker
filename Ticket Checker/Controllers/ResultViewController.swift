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
    
    weak var delegate: QRScannerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "BgColor")
        config()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.didDismissModalView()
    }
    
    let statusView: EventStatusView = {
        let sv = EventStatusView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    lazy var ScanAgainButton: CustomButton = {
        let btn = CustomButton()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goBackToScan))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        btn.addGestureRecognizer(tapGesture)
        btn.config("SCAN ANOTHER")
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    @objc func goBackToScan() {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    lazy var eventView: EventView = {
        let eventView = EventView()
        eventView.translatesAutoresizingMaskIntoConstraints = false
        return eventView
    }()
    
    let eventDataDetailsView: EventDataDetailsView = {
        let eventDataView = EventDataDetailsView()
        eventDataView.translatesAutoresizingMaskIntoConstraints = false
        return eventDataView
    }()
    
    lazy var eventTitleLabel: TitleLabel = {
        let eventTitleLabel = TitleLabel()
        eventTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        return eventTitleLabel
    }()
    func configEventData() {
    }
    
    func config() {
        if let event = eventInstance {
            let is_checked = event.nb_of_checks ?? 2 > 1 ? true : false
            statusView.config(checked: is_checked)
        }
        
        self.view.addSubview(ScanAgainButton)
        self.view.addSubview(statusView)
        eventView.addSubview(eventTitleLabel)
        eventView.addSubview(eventDataDetailsView)
        self.view.addSubview(eventView)
        
        if let event = self.eventInstance, let ticket = self.ticketNumber {
            
            eventTitleLabel.config(event.event_title ?? "")
            
            if let owner_name = event.owner_name {
                let eventRowOne = EventDetailRowView()
                eventRowOne.config(key: "Name:", value: owner_name, fontWeight: .bold)
                eventDataDetailsView.addEventRow(eventRowOne)
            }
            
            
            let eventRowTwo = EventDetailRowView()
            eventRowTwo.config(key: "Order Number:", value: ticket)
            eventDataDetailsView.addEventRow(eventRowTwo)
            
            if let e_date = event.formatDate() {
                let eventRowThree = EventDetailRowView()
                eventRowThree.config(key: "Date/time:", value: e_date)
                eventDataDetailsView.addEventRow(eventRowThree)
            }
            
            let eventRowFour = EventDetailRowView()
            eventRowFour.config(key: "Number of Person(s):", value: "\(event.guests) Person(s)", fontWeight: .bold)
            eventDataDetailsView.addEventRow(eventRowFour)
            
            let eventRowFive = EventDetailRowView()
            eventRowFive.config(key: "Price", value: "\(event.price)")
            eventDataDetailsView.addEventRow(eventRowFive, false)
        } else {
            eventTitleLabel.config("Title Not available")
        }
        
        NSLayoutConstraint.activate([
            statusView.topAnchor.constraint(equalTo: self.view.topAnchor),
            statusView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            statusView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            statusView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3),
            
            ScanAgainButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            ScanAgainButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            ScanAgainButton.heightAnchor.constraint(equalToConstant: 50),
            ScanAgainButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            
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

}
