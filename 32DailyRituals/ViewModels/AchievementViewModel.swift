//
//  AchievementViewModel.swift
//  32DailyRituals
//
//  Created by Роман Главацкий on 19.12.2025.
//

import Foundation
import SwiftUI
import Combine

class AchievementViewModel: ObservableObject {
    @Published var achievements: [Achievement] = []
    @Published var unlockedAchievements: [Achievement] = []
    
    private let dataManager = DataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        dataManager.$achievements
            .assign(to: &$achievements)
        
        $achievements
            .map { $0.filter { $0.isUnlocked } }
            .assign(to: &$unlockedAchievements)
        
        checkAchievements()
    }
    
    func checkAchievements() {
        let rituals = dataManager.rituals
        let sessions = dataManager.sessions
        
        for (index, achievement) in achievements.enumerated() {
            if achievement.isUnlocked { continue }
            
            var progress: Double = 0.0
            var isUnlocked = false
            
            switch achievement.requirement {
            case .streak(let days):
                let dailyStreak = StreakSystem.calculateDailyStreak(allRituals: rituals)
                progress = min(Double(dailyStreak) / Double(days), 1.0)
                isUnlocked = dailyStreak >= days
                
            case .totalCompletions(let count):
                let totalCompletions = sessions.filter { $0.endTime != nil }.count
                progress = min(Double(totalCompletions) / Double(count), 1.0)
                isUnlocked = totalCompletions >= count
                
            case .categoryMastery(let category, let count):
                let categoryCompletions = sessions.filter { session in
                    if let ritual = rituals.first(where: { $0.id == session.ritualId }) {
                        return ritual.category == category && session.endTime != nil
                    }
                    return false
                }.count
                progress = min(Double(categoryCompletions) / Double(count), 1.0)
                isUnlocked = categoryCompletions >= count
                
            case .timeInvestment(let hours):
                let totalTime = sessions.reduce(0.0) { $0 + $1.duration }
                progress = min(totalTime / hours, 1.0)
                isUnlocked = totalTime >= hours
            }
            
            if isUnlocked && !achievement.isUnlocked {
                var updatedAchievement = achievement
                updatedAchievement.isUnlocked = true
                updatedAchievement.unlockedDate = Date()
                dataManager.saveAchievement(updatedAchievement)
            }
        }
    }
    
    func getProgress(for achievement: Achievement) -> Double {
        let rituals = dataManager.rituals
        let sessions = dataManager.sessions
        
        switch achievement.requirement {
        case .streak(let days):
            let dailyStreak = StreakSystem.calculateDailyStreak(allRituals: rituals)
            return min(Double(dailyStreak) / Double(days), 1.0)
            
        case .totalCompletions(let count):
            let totalCompletions = sessions.filter { $0.endTime != nil }.count
            return min(Double(totalCompletions) / Double(count), 1.0)
            
        case .categoryMastery(let category, let count):
            let categoryCompletions = sessions.filter { session in
                if let ritual = rituals.first(where: { $0.id == session.ritualId }) {
                    return ritual.category == category && session.endTime != nil
                }
                return false
            }.count
            return min(Double(categoryCompletions) / Double(count), 1.0)
            
        case .timeInvestment(let hours):
            let totalTime = sessions.reduce(0.0) { $0 + $1.duration }
            return min(totalTime / hours, 1.0)
        }
    }
}

