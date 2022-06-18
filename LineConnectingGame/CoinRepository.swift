//
//  CoinRepository.swift
//  LineConnectingGame
//
//  Created by 村中令 on 2022/06/18.
//

import Foundation

struct CoinRepository {
    static func load() -> Int? {
        let key = "coin"
        let loadCoin = UserDefaults.standard.integer(forKey: key)
        return loadCoin
    }
    static func save(coinNum: Int) {
        let key = "coin"
        UserDefaults.standard.set(coinNum, forKey: key)
    }
}
