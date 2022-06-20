//
//  InitialViewController.swift
//  LineConnectingGame
//
//  Created by 村中令 on 2022/06/18.
//

import UIKit

class InitialViewController: UIViewController {

    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var hiraganaButton: UIButton!
    @IBOutlet weak var katakanaButton: UIButton!
    @IBOutlet weak var emojiButton: UIButton!
    @IBOutlet weak var randomButton: UIButton!
    private var allButton: [UIButton] {
        [
            hiraganaButton,
            katakanaButton,
            emojiButton,
            randomButton
        ]
    }
    private var characterType: CharacterType = .hiragana

    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtonIsEnabled()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coinLabel.text = "×　\(CoinRepository.load() ?? 0)"
    }
    override func viewWillLayoutSubviews() {
        convfigureViewButton()
    }
    
    @IBAction func hiragana(_ sender: Any) {
        characterType = .hiragana
        performSegue(withIdentifier: "game", sender: sender)
    }

    @IBAction func katakana(_ sender: Any) {
        characterType = .katakana
        performSegue(withIdentifier: "game", sender: sender)
    }

    @IBAction func emoji(_ sender: Any) {
        characterType = .emoji
        performSegue(withIdentifier: "game", sender: sender)
    }
    @IBAction func random(_ sender: Any) {
        characterType = .kanzi
        performSegue(withIdentifier: "game", sender: sender)
    }

    private func convfigureViewButton() {
        allButton.forEach { button in
            button.layer.borderWidth = 3
            button.layer.borderColor = UIColor.init(named: "string")?.cgColor
            button.layer.cornerRadius = 10
            button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .regular)
            button.setTitleColor(UIColor.init(named: "string"), for: .normal)
            button.setTitleColor(.gray, for: .disabled)
        }
    }
    private func configureButtonIsEnabled() {
        let coin = CoinRepository.load() ?? 0
        if coin < 100 {
            randomButton.isEnabled = false
            emojiButton.isEnabled = false
            katakanaButton.isEnabled = false
        } else if coin < 300 {
            randomButton.isEnabled = false
            emojiButton.isEnabled = false
        } else if  coin < 500{
            randomButton.isEnabled = false
        }
    }
}

private extension InitialViewController {
    @IBSegueAction
    func makeGameVC(coder: NSCoder, sender: Any?, segueIdentifier: String?) -> GameViewController? {
        return GameViewController(
            coder: coder,
            characterType: characterType
        )
    }

    @IBAction
    func backToInitialViewController(segue: UIStoryboardSegue) {
    }
}
