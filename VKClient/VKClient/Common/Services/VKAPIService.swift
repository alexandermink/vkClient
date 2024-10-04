//
//  VKAPIService.swift
//  VKClient
//
//  Created by Александр Минк on 03.10.2024.
//

import Alamofire
import Combine

// MARK: - VKAPIConfig
struct VKAPIConfig {
    // Базовый URL для запросов к VK API
    static let baseURL = "https://api.vk.com/method/"
    // Версия API
    static let apiVersion = "5.199"
    
    // Функция для получения токена доступа из Keychain
    static func getAccessToken() -> String? {
        return KeychainService.shared.load(key: "vk_access_token")
    }
}

// MARK: - VKAPIService
class VKAPIService {
    // Функция для выполнения запроса к VK API
    // Параметры:
    // method - название метода API (например, "newsfeed.get")
    // parameters - параметры запроса (например, фильтры)
    // responseType - тип данных, которые вернет API (Decodable)
    func performRequest<T: Decodable>(method: String, parameters: [String: Any], responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        // Получаем токен доступа из Keychain
        guard let accessToken = VKAPIConfig.getAccessToken() else {
            // Если токен не найден, возвращаем ошибку
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No access token found"])))
            return
        }
        
        // Добавляем токен доступа и версию API к параметрам запроса
        var allParameters = parameters
        allParameters["access_token"] = accessToken
        allParameters["v"] = VKAPIConfig.apiVersion
        
        // Формируем полный URL для запроса
        let url = VKAPIConfig.baseURL + method
        
        AF.request(url, method: .get, parameters: allParameters)
            .validate() // Проверяем успешность запроса (код 200)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
