//
//  SwiftUIView.swift
//  DollarAlert
//
//  Created by Osvaldo Ceballos on 06/07/2023.
//

import SwiftUI

struct CurrencyGridView: View {
    let currencies: [String] = ["USD", "EUR", "GBP", "JPY", "CAD", "AUD", "CHF", "CNY"]
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        VStack(spacing: 10) {
            if horizontalSizeClass == .compact {
                // Diseño vertical
                ForEach(0..<4) { row in
                    HStack(spacing: 10) {
                        ForEach(0..<2) { column in
                            let index = row * 2 + column
                            
                            createPanelView(index: index, size: CGSize(width: UIScreen.main.bounds.width * 0.35, height: UIScreen.main.bounds.height * 0.13))
                        }
                    }
                }
            } else {
                // Diseño horizontal
                ForEach(0..<2) { row in
                    HStack(spacing: 10) {
                        ForEach(0..<4) { column in
                            let index = row * 4 + column
                            
                            createPanelView(index: index, size: CGSize(width: UIScreen.main.bounds.width * 0.22, height: 120))
                        }
                    }
                }
            }
        }
        .padding()
    }
    
    func createPanelView(index: Int, size: CGSize) -> some View {
        VStack(spacing: 3) {
            Text("\(123.456, specifier: "%.3f")")
                .font(.system(size: 20, weight: .bold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(Color.white)
                .cornerRadius(8)
            
            Text("Moneda")
                .font(.system(size: 14, weight: .regular))
            
            Text("Información adicional")
                .font(.system(size: 12, weight: .regular))
        }
        .frame(width: size.width, height: size.height)
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
    }
}

struct CurrencyGridViewPreviews: PreviewProvider {
    static var previews: some View {
        CurrencyGridView()
    }
}
