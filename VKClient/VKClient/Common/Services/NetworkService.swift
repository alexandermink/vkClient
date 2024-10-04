//
//  NetworkService.swift
//  VKClient
//
//  Created by Александр Минк on 03.10.2024.
//

import Network
import Combine

class NetworkService {

    static let shared = NetworkService()
    
    private var monitor: NWPathMonitor // Объект для мониторинга сетевых подключений
    private let queue = DispatchQueue.global(qos: .background) // Фоновая очередь для мониторинга сети
    @Published var isConnected: Bool = true // Публикуемое свойство для отслеживания состояния подключения
    
    private init() {
        monitor = NWPathMonitor()
        // Обработчик изменений сетевого состояния
        monitor.pathUpdateHandler = { [weak self] path in
            // Обновляем состояние подключения на главной очереди
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        // Запускаем мониторинг сети на фоновом потоке
        monitor.start(queue: queue)
    }

    // Метод для перезапуска мониторинга сети
    func restartMonitor() {
        monitor.cancel() // Останавливаем текущий монитор
        // Создаем новый монитор для отслеживания изменений сети
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            // Обновляем состояние подключения на главной очереди
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        // Запускаем новый монитор на фоновом потоке
        monitor.start(queue: queue)
    }
}
