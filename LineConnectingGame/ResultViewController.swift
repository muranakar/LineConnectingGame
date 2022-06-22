//
//  ResultViewController.swift
//  LineConnectingGame
//
//  Created by 村中令 on 2022/06/18.
//

import UIKit
import StoreKit
import GoogleMobileAds

class ResultViewController: UIViewController {
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var correntNumLabel: UILabel!
    @IBOutlet private weak var coinLabel: UILabel!
    @IBOutlet weak private var bannerView: GADBannerView!  // 追加したUIViewを接続

    private var correntNum: Int
    private var coin: Int

    private var interstitial: GADInterstitialAd?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewLabel()
        configureViewButton()
        configureAdBannar()
        // インタースティシャル広告
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:"ca-app-pub-3713368437594912/5360416890",
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitial = ad
            interstitial?.fullScreenContentDelegate = self
        }
        )
    }
    
    required init?(coder: NSCoder,correntNum: Int, coin: Int) {
        self.correntNum = correntNum
        self.coin = coin
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func backButtonAction(_ sender: Any) {
        // 広告を３回に、１回表示する処理
        let adNum = GADRepository.processAfterAddGADNumPulsOneAndSaveGADNum()
        let reviewNum = ReviewRepository.processAfterAddReviewNumPulsOneAndSaveReviewNum()

        if reviewNum == 5 || reviewNum == 20{
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        }

        if adNum % 3 == 0 {
            if interstitial != nil {
                interstitial?.present(fromRootViewController: self)
            } else {
                performSegue(withIdentifier: "initial", sender: nil)
            }
        } else {
            performSegue(withIdentifier: "initial", sender: nil)
        }
    }


    @IBAction func shareTwitter(_ sender: Any) {
        shareOnTwitter()
    }

    @IBAction func shareLine(_ sender: Any) {
        shareOnLine()
    }

    func shareOnTwitter() {
        //シェアするテキストを作成
        let text = "【つなぐもじ】コインを合計\(coin)枚獲得！"
        let hashTag = "#発達支援#高次脳機能#注意力#学習障害#脳トレ\nhttps://apps.apple.com/jp/app/%E3%81%A4%E3%81%AA%E3%81%90%E3%82%82%E3%81%98%E3%83%BC%E5%90%8C%E3%81%98%E6%96%87%E5%AD%97%E3%82%92%E3%81%A4%E3%81%AA%E3%81%92%E3%82%88%E3%81%86%E3%83%BC/id1630835450"
        let completedText = text + "\n" + hashTag

        //作成したテキストをエンコード
        let encodedText = completedText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        //エンコードしたテキストをURLに繋げ、URLを開いてツイート画面を表示させる
        if let encodedText = encodedText,
           let url = URL(string: "https://twitter.com/intent/tweet?text=\(encodedText)") {
            UIApplication.shared.open(url)
        }
    }

    func shareOnLine() {
        let urlscheme: String = "https://line.me/R/share?text="
        let message = "【つなぐもじ】コインを合計\(coin)枚獲得！\nhttps://apps.apple.com/jp/app/%E3%81%A4%E3%81%AA%E3%81%90%E3%82%82%E3%81%98%E3%83%BC%E5%90%8C%E3%81%98%E6%96%87%E5%AD%97%E3%82%92%E3%81%A4%E3%81%AA%E3%81%92%E3%82%88%E3%81%86%E3%83%BC/id1630835450"

        // line:/msg/text/(メッセージ)
        let urlstring = urlscheme + "/" + message

        // URLエンコード
        guard let  encodedURL = urlstring.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else {
            return
        }

        // URL作成
        guard let url = URL(string: encodedURL) else {
            return
        }

        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: { (succes) in
                    //  LINEアプリ表示成功
                })
            }else{
                UIApplication.shared.openURL(url)
            }
        }else {
            // LINEアプリが無い場合
            let alertController = UIAlertController(title: "エラー",
                                                    message: "LINEがインストールされていません",
                                                    preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
            present(alertController,animated: true,completion: nil)
        }
    }
    private func configureAdBannar() {
        // GADBannerViewのプロパティを設定
        bannerView.adUnitID = "\(GoogleAdID.bannerID)"
        bannerView.rootViewController = self

        // 広告読み込み
        bannerView.load(GADRequest())
    }
    private func configureViewLabel() {
        correntNumLabel.text = "×  \(correntNum)"
        coinLabel.text = "×  \(coin)"
    }
    private func configureViewButton() {
        backButton.tintColor = UIColor(named: "string")!
        backButton.layer.cornerRadius = backButton.frame.width / 2
        backButton.layer.borderWidth = 3
        backButton.layer.borderColor = UIColor(named: "string")!.cgColor
    }
}

extension ResultViewController: GADFullScreenContentDelegate {
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        performSegue(withIdentifier: "initial", sender: nil)
    }
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        performSegue(withIdentifier: "initial", sender: nil)
    }
}
