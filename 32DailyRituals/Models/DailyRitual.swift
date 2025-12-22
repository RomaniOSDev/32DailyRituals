//
//  DailyRitual.swift
//  32DailyRituals
//
//  Created by Роман Главацкий on 19.12.2025.
//

import Foundation
import SwiftUI

struct DailyRitual: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String
    var timeOfDay: TimeOfDay
    var duration: TimeInterval // в секундах
    var category: RitualCategory
    var iconName: String
    var isActive: Bool
    var priority: PriorityLevel
    var streak: Int
    var bestStreak: Int
    var lastCompleted: Date?
    
    init(
        id: UUID = UUID(),
        name: String,
        description: String,
        timeOfDay: TimeOfDay,
        duration: TimeInterval,
        category: RitualCategory,
        iconName: String,
        isActive: Bool = true,
        priority: PriorityLevel = .medium,
        streak: Int = 0,
        bestStreak: Int = 0,
        lastCompleted: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.timeOfDay = timeOfDay
        self.duration = duration
        self.category = category
        self.iconName = iconName
        self.isActive = isActive
        self.priority = priority
        self.streak = streak
        self.bestStreak = bestStreak
        self.lastCompleted = lastCompleted
    }
    
    var color: Color {
        Color(hex: timeOfDay.colorHex)
    }
    
    var isDueToday: Bool {
        guard let lastCompleted = lastCompleted else { return true }
        return !Calendar.current.isDateInToday(lastCompleted)
    }
    
    var completionStatus: CompletionStatus {
        guard let lastCompleted = lastCompleted else { return .pending }
        return Calendar.current.isDateInToday(lastCompleted) ? .completed : .pending
    }
    
    var durationInMinutes: Int {
        Int(duration / 60)
    }
    
    var priorityLevel: Int {
        priority.priorityValue
    }
}

