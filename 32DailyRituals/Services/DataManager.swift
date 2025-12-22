//
//  DataManager.swift
//  32DailyRituals
//
//  Created by Роман Главацкий on 19.12.2025.
//

import Foundation
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    private let ritualsKey = "saved_rituals"
    private let sessionsKey = "saved_sessions"
    private let summariesKey = "saved_summaries"
    private let achievementsKey = "saved_achievements"
    
    @Published var rituals: [DailyRitual] = []
    @Published var sessions: [RitualSession] = []
    @Published var summaries: [DailySummary] = []
    @Published var achievements: [Achievement] = []
    
    private init() {
        loadData()
        if rituals.isEmpty {
            loadDefaultData()
        }
    }
    
    // MARK: - Rituals
    
    func saveRitual(_ ritual: DailyRitual) {
        if let index = rituals.firstIndex(where: { $0.id == ritual.id }) {
            rituals[index] = ritual
        } else {
            rituals.append(ritual)
        }
        saveData()
    }
    
    func deleteRitual(_ ritual: DailyRitual) {
        rituals.removeAll { $0.id == ritual.id }
        sessions.removeAll { $0.ritualId == ritual.id }
        saveData()
    }
    
    func getRitual(by id: UUID) -> DailyRitual? {
        return rituals.first { $0.id == id }
    }
    
    // MARK: - Sessions
    
    func saveSession(_ session: RitualSession) {
        if let index = sessions.firstIndex(where: { $0.id == session.id }) {
            sessions[index] = session
        } else {
            sessions.append(session)
        }
        saveData()
    }
    
    func getSessions(for ritualId: UUID) -> [RitualSession] {
        return sessions.filter { $0.ritualId == ritualId }
    }
    
    // MARK: - Summaries
    
    func saveSummary(_ summary: DailySummary) {
        if let index = summaries.firstIndex(where: { $0.id == summary.id }) {
            summaries[index] = summary
        } else {
            summaries.append(summary)
        }
        saveData()
    }
    
    func getSummary(for date: Date) -> DailySummary? {
        let calendar = Calendar.current
        return summaries.first { calendar.isDate($0.date, inSameDayAs: date) }
    }
    
    // MARK: - Achievements
    
    func saveAchievement(_ achievement: Achievement) {
        if let index = achievements.firstIndex(where: { $0.id == achievement.id }) {
            achievements[index] = achievement
        } else {
            achievements.append(achievement)
        }
        saveData()
    }
    
    // MARK: - Persistence
    
    private func saveData() {
        if let ritualsData = try? JSONEncoder().encode(rituals) {
            UserDefaults.standard.set(ritualsData, forKey: ritualsKey)
        }
        if let sessionsData = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(sessionsData, forKey: sessionsKey)
        }
        if let summariesData = try? JSONEncoder().encode(summaries) {
            UserDefaults.standard.set(summariesData, forKey: summariesKey)
        }
        if let achievementsData = try? JSONEncoder().encode(achievements) {
            UserDefaults.standard.set(achievementsData, forKey: achievementsKey)
        }
    }
    
    private func loadData() {
        if let ritualsData = UserDefaults.standard.data(forKey: ritualsKey),
           let decoded = try? JSONDecoder().decode([DailyRitual].self, from: ritualsData) {
            rituals = decoded
        }
        if let sessionsData = UserDefaults.standard.data(forKey: sessionsKey),
           let decoded = try? JSONDecoder().decode([RitualSession].self, from: sessionsData) {
            sessions = decoded
        }
        if let summariesData = UserDefaults.standard.data(forKey: summariesKey),
           let decoded = try? JSONDecoder().decode([DailySummary].self, from: summariesData) {
            summaries = decoded
        }
        if let achievementsData = UserDefaults.standard.data(forKey: achievementsKey),
           let decoded = try? JSONDecoder().decode([Achievement].self, from: achievementsData) {
            achievements = decoded
        }
    }
    
    private func loadDefaultData() {
        // Default rituals
        let defaultRituals = [
            DailyRitual(
                name: "Morning Meditation",
                description: "10 minutes of silence",
                timeOfDay: .morning,
                duration: 600,
                category: .mindfulness,
                iconName: "brain.head.profile",
                priority: .high
            ),
            DailyRitual(
                name: "Morning Exercise",
                description: "Light exercises",
                timeOfDay: .morning,
                duration: 300,
                category: .fitness,
                iconName: "figure.walk",
                priority: .medium
            ),
            DailyRitual(
                name: "Lunch Walk",
                description: "Fresh air",
                timeOfDay: .afternoon,
                duration: 900,
                category: .fitness,
                iconName: "figure.walk",
                priority: .medium
            ),
            DailyRitual(
                name: "Evening Journal",
                description: "Day reflection",
                timeOfDay: .evening,
                duration: 600,
                category: .mindfulness,
                iconName: "book.fill",
                priority: .high
            ),
            DailyRitual(
                name: "Bedtime Reading",
                description: "Screen-free reading",
                timeOfDay: .evening,
                duration: 1200,
                category: .learning,
                iconName: "book.fill",
                priority: .medium
            )
        ]
        
        rituals = defaultRituals
        
        // Default achievements
        let defaultAchievements = [
            Achievement(
                name: "Ritual Beginner",
                description: "Complete your first ritual",
                iconName: "sparkles",
                requirement: .totalCompletions(count: 1)
            ),
            Achievement(
                name: "Week of Discipline",
                description: "7 days in a row of ritual completion",
                iconName: "flame.fill",
                requirement: .streak(days: 7)
            ),
            Achievement(
                name: "Meditation Master",
                description: "Complete 30 mindfulness rituals",
                iconName: "brain.head.profile",
                requirement: .categoryMastery(category: .mindfulness, count: 30)
            ),
            Achievement(
                name: "100 Hours of Self-Improvement",
                description: "Spend 100 hours on rituals",
                iconName: "clock.fill",
                requirement: .timeInvestment(hours: 100 * 3600)
            )
        ]
        
        achievements = defaultAchievements
        saveData()
    }
}

