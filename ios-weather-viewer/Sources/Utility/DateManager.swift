//
//  DateManager.swift
//  ios-weather-viewer
//
//  Created by Goo on 2/15/25.
//

import Foundation

final class DateManager {
    
    static let shared = DateManager()
    
    private init() {}
    
    func utcToKst(_ utc: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(utc))
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.dateFormat = "M월 d일(E) a h시 m분"
        
        return formatter.string(from: date)
    }
    
}
