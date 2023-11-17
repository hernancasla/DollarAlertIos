import GoogleMobileAds

class AdMobBanner: UIViewController, GADBannerViewDelegate {
    var adView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let _adSize = GADAdSizeFromCGSize(CGSize(width: 320, height: 50))

        adView = GADBannerView(adSize: _adSize)
        adView.adUnitID = "ca-app-pub-6316074233631898/7240592580"
        adView.rootViewController = self
        adView.delegate = self

        let adRequest = GADRequest()
        //adRequest.testDevices = [kGADSimulatorID] // Esto muestra anuncios de prueba en el simulador

        adView.load(adRequest)

        // Añade el adView a tu vista donde desees mostrar el anuncio
        view.addSubview(adView)
    }
}

