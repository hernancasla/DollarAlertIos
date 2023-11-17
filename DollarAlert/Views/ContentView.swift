//
//  ContentView.swift
//  DollarAlert
//
//  Created by Osvaldo Ceballos on 06/07/2023.
//

import SwiftUI
import FirebaseAnalytics

struct ContentView: View {
    @State private var actionExecuted = false

    var body: some View {
            NavigationView {
                CurrencyGridView().navigationBarTitle("Cotización del Dólar", displayMode: .inline)
            }.navigationViewStyle(StackNavigationViewStyle())
            .accentColor(.white)
            .onAppear{
                registerEvent(event: "Login")

            }

        
        
    }
    func registerEvent(event: String) -> Void{
        if !actionExecuted {
            Analytics.logEvent(event, parameters: nil)
        }
        actionExecuted = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
