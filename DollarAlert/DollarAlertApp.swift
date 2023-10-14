//
//  DollarAlertApp.swift
//  DollarAlert
//
//  Created by Osvaldo Ceballos on 06/07/2023.
//

import SwiftUI
import GoogleMobileAds

@main
struct DollarAlertApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {

            ContentView()
            AdBannerView().frame(width: UIScreen.main.bounds.size.width, height: 50)

        }
    }
    
}



struct CurrencyGridViewPreviews: PreviewProvider {
    static var previews: some View {
        CurrencyGridView()
        
    }
}


struct AdBannerView: UIViewRepresentable {
    func makeUIView(context: Context) -> GADBannerView {
        let bannerView = GADBannerView(adSize: GADAdSize.init())
        bannerView.adUnitID = "ca-app-pub-6316074233631898/4304065378"
        //bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = UIApplication.shared.windows.first?.rootViewController
        return bannerView
    }

    func updateUIView(_ uiView: GADBannerView, context: Context) {
        let request = GADRequest()
        uiView.load(request)
    }
}
