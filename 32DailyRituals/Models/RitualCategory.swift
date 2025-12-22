//
//  RitualCategory.swift
//  32DailyRituals
//
//  Created by Роман Главацкий on 19.12.2025.
//

import Foundation

enum RitualCategory: String, CaseIterable, Codable {
    case mindfulness = "Mindfulness"
    case fitness = "Fitness"
    case nutrition = "Nutrition"
    case productivity = "Productivity"
    case selfCare = "Self Care"
    case learning = "Learning"
    case social = "Social"
    case creativity = "Creativity"
    
    var icon: String {
        switch self {
        case .mindfulness: return "brain.head.profile"
        case .fitness: return "figure.walk"
        case .nutrition: return "fork.knife"
        case .productivity: return "checklist"
        case .selfCare: return "heart.fill"
        case .learning: return "book.fill"
        case .social: return "person.2.fill"
        case .creativity: return "paintbrush.fill"
        }
    }
}

