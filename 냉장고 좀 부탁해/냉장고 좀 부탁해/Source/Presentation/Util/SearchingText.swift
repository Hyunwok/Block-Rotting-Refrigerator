//
//  SearchingText.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/07/27.
//

import Foundation

// https://xodhks0113.blogspot.com/2021/12/ios.html
class SearchingText {
    static let shared = SearchingText()
    
    private init() {}
    
    private let hangul = ["ㄱ","ㄲ","ㄴ","ㄷ","ㄸ","ㄹ","ㅁ","ㅂ","ㅃ","ㅅ","ㅆ","ㅇ","ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"]
    
    func chosungCheck(word: String) -> String {
        var result = ""
        
        // 문자열하나씩 짤라서 확인
        for char in word {
            let octal = char.unicodeScalars[char.unicodeScalars.startIndex].value
            if 44032...55203 ~= octal {
                let index = (octal - 0xac00) / 28 / 21
                result = result + hangul[Int(index)]
            }
        }
        
        return result
    }

    /// 2. 현재 문자열이 초성으로만 이뤄졌는지
    /// - Parameter word: 검색어
    /// - Returns: Bool
    func isChosung(word: String) -> Bool {
        var isChosung = false
        for char in word {
            if 0 < hangul.filter({ $0.contains(char)}).count {
                isChosung = true
            } else {
                isChosung = false
                break
            }
        }
        return isChosung
    }
}
