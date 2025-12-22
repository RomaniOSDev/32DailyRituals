//
//  SessionViewModel.swift
//  32DailyRituals
//
//  Created by Роман Главацкий on 19.12.2025.
//

import Foundation
import SwiftUI
import Combine

class SessionViewModel: ObservableObject {
    @Published var currentSession: RitualSession?
    @Published var elapsedTime: TimeInterval = 0
    @Published var isRunning: Bool = false
    @Published var quality: Int = 3
    @Published var moodBefore: Int = 5
    @Published var moodAfter: Int = 5
    @Published var notes: String = ""
    @Published var distractions: Int = 0
    
    private let dataManager = DataManager.shared
    private var timer: Timer?
    private var startTime: Date?
    
    var ritual: DailyRitual?
    
    init(ritual: DailyRitual? = nil) {
        self.ritual = ritual
    }
    
    func startSession() {
        guard let ritual = ritual else { return }
        
        let session = RitualSession(
            ritualId: ritual.id,
            startTime: Date(),
            moodBefore: moodBefore
        )
        
        currentSession = session
        startTime = Date()
        isRunning = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateElapsedTime()
        }
    }
    
    func pauseSession() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    func resumeSession() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateElapsedTime()
        }
    }
    
    func completeSession() {
        guard var session = currentSession else { return }
        
        session.endTime = Date()
        session.quality = quality
        session.moodAfter = moodAfter
        session.notes = notes.isEmpty ? nil : notes
        session.distractions = distractions
        
        dataManager.saveSession(session)
        
        if let ritual = ritual {
            var updatedRitual = StreakSystem.updateStreak(for: ritual, completed: true)
            dataManager.saveRitual(updatedRitual)
        }
        
        resetSession()
    }
    
    func skipSession() {
        guard var ritual = ritual else { return }
        ritual.lastCompleted = nil
        dataManager.saveRitual(ritual)
        resetSession()
    }
    
    private func updateElapsedTime() {
        guard let startTime = startTime else { return }
        elapsedTime = Date().timeIntervalSince(startTime)
    }
    
    private func resetSession() {
        timer?.invalidate()
        timer = nil
        currentSession = nil
        elapsedTime = 0
        isRunning = false
        startTime = nil
        quality = 3
        moodBefore = 5
        moodAfter = 5
        notes = ""
        distractions = 0
    }
    
    var progress: Double {
        guard let ritual = ritual, ritual.duration > 0 else { return 0 }
        return min(elapsedTime / ritual.duration, 1.0)
    }
    
    var remainingTime: TimeInterval {
        guard let ritual = ritual, ritual.duration > 0 else { return 0 }
        return max(ritual.duration - elapsedTime, 0)
    }
    
    deinit {
        timer?.invalidate()
    }
}

