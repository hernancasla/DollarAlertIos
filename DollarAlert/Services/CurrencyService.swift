//
// Created by Osvaldo Ceballos on 30/09/2023.
//

import Foundation

class CurrencyService {
    static let shared = CurrencyService()
    enum NetworkError: Error {
        case invalidURL
        case networkError(Error)
        case decodingError(Error)
    }
    func fetchExchangeData(completion: @escaping (Result<ExchangeRateData, NetworkError>) -> Void) {
        let timestamp = Date().timeIntervalSince1970 // Genera un timestamp único

        guard let url = URL(string: "https://globalcaslas3.s3.eu-west-3.amazonaws.com/public/dollarPrice.json?t=\(timestamp)") else {
            completion(.failure(.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
                    if let error = error {
                        completion(.failure(.networkError(error)))
                        return
                    }

                    if let data = data {
                        do {
                            let decoder = JSONDecoder()
                            decoder.dateDecodingStrategy = .iso8601
                            let exchangeData = try decoder.decode(ExchangeRateData.self, from: data)
                            completion(.success(exchangeData))
                        } catch {
                            completion(.failure(.decodingError(error)))
                        }
                    }
                }.resume()
    }
    
    func fetchExchangeHistory(completion: @escaping (Result<ExchangeHistory, NetworkError>) -> Void) {
        let timestamp = Date().timeIntervalSince1970 // Genera un timestamp único

        guard let url = URL(string: "https://globalcaslas3.s3.eu-west-3.amazonaws.com/public/dollarPriceHistory.json?t=\(timestamp)") else {
            completion(.failure(.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
                    if let error = error {
                        completion(.failure(.networkError(error)))
                        return
                    }

                    if let data = data {
                        do {
                            let decoder = JSONDecoder()
                            decoder.dateDecodingStrategy = .iso8601
                            let exchangeData = try decoder.decode(ExchangeHistory.self, from: data)
                            

                            completion(.success(exchangeData))
                        } catch {
                            completion(.failure(.decodingError(error)))
                        }
                    }
                }.resume()
    }
}
