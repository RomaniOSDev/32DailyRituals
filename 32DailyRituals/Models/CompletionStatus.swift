//
//  CompletionStatus.swift
//  32DailyRituals
//
//  Created by Роман Главацкий on 19.12.2025.
//

import Foundation
import SwiftUI

enum CompletionStatus: String, Codable {
    case pending = "Pending"
    case completed = "Completed"
    case skipped = "Skipped"
    case inProgress = "In Progress"
    
    var colorHex: String {
        switch self {
        case .pending: return "8A8F98"
        case .completed: return "FFBE00"
        case .skipped: return "BD0E1B"
        case .inProgress: return "4ECDC4"
        }
    }
}

