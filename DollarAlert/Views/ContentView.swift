//
//  ContentView.swift
//  DollarAlert
//
//  Created by Osvaldo Ceballos on 06/07/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
            NavigationView {
                CurrencyGridView().navigationBarTitle("Cotización del Dólar", displayMode: .inline)
            }.navigationViewStyle(StackNavigationViewStyle())
            .accentColor(.white)


        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
