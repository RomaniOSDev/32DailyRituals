//
//  RitualSession.swift
//  32DailyRituals
//
//  Created by Роман Главацкий on 19.12.2025.
//

import Foundation

struct RitualSession: Identifiable, Codable {
    let id: UUID
    var ritualId: UUID
    var startTime: Date
    var endTime: Date?
    var quality: Int? // 1-5
    var notes: String?
    var moodBefore: Int? // 1-10
    var moodAfter: Int? // 1-10
    var distractions: Int? // количество отвлечений
    
    init(
        id: UUID = UUID(),
        ritualId: UUID,
        startTime: Date = Date(),
        endTime: Date? = nil,
        quality: Int? = nil,
        notes: String? = nil,
        moodBefore: Int? = nil,
        moodAfter: Int? = nil,
        distractions: Int? = nil
    ) {
        self.id = id
        self.ritualId = ritualId
        self.startTime = startTime
        self.endTime = endTime
        self.quality = quality
        self.notes = notes
        self.moodBefore = moodBefore
        self.moodAfter = moodAfter
        self.distractions = distractions
    }
    
    var duration: TimeInterval {
        guard let endTime = endTime else { return 0 }
        return endTime.timeIntervalSince(startTime)
    }
    
    var moodChange: Int? {
        guard let before = moodBefore, let after = moodAfter else { return nil }
        return after - before
    }
}

