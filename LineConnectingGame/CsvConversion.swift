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
        var filtercsvLineOneDimensional = csvLineOneDimensional
            .map { string in
            string.replacingOccurrences(of: ",", with: "")
            }.map { string in
                String(string.prefix(1))
            }.filter { string in
                string.count == 1
            }

        filtercsvLineOneDimensional.removeAll { string in string == "" || string == " "}
        return filtercsvLineOneDimensional
    }
}

enum CharacterType: CaseIterable {
    case hiragana
    case katakana
    case emoji
    case kanzi
}

extension CharacterType {
    var fileName: String {
        switch self {
        case .hiragana:
            return "hiragana_1column_unicode"
        case .katakana:
            return "katakana_1column_unicode"
        case .emoji:
            return "emoji"
        case .kanzi:
            return "joyokanzi"
        }
    }
}
