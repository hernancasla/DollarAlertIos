import Foundation

struct ExchangeRate: Identifiable, Codable {
    let exchanges: [CurrencyData]
    let date: Date
    let id = UUID()
}
struct CurrencyData: Identifiable, Codable {
    let sellValue: Double
    let buyValue: Double
    let type: String
    let id = UUID()
}
