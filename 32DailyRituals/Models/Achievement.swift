//
//  Achievement.swift
//  32DailyRituals
//
//  Created by Роман Главацкий on 19.12.2025.
//

import Foundation

enum AchievementRequirement: Codable {
    case streak(days: Int)
    case totalCompletions(count: Int)
    case categoryMastery(category: RitualCategory, count: Int)
    case timeInvestment(hours: TimeInterval)
}

struct Achievement: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String
    var iconName: String
    var requirement: AchievementRequirement
    var isUnlocked: Bool
    var unlockedDate: Date?
    
    init(
        id: UUID = UUID(),
        name: String,
        description: String,
        iconName: String,
        requirement: AchievementRequirement,
        isUnlocked: Bool = false,
        unlockedDate: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.iconName = iconName
        self.requirement = requirement
        self.isUnlocked = isUnlocked
        self.unlockedDate = unlockedDate
    }
    
    var progress: Double {
        // Будет рассчитываться в AchievementViewModel
        return 0.0
    }
}

