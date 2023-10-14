import SwiftUI
import GoogleMobileAds


struct CurrencyGridView: View {
    private let currencyService = CurrencyService.shared
    //@ObservedObject private var exchange: ExchangeRateData?
    //@ObservedObject private var exchangeHistory: ExchangeHistory?
    @State private var timer: Timer?
    @State private var isLinkActive = false
    @ObservedObject var viewModel: ViewModel = ViewModel()


    var body: some View {

        VStack {
            ToolBarView(viewModel: viewModel)
            HStack {
                
                Text("Compra")
                        .font(.headline)
                        .padding(.horizontal, 25)
                        .offset(y: 5)
                        .foregroundColor(.green)


                Spacer()
                VStack{
                    Text("Última Actualización").font(.system(size: 12))
                    if viewModel.isLoading {
                        Text("...")
                    } else if let exchangeData = viewModel.exchange {
                        Text(formateDate(date: exchangeData.date))
                            .font(.system(size: 12, weight: .bold)) // Cambia el tamaño y el peso de la fuente

                    }
                }.offset(y: 5)
                Spacer()
                Text("Venta")
                        .font(.headline)
                        .padding(.horizontal, 25)
                        .offset(y: 5)
                        .foregroundColor(.red)
            }
            
            if viewModel.isLoading {
                Text("Cargando datos...")
            }
            if let exchangeData = viewModel.exchange {
                
                    List(exchangeData.exchanges) { exchangeRate in
                        
                        NavigationLink(destination: ExchangeDetail(type: exchangeRate.type, history: viewModel.exchangeHistory)) {
                            ExchangeRateRow(exchangeRate: exchangeRate)
                        }
                    }
            } else {
                Text("No se pudo cargar la información.")
            }
        }.onAppear {
            if let exchangeData = viewModel.exchange {
                
            } else {
                viewModel.fetchData(withLoading: true)
                DispatchQueue.global(qos: .background).async {
                    viewModel.fetchHistoryData()
                }
                
                scheduleTimer()
            }
        }.toolbarBackground(Color(red: 48 / 255.0, green: 159 / 255.0, blue: 204 / 255.0),for: .navigationBar)
               .toolbarBackground(.visible, for: .navigationBar)
                   
        

    }
    
    
    struct ExchangeDetail: View {
        var type: String
        var history: ExchangeHistory?

        var body: some View {
            VStack {
                HStack {
                    
                    Text("Compra")
                            .font(.headline)
                            .padding(.horizontal, 25)
                            .offset(y: 5)
                            .foregroundColor(.green)

                    Spacer()
                    Text("Fecha")
                        .padding(.horizontal, 25)
                        .offset(y: 5)

                    Spacer()
                    Text("Venta")
                            .font(.headline)
                            .padding(.horizontal, 25)
                            .offset(y: 5)
                            .foregroundColor(.red)
                }
                if let value = history {
                    
                     getHistoryByType(type: type, exchangeHistory: value)
                    
                }
            }
            .navigationTitle("Dolar \(type)")
            .toolbarBackground(Color(red: 48 / 255.0, green: 159 / 255.0, blue: 204 / 255.0),for: .navigationBar)
                   .toolbarBackground(.visible, for: .navigationBar)
        }
        func getHistoryByType(type: String, exchangeHistory: ExchangeHistory) -> some View{
            var groupedData = [String: (Double, Double, Double)]()
            let counttype = exchangeHistory.dollarHistory.filter { $0.exchanges.contains { $0.type == type } }.count

            for exchangeData in exchangeHistory.dollarHistory {
                    for exchangeInfo in exchangeData.exchanges where exchangeInfo.type == type {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd/MM/yyyy"
                        let date = dateFormatter.string(from: exchangeData.date)
                        
                        if groupedData[date] == nil {
                            groupedData[date] = (0, 0, 0)
                        }
                        
                        groupedData[date]!.0 += exchangeInfo.sellValue
                        groupedData[date]!.1 += exchangeInfo.buyValue
                        groupedData[date]!.2 += 1
                    }
                }
            let sortedKeys = groupedData.keys.sorted().reversed()
            let filteredData = sortedKeys.map { key in
                (key, groupedData[key]!.0 / groupedData[key]!.2, groupedData[key]!.1 / groupedData[key]!.2)
            }
            return List {
                ForEach(filteredData, id: \.0) { item in
                    let (date, averageSellValue, averageBuyValue) = item
                    HStack{

                        Text(String(format: "$ %.0f", averageBuyValue))
                                .font(.system(size: 18, weight: .bold))
                                .padding(.trailing, -6)

                        let decimalPart = averageBuyValue - Double(Int(averageBuyValue))
                        let decimalInt = Int(decimalPart * 100)

                        Text(formatNumber(decimalInt))
                                .font(.system(size: 10, weight: .bold))
                                .padding(.bottom, 6)

                        Spacer()
                        Text(date)
                        Spacer()
                        Text(String(format: "$ %.0f", averageSellValue))
                                .font(.system(size: 18, weight: .bold))
                                .padding(.trailing, -6)

                        let decimalPartSell = averageSellValue - Double(Int(averageSellValue))
                        let decimalIntSell = Int(decimalPartSell * 100)

                        Text(formatNumber(decimalIntSell))
                                .font(.system(size: 10, weight: .bold))
                                .padding(.bottom, 6)
                        
                    }
                }
            }
        }
    }
    
    private func scheduleTimer() {
        self.timer?.invalidate()

        self.timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { _ in
            viewModel.fetchData(withLoading: false)
        }
    }

    struct ExchangeRateRow: View {
        let exchangeRate: ExchangeRate

        var body: some View {
            VStack {
                //.frame(height: 30)
                Text("Dólar \(exchangeRate.type)").font(.system(size: 14, weight: .medium))//.offset(y: 5)
                // Cambia el color de fondo según tus preferencias
                // .foregroundColor(.white)
                HStack {
                    Text(String(format: "$ %.0f", exchangeRate.buyValue))
                            .font(.system(size: 18, weight: .bold))
                            .padding(.trailing, -6)

                    let decimalPart = exchangeRate.buyValue - Double(Int(exchangeRate.buyValue))
                    let decimalInt = Int(decimalPart * 100)

                    Text(formatNumber(decimalInt))
                            .font(.system(size: 10, weight: .bold))
                            .padding(.bottom, 6)

                    Spacer()
                    Image("\(exchangeRate.type.lowercased())-dollar")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48, height: 48)
                    Spacer()
                    Text(String(format: "$ %.0f", exchangeRate.sellValue))
                            .font(.system(size: 18, weight: .bold))
                            .padding(.trailing, -6)

                    let decimalPartSell = exchangeRate.sellValue - Double(Int(exchangeRate.sellValue))
                    let decimalIntSell = Int(decimalPartSell * 100)

                    Text(formatNumber(decimalIntSell))
                            .font(.system(size: 10, weight: .bold))
                            .padding(.bottom, 6)
                }
            }
        }
        
    }

    func formateDate(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm" // Establece el formato deseado

        return dateFormatter.string(from: date)
    }

    
}
func formatNumber(_ number: Int) -> String {
    // Convierte el número en una cadena
    let numberString = String(number)

    // Verifica si la cadena tiene menos de 2 caracteres
    if numberString.count < 2 {
        // Completa con ceros a la izquierda si tiene menos de 2 caracteres
        let paddedString = String(repeating: "0", count: 2 - numberString.count) + numberString
        return paddedString
    } else {
        // Toma los primeros 2 caracteres de la cadena
        let startIndex = numberString.startIndex
        let endIndex = numberString.index(startIndex, offsetBy: 2)
        let firstTwoDigits = numberString[startIndex..<endIndex]
        return String(firstTwoDigits)
    }
}

class ViewModel: ObservableObject {
    @Published var exchange: ExchangeRateData?
    @Published var exchangeHistory: ExchangeHistory?
    @Published var isLoading = false

    func fetchData(withLoading: Bool) {
        isLoading = true && withLoading

        CurrencyService.shared.fetchExchangeData { result in
            DispatchQueue.main.async {
                self.isLoading = false

                switch result {
                case .success(let data):
                    if(data.date !=  self.exchange?.date){
                        self.exchange = data
                    }
                    print("actualizacion")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
    func fetchHistoryData() {
        CurrencyService.shared.fetchExchangeHistory { result in
            DispatchQueue.main.async {

                switch result {
                case .success(let data):
                    self.exchangeHistory = data
                    print("actualizacion")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
}
