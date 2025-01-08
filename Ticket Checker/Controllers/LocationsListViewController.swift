//
//  LocationsListViewController.swift
//  Ticket Checker
//
//  Created by Zaytech Mac on 11/12/2024.
//

import UIKit

// MARK: - Custom TableViewCell
class LocationCell: UITableViewCell {
    static let identifier = "LocationCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .systemGray3
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(locationImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            locationImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            locationImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            locationImageView.widthAnchor.constraint(equalToConstant: 40),
            locationImageView.heightAnchor.constraint(equalToConstant: 40),
            
            nameLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 12),
            nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -12),
            
            chevronImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            chevronImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 20),
            chevronImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configure(with merchant: Merchant) {
        if let url = URL(string: merchant.locations.first??.logoUrl ?? "") {
            locationImageView.loadImage(from: url)
        }else {
            locationImageView.image = UIImage(systemName: "fork.knife")
        }
        
        nameLabel.text = merchant.name
    }
}

// MARK: - Empty State View
class EmptyStateView: UIView {
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "mappin.slash.circle")
        imageView.tintColor = .systemGray2
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "No Locations Available"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .darkGray
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "There are no locations to display at this time."
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            
            imageView.heightAnchor.constraint(equalToConstant: 60),
            imageView.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
}

// MARK: - LocationsListViewController
class LocationsListViewController: UIViewController {
    
    private var merchants: [Merchant] // Update 2

        init(merchants: [Merchant]) { // Update 1
            self.merchants = merchants
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) { // Update 1
            fatalError("init(coder:) has not been implemented")
        }

    
    private let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .systemGray6
        table.separatorStyle = .none
        table.rowHeight = 72
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let emptyStateView = EmptyStateView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Select the location of the event:"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        getMerchants()
    }
    
    private func setupView() {
        view.backgroundColor = .systemGray6
        
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LocationCell.self, forCellReuseIdentifier: LocationCell.identifier)
    }
    
    private func updateUI() {
        if merchants.isEmpty {
            showEmptyState()
        } else {
            hideEmptyState()
        }
        tableView.reloadData()
    }
    
    private func showEmptyState() {
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyStateView)
        
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            emptyStateView.widthAnchor.constraint(equalTo: tableView.widthAnchor)
        ])
    }
    
    private func hideEmptyState() {
        emptyStateView.removeFromSuperview()
    }
    
    // Public method to update locations
    func updateMerchants(_ newMerchants: [Merchant]) {
        merchants = newMerchants
        updateUI()
    }
    func getMerchants() {
        MerchantsModal.shared.fetchLocations { [weak self] result in
            switch result {
                case .success(result: let merchants):
                    self?.updateMerchants(merchants)
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}

// MARK: - UITableView Delegate & DataSource
extension LocationsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return merchants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.identifier, for: indexPath) as? LocationCell else {
            return UITableViewCell()
        }
        
        let merchant = merchants[indexPath.row]
        cell.configure(with: merchant)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLocation = merchants[indexPath.row]
        guard let slug = selectedLocation.slug else {
            return
        }
        UserDefaultsManager.shared.saveMerchant(slug: slug)
        let qrScannerVC = QRScannerViewController()
        self.setRootViewController(qrScannerVC)
    }
    private func setRootViewController(_ viewController: UIViewController) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = viewController
            window.makeKeyAndVisible()
        }
    }
}
