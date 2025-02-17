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
    
    enum FormatType {
        case datetime
        case time
    }
    
    func utcToKst(_ utc: Int, for format: FormatType) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(utc))
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        switch format {
        case .datetime:
            formatter.dateFormat = "M월 d일(E) a h시 m분"
        case .time:
            formatter.dateFormat = "a h시 m분"
        }
        
        return formatter.string(from: date)
    }
    
}
