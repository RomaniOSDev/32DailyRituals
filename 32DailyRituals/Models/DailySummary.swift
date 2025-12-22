//
//  DailySummary.swift
//  32DailyRituals
//
//  Created by Роман Главацкий on 19.12.2025.
//

import Foundation

struct DailySummary: Identifiable, Codable {
    let id: UUID
    var date: Date
    var completedRituals: [UUID]
    var totalRituals: Int
    var totalDuration: TimeInterval
    var averageMoodChange: Double?
    var notes: String?
    
    init(
        id: UUID = UUID(),
        date: Date = Date(),
        completedRituals: [UUID] = [],
        totalRituals: Int = 0,
        totalDuration: TimeInterval = 0,
        averageMoodChange: Double? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.date = date
        self.completedRituals = completedRituals
        self.totalRituals = totalRituals
        self.totalDuration = totalDuration
        self.averageMoodChange = averageMoodChange
        self.notes = notes
    }
    
    var completionRate: Double {
        guard totalRituals > 0 else { return 0 }
        return Double(completedRituals.count) / Double(totalRituals)
    }
    
    var dayRating: Int? {
        guard let moodChange = averageMoodChange else { return nil }
        switch moodChange {
        case ..<(-2): return 1
        case -2..<0: return 2
        case 0..<2: return 3
        case 2..<4: return 4
        default: return 5
        }
    }
}

