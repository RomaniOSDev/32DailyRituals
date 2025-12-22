//
//  PriorityLevel.swift
//  32DailyRituals
//
//  Created by Роман Главацкий on 19.12.2025.
//

import Foundation
import SwiftUI

enum PriorityLevel: String, CaseIterable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case critical = "Critical"
    
    var colorHex: String {
        switch self {
        case .low: return "8A8F98"
        case .medium: return "FFBE00"
        case .high: return "BD0E1B"
        case .critical: return "FF0000"
        }
    }
    
    var priorityValue: Int {
        switch self {
        case .low: return 1
        case .medium: return 2
        case .high: return 3
        case .critical: return 4
        }
    }
}

