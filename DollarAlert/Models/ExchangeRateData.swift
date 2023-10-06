import Foundation

struct ExchangeRateData: Codable {
    let exchanges: [ExchangeRate]
    let date: String
}
struct ExchangeRate: Identifiable, Codable {
    let sellValue: Double
    let buyValue: Double
    let type: String
    let id = UUID()
}