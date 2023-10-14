import Foundation

struct ExchangeRateData: Codable {
    let exchanges: [ExchangeRate]
    let date: Date
    
    private enum CodingKeys: String, CodingKey {
           case exchanges, date
       }

       init(from decoder: Decoder) throws {
           let container = try decoder.container(keyedBy: CodingKeys.self)

           exchanges = try container.decode([ExchangeRate].self, forKey: .exchanges)

           let dateString = try container.decode(String.self, forKey: .date)
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

           if let date = dateFormatter.date(from: dateString) {
               self.date = date
           } else {
               throw DecodingError.dataCorruptedError(forKey: .date, in: container, debugDescription: "Date string does not match expected format")
           }
       }
   
}
struct ExchangeRate: Identifiable, Codable {
    let sellValue: Double
    let buyValue: Double
    let type: String
    let id = UUID()

}

struct ExchangeHistory: Decodable {
        let dollarHistory: [ExchangeRateData]
    }
