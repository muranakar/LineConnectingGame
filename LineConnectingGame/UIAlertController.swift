//
//  UIAlertController.swift
//  TimerAssessment
//
//  Created by Ryo Muranaka on 2022/02/20.
//

import UIKit

extension UIAlertController {

    /// 選択済み。
    static func checkIsSelection() -> Self {
        let title = "選択済み"
        let message = "他の選択肢を選択してください。"
        let controller = self.init(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return controller
    }

    static func configureLocationSetting(okHandler:@escaping () -> Void) -> Self {
        let title = "現在地の取得不可"
        let message = "現在地が取得できません。\n設定を行いますか？"
        let alertController = self.init(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "設定する",
            style: .cancel) { _ in
                okHandler()
            }
        let cancelAction = UIAlertAction(title: "設定しない", style: .default)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        return alertController
    }
}
