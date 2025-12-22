//
//  AnalyticsViewModel.swift
//  32DailyRituals
//
//  Created by Роман Главацкий on 19.12.2025.
//

import Foundation
import SwiftUI
import Combine

class AnalyticsViewModel: ObservableObject {
    @Published var summaries: [DailySummary] = []
    @Published var selectedPeriod: Period = .week
    
    private let dataManager = DataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    enum Period: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
    }
    
    init() {
        dataManager.$summaries
            .assign(to: &$summaries)
    }
    
    func getSummaries(for period: Period) -> [DailySummary] {
        let calendar = Calendar.current
        let now = Date()
        let startDate: Date
        
        switch period {
        case .week:
            startDate = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        case .month:
            startDate = calendar.date(byAdding: .month, value: -1, to: now) ?? now
        case .year:
            startDate = calendar.date(byAdding: .year, value: -1, to: now) ?? now
        }
        
        return summaries.filter { $0.date >= startDate }
    }
    
    func getCompletionRate(for period: Period) -> Double {
        let periodSummaries = getSummaries(for: period)
        guard !periodSummaries.isEmpty else { return 0 }
        
        let totalRate = periodSummaries.reduce(0.0) { $0 + $1.completionRate }
        return totalRate / Double(periodSummaries.count)
    }
    
    func getAverageMoodChange(for period: Period) -> Double? {
        let periodSummaries = getSummaries(for: period)
        let moodChanges = periodSummaries.compactMap { $0.averageMoodChange }
        guard !moodChanges.isEmpty else { return nil }
        
        return moodChanges.reduce(0.0, +) / Double(moodChanges.count)
    }
    
    func getBestRitual() -> DailyRitual? {
        let rituals = dataManager.rituals
        guard !rituals.isEmpty else { return nil }
        
        return rituals.max { $0.streak < $1.streak }
    }
    
    func getTotalTimeSpent(for period: Period) -> TimeInterval {
        let periodSummaries = getSummaries(for: period)
        return periodSummaries.reduce(0) { $0 + $1.totalDuration }
    }
    
    func updateTodaySummary() {
        let calendar = Calendar.current
        let today = Date()
        
        let todayRituals = dataManager.rituals.filter { $0.isActive }
        let completedRituals = todayRituals.filter { $0.completionStatus == .completed }
        
        let todaySessions = dataManager.sessions.filter { session in
            calendar.isDateInToday(session.startTime)
        }
        
        let totalDuration = todaySessions.reduce(0) { $0 + $1.duration }
        
        let moodChanges = todaySessions.compactMap { $0.moodChange }
        let averageMoodChange = moodChanges.isEmpty ? nil : Double(moodChanges.reduce(0, +)) / Double(moodChanges.count)
        
        let completedIds = completedRituals.map { $0.id }
        
        if let existingSummary = dataManager.getSummary(for: today) {
            var updated = existingSummary
            updated.completedRituals = completedIds
            updated.totalRituals = todayRituals.count
            updated.totalDuration = totalDuration
            updated.averageMoodChange = averageMoodChange
            dataManager.saveSummary(updated)
        } else {
            let newSummary = DailySummary(
                date: today,
                completedRituals: completedIds,
                totalRituals: todayRituals.count,
                totalDuration: totalDuration,
                averageMoodChange: averageMoodChange
            )
            dataManager.saveSummary(newSummary)
        }
    }
}

