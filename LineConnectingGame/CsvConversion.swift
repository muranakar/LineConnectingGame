//
//  CsvConversion.swift
//  LineConnectingGame
//
//  Created by 村中令 on 2022/06/17.
//

import Foundation

struct CsvConversion {
    static func convertFacilityInformationFromCsv (characterType: CharacterType) -> [String] {
        var csvLineOneDimensional: [String] = []
        guard let path = Bundle.main.path(
            forResource: "\(characterType.fileName)",
            ofType: "csv"
        ) else {
            print("csvファイルがないよ")
            return []
        }
        let csvString = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
        csvLineOneDimensional = csvString.components(separatedBy: "\r\n")
        return csvLineOneDimensional
    }
}

enum CharacterType: CaseIterable {
    case hiragana
    case katakana
}

extension CharacterType {
    var fileName: String {
        switch self {
        case .hiragana:
            return "hiragana_1column_unicode"
        case .katakana:
            return "katakana_1column_unicode"
        }
    }
}
