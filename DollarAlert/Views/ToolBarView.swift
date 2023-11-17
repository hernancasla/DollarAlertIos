//
//  ToolBarView.swift
//  DollarAlert
//
//  Created by Osvaldo Ceballos on 12/10/2023.
//

import SwiftUI
import FirebaseAnalytics

struct ToolBarView: View {
    @State private var isCopied = false
    @State private var isLinkActive = false
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        
        HStack {
            Button(action: {
                Analytics.logEvent("copy_action", parameters: nil)

                UIPasteboard.general.string = formattedText(exchange: viewModel.exchange!)
                isCopied = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    isCopied = false
                                }
            }) {
                VStack{
                    Image(systemName: "doc.on.doc.fill")
                        .resizable()
                                    .frame(width: 20, height: 20)
                    Text("Copiar").font(.system(size: 10, weight: .bold))

                }
            }
            
            Button(action: {
                self.isLinkActive = true
                Analytics.logEvent("simulation_action", parameters: nil)

            }) {

                VStack{
                    Image(systemName: "dollarsign.square.fill")
                        .resizable() // Hace que la imagen sea redimensionable
                                    .frame(width: 20, height: 20)
                    Text("Calcular").font(.system(size: 10, weight: .bold))
                }
            }
            .background(
                NavigationLink("", destination: SimulationView(viewModel: viewModel), isActive: $isLinkActive)
                    .opacity(0) // Hacer que el NavigationLink sea invisible
            )

            Button(action: {
                Analytics.logEvent("share_action", parameters: nil)

                let textToCopy = formattedText(exchange: viewModel.exchange!)

                if UIDevice.current.userInterfaceIdiom == .pad {

                    presentActivityViewControllerAsPopover(textToCopy: textToCopy)
                } else {
                    presentActivityViewControllerAsSheet(textToCopy: textToCopy)
                }
            }) {
                VStack{
                    Image(systemName: "square.and.arrow.up.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Compartir").font(.system(size: 10, weight: .bold))
                }
            }

            Button(action: {
                viewModel.fetchData(withLoading: true)
                Analytics.logEvent("copy_action", parameters: nil)

            }) {
                VStack{
                    Image(systemName: "arrow.counterclockwise.icloud.fill")
                        .resizable() // Hace que la imagen sea redimensionable
                                    .frame(width: 30, height: 20)
                    Text("Refrescar").font(.system(size: 10, weight: .bold))
                }
            }
        }.frame(maxWidth: .infinity)
            .padding(.vertical,5)
            .background(Color(red: 113 / 255.0, green: 191 / 255.0, blue: 223 / 255.0))
            .overlay(
                Group {
                    if isCopied {
                        VStack {
                            Spacer()
                            ToastMessageView(message: "Copiado!")
                        }
                    }
                }
            )
            
    }
}
struct SquareButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal,5)
            .padding(.vertical,5)
            .foregroundColor(.blue)
            //.background(Color.clear)
            .border(Color.blue, width: 1)
            .cornerRadius(10) // Ajusta este valor para hacer los botones más o menos cuadrados
    }
}
struct ToastMessageView: View {
    let message: String

    var body: some View {
        Text(message)
            .padding(.horizontal,10)
            .background(Color.black)
            .foregroundColor(Color.white)
            .cornerRadius(5)
    }
}

struct ToolBarView_Previews: PreviewProvider {
    static var previews: some View {
        ToolBarView(viewModel: ViewModel())
    }
}

func presentActivityViewControllerAsPopover(textToCopy: String) {
    let activityViewController = UIActivityViewController(activityItems: [textToCopy], applicationActivities: nil)
    if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
        activityViewController.popoverPresentationController?.sourceView = rootViewController.view
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: rootViewController.view.bounds.midX, y: rootViewController.view.bounds.midY, width: 0, height: 0)
        rootViewController.present(activityViewController, animated: true, completion: nil)
    }
}

func presentActivityViewControllerAsSheet(textToCopy: String) {
    let activityViewController = UIActivityViewController(activityItems: [textToCopy], applicationActivities: nil)
    if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
        rootViewController.present(activityViewController, animated: true, completion: nil)
    }
}

func formattedText(exchange: ExchangeRateData) -> String {
       var text = ""
       for exchangeRate in exchange.exchanges {
           let formatedBuyVal = String(format: "%.2f", exchangeRate.buyValue)
           let formatedSellVal = String(format: "%.2f", exchangeRate.sellValue)

           text += "*Dólar \(exchangeRate.type)*\nCompra: \(formatedBuyVal) | Venta: \(formatedSellVal)\n\n"
       }
    text += "Fecha de extracción: \(formattedDate(exchange.date))\n\n"
    text += "Descarga la aplicación Dolarizate desde el App Store: https://apps.apple.com/us/app/dolarizate/id6468905246"

       return text
   }

func formattedDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
       return dateFormatter.string(from: date)
   }

