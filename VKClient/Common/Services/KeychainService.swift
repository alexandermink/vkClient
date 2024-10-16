//
//  KeychainService.swift
//  VKClient
//
//  Created by Александр Минк on 30.09.2024.
//

import Security
import Foundation

class KeychainService {
    
    static let shared = KeychainService()
    
    private init() {}
    
    // Метод для сохранения данных в Keychain
    func save(key: String, value: String) {
        // Преобразуем строку в данные
        guard let data = value.data(using: .utf8) else { return }
        
        // Создаем запрос для Keychain с указанием ключа и данных
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword, // Тип данных — пароль
            kSecAttrAccount as String: key,                // Ключ, по которому сохраняется значение
            kSecValueData as String: data                  // Сохраняемые данные
        ]
        
        // Удаляем старое значение, если оно есть
        SecItemDelete(query as CFDictionary)
        // Добавляем новые данные в Keychain
        SecItemAdd(query as CFDictionary, nil)
    }
    
    // Метод для загрузки данных из Keychain
    func load(key: String) -> String? {
        // Создаем запрос для поиска данных по ключу
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword, // Тип данных — пароль
            kSecAttrAccount as String: key,                // Ключ, по которому нужно найти данные
            kSecReturnData as String: kCFBooleanTrue!,     // Возвращаемые данные
            kSecMatchLimit as String: kSecMatchLimitOne    // Ограничение — вернуть только один результат
        ]
        
        var dataTypeRef: AnyObject?
        // Поиск данных в Keychain
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        // Проверяем, удалось ли найти данные и преобразуем их в строку
        guard status == errSecSuccess, let data = dataTypeRef as? Data else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    // Метод для удаления данных из Keychain
    func delete(key: String) {
        // Создаем запрос для удаления данных по ключу
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword, // Тип данных — пароль
            kSecAttrAccount as String: key                 // Ключ, по которому нужно удалить данные
        ]
        
        // Удаляем данные из Keychain
        SecItemDelete(query as CFDictionary)
    }
}
