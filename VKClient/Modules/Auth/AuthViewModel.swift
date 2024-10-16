//
//  AuthViewModel.swift
//  VKClient
//
//  Created by Александр Минк on 30.09.2024.
//

import Combine
import Foundation
import Network

class AuthViewModel: ObservableObject {
    @Published var loginURL: URL?
    @Published var isLoggedIn: Bool = false
    @Published var showNoInternetPlaceholder = false // Показать заглушку при отсутствии интернета
    
    private var cancellables = Set<AnyCancellable>()
    private let networkService = NetworkService.shared

    init() {
        configureLoginURL()
        checkIfLoggedIn()
        
        // Подписываемся на изменения статуса сети
        NetworkService.shared.$isConnected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                self?.showNoInternetPlaceholder = !isConnected
            }
            .store(in: &cancellables)
    }

    
    private func configureLoginURL() {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "oauth.vk.com"
        components.path = "/authorize"
        
        components.queryItems = [
            URLQueryItem(name: "client_id", value: "YOUR_APP_ID"),
            URLQueryItem(name: "display", value: "page"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "friends,pages,wall,groups"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.199")
        ]

        if let url = components.url {
            self.loginURL = url
        } else {
            print("Error: Could not create VK login URL")
        }
    }

    func handleCallback(url: URL) {
        
        guard networkService.isConnected else {
            print("No internet connection")
            self.showNoInternetPlaceholder = true
            return
        }
        
        guard let fragment = url.fragment else {
            print("Error: URL does not contain fragment")
            return
        }

        let components = fragment
            .split(separator: "&")
            .map { $0.split(separator: "=") }
        
        var token: String?

        for component in components {
            if component.first == "access_token", component.count == 2 {
                token = String(component.last!)
                break
            }
        }

        if let accessToken = token {
            print("Получен токен: \(accessToken)")
            KeychainService.shared.save(key: "vk_access_token", value: accessToken)
//            KeychainService.shared.delete(key: "vk_access_token") // Можно использовать для реализации выхода из аккаунта
            isLoggedIn = true
        } else {
            print("Error: Could not extract access token")
        }
    }
    
    func checkInternetConnection() {
        
        networkService.restartMonitor()
        
        if networkService.isConnected {
            DispatchQueue.main.async {
                self.showNoInternetPlaceholder = false
            }
        }
    }

    private func checkIfLoggedIn() {
        if let _ = KeychainService.shared.load(key: "vk_access_token") {
            isLoggedIn = true
        }
    }
}
