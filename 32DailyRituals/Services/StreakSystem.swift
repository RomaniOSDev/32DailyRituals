//
//  StreakSystem.swift
//  32DailyRituals
//
//  Created by Роман Главацкий on 19.12.2025.
//

import Foundation

struct StreakSystem {
    static func updateStreak(for ritual: DailyRitual, completed: Bool) -> DailyRitual {
        var updatedRitual = ritual
        
        if completed {
            if let lastCompleted = ritual.lastCompleted {
                let calendar = Calendar.current
                if let yesterday = calendar.date(byAdding: .day, value: -1, to: Date()),
                   calendar.isDate(lastCompleted, inSameDayAs: yesterday) {
                    updatedRitual.streak += 1
                    if updatedRitual.streak > updatedRitual.bestStreak {
                        updatedRitual.bestStreak = updatedRitual.streak
                    }
                } else if !calendar.isDateInToday(lastCompleted) {
                    updatedRitual.streak = 1
                }
            } else {
                updatedRitual.streak = 1
            }
            updatedRitual.lastCompleted = Date()
        } else {
            if let lastCompleted = ritual.lastCompleted {
                let calendar = Calendar.current
                if let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: Date()),
                   calendar.isDate(lastCompleted, inSameDayAs: twoDaysAgo) {
                    updatedRitual.streak = 0
                }
            }
        }
        
        return updatedRitual
    }
    
    static func calculateDailyStreak(allRituals: [DailyRitual]) -> Int {
        let calendar = Calendar.current
        let today = Date()
        
        var streak = 0
        var currentDate = today
        
        while true {
            let ritualsForDate = allRituals.filter { ritual in
                guard let lastCompleted = ritual.lastCompleted else { return false }
                return calendar.isDate(lastCompleted, inSameDayAs: currentDate)
            }
            
            if ritualsForDate.isEmpty {
                break
            }
            
            streak += 1
            guard let previousDate = calendar.date(byAdding: .day, value: -1, to: currentDate) else {
                break
            }
            currentDate = previousDate
        }
        
        return streak
    }
}

