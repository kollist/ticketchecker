//
//  LoginModal.swift
//  Ticket Checker
//
//  Created by Zaytech Mac on 15/11/2024.
//

import Foundation


class LoginModal {
    static let shared = LoginModal()
        private init() {}
        
    func login(email: String, password: String, gtoken: String, rememberMe: Bool, completion: @escaping (Result<Profile, ErrorResponse>) -> Void) {
        let sooApi = SOOApi.login(email: email, password: password, gToken: gtoken, platform: "ios", rememberMe: rememberMe)
 
        NetworkManager.shared.request(sooApi: sooApi) { result in
                switch result {
                case .success(let data):
                    do {
                        let profile = try JSONDecoder().decode(Profile.self, from: data)
                        self.handleLoginSuccess(profile, email: email, password: password)
                        completion(.success(profile))
                    } catch (let error) {
                        completion(.failure(ErrorResponse(error: error.localizedDescription)))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
    private func handleLoginSuccess(_ profile: Profile, email: String, password: String) {
            // Store sensitive data in Keychain
            _ = KeychainManager.shared.saveCredentials(email: email, password: password)
            
            // Store non-sensitive data in UserDefaults
        UserDefaultsManager.shared.saveToken(accessToken: profile.token.token, expiresIn: profile.token.expiresIn)
            
            // Store user data in UserDefaults
        UserDefaults.standard.set(profile.user?.name, forKey: "user_name")
        UserDefaults.standard.set(profile.user?.email, forKey: "email")
        UserDefaults.standard.set(profile.user?.emailVerified, forKey: "email_verified")
            
            // Store merchant data in UserDefaults
        if let firstMerchant = profile.user?.groupMerchants.first {
            UserDefaults.standard.set(firstMerchant?.name, forKey: "merchantName")
            UserDefaults.standard.set(firstMerchant?.slug, forKey: "merchantSlug")
        }
    }
}
