//
//  RitualRecommender.swift
//  32DailyRituals
//
//  Created by Роман Главацкий on 19.12.2025.
//

import Foundation

struct RitualRecommender {
    static func recommendSchedule(for timeSlots: [TimeOfDay], availableTime: TimeInterval) -> [DailyRitual] {
        var recommendations: [DailyRitual] = []
        
        let baseRituals: [TimeOfDay: [DailyRitual]] = [
            .morning: [
                DailyRitual(name: "Morning Meditation", description: "10 minutes of silence", timeOfDay: .morning, duration: 600, category: .mindfulness, iconName: "brain.head.profile", isActive: true, priority: .high, streak: 0, bestStreak: 0),
                DailyRitual(name: "Morning Exercise", description: "Light exercises", timeOfDay: .morning, duration: 300, category: .fitness, iconName: "figure.walk", isActive: true, priority: .medium, streak: 0, bestStreak: 0)
            ],
            .afternoon: [
                DailyRitual(name: "Lunch Walk", description: "Fresh air", timeOfDay: .afternoon, duration: 900, category: .fitness, iconName: "figure.walk", isActive: true, priority: .medium, streak: 0, bestStreak: 0)
            ],
            .evening: [
                DailyRitual(name: "Evening Journal", description: "Day reflection", timeOfDay: .evening, duration: 600, category: .mindfulness, iconName: "book.fill", isActive: true, priority: .high, streak: 0, bestStreak: 0),
                DailyRitual(name: "Bedtime Reading", description: "Screen-free reading", timeOfDay: .evening, duration: 1200, category: .learning, iconName: "book.fill", isActive: true, priority: .medium, streak: 0, bestStreak: 0)
            ]
        ]
        
        for timeSlot in timeSlots {
            if let rituals = baseRituals[timeSlot] {
                recommendations.append(contentsOf: rituals)
            }
        }
        
        let totalDuration = recommendations.reduce(0) { $0 + $1.duration }
        if totalDuration > availableTime {
            recommendations = recommendations.sorted { $0.priorityLevel > $1.priorityLevel }
            var accumulatedTime: TimeInterval = 0
            recommendations = recommendations.filter { ritual in
                accumulatedTime += ritual.duration
                return accumulatedTime <= availableTime
            }
        }
        
        return recommendations
    }
}

