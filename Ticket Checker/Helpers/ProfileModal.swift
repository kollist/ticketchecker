//
//  ProfileModal.swift
//  Ticket Checker
//
//  Created by Zaytech Mac on 12/12/2024.
//


import Foundation
import Alamofire

class ProfileModal {
    static let shared = ProfileModal()
    private init() {}
    
    func fetchProfile(completion: @escaping (Result<User, Error>) -> Void) {
        guard let token = UserDefaultsManager.shared.getToken().accessToken else {
            completion(.failure(NSError(domain: "ProfileModal", code: 401, userInfo: [NSLocalizedDescriptionKey: "No access token found"])))
            return
        }
        let profile = SOOApi.profile(token: token)
        NetworkManager.shared.request(sooApi: profile) { result in
            switch result {
            case .success(let data):
                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /*
    func updateProfile(name: String, email: String, completion: @escaping (Result<User, Error>) -> Void) {
        guard let token = UserDefaultsManager.shared.getToken().accessToken else {
            completion(.failure(NSError(domain: "ProfileModal", code: 401, userInfo: [NSLocalizedDescriptionKey: "No access token found"])))
            return
        }
        
        let path = "https://api-v2-sandbox.smartonlineorders.com/v2/users/profile"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        let parameters: [String: Any] = [
            "name": name,
            "email": email
        ]
        
        NetworkManager.shared.request(path: path, method: .put, parameters: parameters, headers: headers) { result in
            switch result {
            case .success(let data):
                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    self.saveProfileLocally(user)
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
     */
}

