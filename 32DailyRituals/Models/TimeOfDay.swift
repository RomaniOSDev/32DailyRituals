//
//  TimeOfDay.swift
//  32DailyRituals
//
//  Created by Роман Главацкий on 19.12.2025.
//

import Foundation

enum TimeOfDay: String, CaseIterable, Codable {
    case morning = "Morning"
    case afternoon = "Afternoon"
    case evening = "Evening"
    case anytime = "Anytime"
    
    var idealTimeRange: (start: Int, end: Int) {
        switch self {
        case .morning: return (6, 10)
        case .afternoon: return (12, 16)
        case .evening: return (18, 22)
        case .anytime: return (0, 23)
        }
    }
    
    var colorHex: String {
        switch self {
        case .morning: return "FF6B6B"
        case .afternoon: return "4ECDC4"
        case .evening: return "6C5CE7"
        case .anytime: return "BD0E1B"
        }
    }
}

