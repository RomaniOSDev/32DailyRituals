//
//  RitualViewModel.swift
//  32DailyRituals
//
//  Created by Роман Главацкий on 19.12.2025.
//

import Foundation
import SwiftUI
import Combine

class RitualViewModel: ObservableObject {
    @Published var rituals: [DailyRitual] = []
    @Published var filteredRituals: [DailyRitual] = []
    @Published var selectedTimeOfDay: TimeOfDay? = nil
    @Published var selectedCategory: RitualCategory? = nil
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .priority
    
    private let dataManager = DataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption: String, CaseIterable {
        case priority = "Priority"
        case name = "Name"
        case streak = "Streak"
        case duration = "Duration"
    }
    
    init() {
        dataManager.$rituals
            .assign(to: &$rituals)
        
        Publishers.CombineLatest4(
            $rituals,
            $selectedTimeOfDay,
            $selectedCategory,
            $searchText
        )
        .combineLatest($sortOption)
        .map { [weak self] combined, sortOption -> [DailyRitual] in
            guard let self = self else { return [] }
            let (rituals, timeOfDay, category, searchText) = combined
            return self.filterAndSort(rituals: rituals, timeOfDay: timeOfDay, category: category, searchText: searchText)
        }
        .assign(to: &$filteredRituals)
    }
    
    private func filterAndSort(rituals: [DailyRitual], timeOfDay: TimeOfDay?, category: RitualCategory?, searchText: String) -> [DailyRitual] {
        var filtered = rituals
        
        if let timeOfDay = timeOfDay {
            filtered = filtered.filter { $0.timeOfDay == timeOfDay }
        }
        
        if let category = category {
            filtered = filtered.filter { $0.category == category }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        switch sortOption {
        case .priority:
            filtered = filtered.sorted { $0.priorityLevel > $1.priorityLevel }
        case .name:
            filtered = filtered.sorted { $0.name < $1.name }
        case .streak:
            filtered = filtered.sorted { $0.streak > $1.streak }
        case .duration:
            filtered = filtered.sorted { $0.duration > $1.duration }
        }
        
        return filtered
    }
    
    func getRituals(for timeOfDay: TimeOfDay) -> [DailyRitual] {
        return rituals.filter { $0.timeOfDay == timeOfDay && $0.isActive }
    }
    
    func getTodayRituals() -> [DailyRitual] {
        return rituals.filter { $0.isActive }
    }
    
    func getCompletedTodayCount() -> Int {
        return rituals.filter { $0.completionStatus == .completed }.count
    }
    
    func getTotalTodayCount() -> Int {
        return rituals.filter { $0.isActive }.count
    }
    
    func getActiveRitual() -> DailyRitual? {
        // Check for active sessions (sessions without endTime)
        let activeSessionIds = dataManager.sessions
            .filter { $0.endTime == nil }
            .map { $0.ritualId }
        
        return rituals.first { activeSessionIds.contains($0.id) }
    }
    
    func completeRitual(_ ritual: DailyRitual) {
        var updatedRitual = StreakSystem.updateStreak(for: ritual, completed: true)
        dataManager.saveRitual(updatedRitual)
    }
    
    func skipRitual(_ ritual: DailyRitual) {
        var updatedRitual = ritual
        updatedRitual.lastCompleted = nil
        dataManager.saveRitual(updatedRitual)
    }
    
    func deleteRitual(_ ritual: DailyRitual) {
        dataManager.deleteRitual(ritual)
    }
    
    func toggleRitualActive(_ ritual: DailyRitual) {
        var updatedRitual = ritual
        updatedRitual.isActive.toggle()
        dataManager.saveRitual(updatedRitual)
    }
}

