//
//  ResultViewController.swift
//  LineConnectingGame
//
//  Created by 村中令 on 2022/06/18.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var correntNumLabel: UILabel!
    @IBOutlet private weak var coinLabel: UILabel!

    private var correntNum: Int
    private var coin: Int
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewLabel()
        configureViewButton()
    }
    
    required init?(coder: NSCoder,correntNum: Int, coin: Int) {
        self.correntNum = correntNum
        self.coin = coin
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        let hashTag = "#発達支援"
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
        let message = "【つなぐもじ】コインを合計\(coin)枚獲得！"

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
