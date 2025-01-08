//
//  LocationModal.swift
//  Ticket Checker
//
//  Created by Zaytech Mac on 16/12/2024.
//

import Foundation

class MerchantsModal {
    static let shared = MerchantsModal()
    private init() {}
    
    func fetchLocations(completion: @escaping (Result<[Merchant], Error>) -> Void) {
        guard let token = UserDefaultsManager.shared.getToken().accessToken else {
            completion(.failure(NSError(domain: "LocationModal", code: 401, userInfo: [NSLocalizedDescriptionKey: "No access token found"])))
            return
        }
        
        let profile = SOOApi.merchants(token: token)
        print(profile.url)
        NetworkManager.shared.request(sooApi: profile) { result in
            switch result {
                case .success(let data):
                    do {
                        let merchants = try JSONDecoder().decode([Merchant].self, from: data)
                        completion(.success(merchants))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
