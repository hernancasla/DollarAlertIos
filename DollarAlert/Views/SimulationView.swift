import SwiftUI

struct SimulationView: View {
    @State  var inputValue: String = "" // Estado para almacenar el valor del campo de entrada
     var colorActive = Color(red: 113 / 255.0, green: 191 / 255.0, blue: 223 / 255.0)
     var colorInactive = Color(red: 231 / 255.0, green: 248 / 255.0, blue: 255 / 255.0)
     var foregroundColorActive = Color.white
     var foregroundColorInactive = Color.gray.opacity(0.5)
    var backgroundColor = Color(red: 48 / 255.0, green: 159 / 255.0, blue: 204 / 255.0)
    @State  var arsToUsd = true
    @ObservedObject var viewModel: ViewModel
    @State var amount : Double = 0



    var body: some View {
        VStack(alignment: .leading){
            HStack {
                    Button(action: {
                        arsToUsd = true
                    }) {
                        Text("ARS >> USD")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical,10)
                            .background(arsToUsd ? colorActive : colorInactive)
                            .foregroundColor(arsToUsd ? foregroundColorActive : foregroundColorInactive)
                            //.cornerRadius(10)
                    }
                
                    Button(action: {
                        arsToUsd = false
                    }) {
                        Text("USD >> ARS")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical,10)
                            .background(arsToUsd ? colorInactive: colorActive)
                            .foregroundColor(arsToUsd ? foregroundColorInactive : foregroundColorActive )
                            //.cornerRadius(10)
                    }
                
            }.background(colorActive)
            HStack{
                Text(arsToUsd ? "ARS" : "U$D").padding(.horizontal,5)

                TextField("Monto en \(arsToUsd ? "Pesos" : "Dólares")", text: $inputValue)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    //.foregroundColor(.black)
                    .accentColor(.gray)// Cambiar el color del texto
                    // .background(Color.white) // Cambiar el color de fondo
                Button(action: {
                    if let val = Double(inputValue){
                        amount = val
                    }
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

                }) {
                    /*Image(systemName: "x.square.fill")
                        .resizable() // Hace que la imagen sea redimensionable
                                    .frame(width: 35, height: 30)
                                    .foregroundColor(Color.red)*/
                    Text("Calcular")
                        .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.all,5)
                                    .background(backgroundColor) // Color de fondo sugerido (azul)
                                    .cornerRadius(5)
                                    .padding(.horizontal,5)
                        //.frame(maxWidth: .infinity)
                        //.padding(.vertical,10)
                        //.background(arsToUsd ? colorActive : colorInactive)
                        //.foregroundColor(arsToUsd ? foregroundColorActive : foregroundColorInactive)
                        //.cornerRadius(10)
                }
            }.padding(.vertical, 10)
            
            if amount>0,  let exchangeData = viewModel.exchange {
                Text(arsToUsd ? "Con \(formatAsCurrency(amount)) Pesos podes comprar": "Con \(formatAsCurrency(amount)) Dólares podes vender a")

                    List(exchangeData.exchanges) { exchangeRate in
                        let val = arsToUsd ? amount/exchangeRate.buyValue : exchangeRate.sellValue*amount
                        ListItemView(imageName: "\(exchangeRate.type.lowercased())-dollar", value: val, fixedText: exchangeRate.type, currency: arsToUsd ?  "U$D":"ARS")
                    }
            }
            Spacer()

            }
            //.padding()
        .navigationTitle("Simulador")
        .toolbarBackground(backgroundColor,for: .navigationBar)
               .toolbarBackground(.visible, for: .navigationBar)
        }
    var numberFormatter: NumberFormatter {
            let formatter = NumberFormatter()
            formatter.numberStyle = .none
            return formatter
    }
    var currencyFormatter: NumberFormatter{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0 // Establece cero decimales
        formatter.currencyGroupingSeparator = "." // Separador de miles
           formatter.currencyDecimalSeparator = "," // Separador decimal
        return formatter
    }
    func formatAsCurrency(_ number: Int) -> String {

            return currencyFormatter.string(from: NSNumber(value: number)) ?? ""
        }
    func formatAsCurrency(_ number: Double) -> String {

            return currencyFormatter.string(from: NSNumber(value: number)) ?? ""
        }
}
struct ListItemView: View {
    let imageName: String
    let value: Double
    let fixedText: String
    let currency: String

    var body: some View {
        HStack {
            Text(currency)
            
            Divider()
            Text(formatAsCurrency(Int(value)))
                    .font(.system(size: 18, weight: .bold))
                    .padding(.trailing, -6)

            let decimalPart = value - Double(Int(value))
            let decimalInt = Int(decimalPart * 100)
            Text(formatNumber(decimalInt))
                    .font(.system(size: 10, weight: .bold))
                    .padding(.bottom, 6)
            Spacer()
            //Divider()
            Text(fixedText) // Texto fijo a la derecha
                .foregroundColor(.gray)
            //Divider()
            ZStack{
                Image(imageName)
                    .resizable()
                //.scaledToFit()
                    .frame(width: 55, height: 55)
                //.cornerRadius(10)
                    .padding(.vertical,-18)
                    .offset(x:15)
            }                    .frame(width: 15, height: 25)

                
                
            
        }
    }
}

struct SimulationView_Previews: PreviewProvider {
    static var previews: some View {
        SimulationView(viewModel: ViewModel())
    }
}

func formatAsCurrency(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0 // Establece cero decimales
        formatter.currencyGroupingSeparator = "." // Separador de miles
           formatter.currencyDecimalSeparator = "," // Separador decimal
    
        return formatter.string(from: NSNumber(value: number)) ?? ""
    }


