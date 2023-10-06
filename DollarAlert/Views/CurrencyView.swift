import SwiftUI
import UIKit
import GoogleMobileAds


struct CurrencyGridView: View {
    private let currencyService = CurrencyService.shared
    @State private var exchange: ExchangeRateData?
    @State private var isLoading = false

    var body: some View {

        VStack {
            HStack {
                
                Text("Compra")
                        .font(.headline)
                        .padding(.horizontal, 25)
                        .offset(y: 5)
                        .foregroundColor(.green)


                Spacer()

                Text("Venta")
                        .font(.headline)
                        .padding(.horizontal, 25)
                        .offset(y: 5)
                        .foregroundColor(.red)


            }
                    //.foregroundColor(.blue)
//                    .background(Color.pink)
            if isLoading {
                Text("Cargando datos...")
            } else if let exchangeData = exchange {
                List(exchangeData.exchanges) { exchangeRate in
                    ExchangeRateRow(exchangeRate: exchangeRate)
                }
            } else {
                Text("No se pudo cargar la información.")
            }
        }.onAppear {
                    fetchData()
                }.toolbarBackground(Color.mint,for: .navigationBar)
                //.toolbarBackground(Image("background-img"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
        

    }
    struct DeviceRotationViewModifier: ViewModifier {
        let action: (UIDeviceOrientation) -> Void

        func body(content: Content) -> some View {
            content
                    .onAppear()
                    .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                        action(UIDevice.current.orientation)
                    }
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
    func createPanelView(size: CGSize, currency: String, operation: String, value: Double) -> some View {
        VStack(spacing: 3) {

            HStack {

                Image("\(operation.lowercased())-img")
                        .font(.system(size: 10)).offset(x: -5)

                Text(String(format: "$ %.0f", value))
                        .font(.system(size: 18, weight: .bold))
                        .padding(.trailing, -6)

                let decimalPart = value - Double(Int(value))
                let decimalInt = Int(decimalPart * 100)

                Text(formatNumber(decimalInt))
                        .font(.system(size: 10, weight: .bold))
                        .padding(.bottom, 6)

            }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)

            /*Text(currency + "/ " + operation)
                .font(.system(size: 14, weight: .regular))*/

            /*Text("Información adicional")
                .font(.system(size: 12, weight: .regular))*/
        }

    }



    func fetchData() {
        isLoading = true

        CurrencyService.shared.fetchExchangeData { result in
            DispatchQueue.main.async {
                isLoading = false

                switch result {
                case .success(let data):
                    exchange = data
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
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
