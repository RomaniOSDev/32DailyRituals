//
//  AchievementsView.swift
//  32DailyRituals
//
//  Created by Роман Главацкий on 19.12.2025.
//

import SwiftUI

struct AchievementsView: View {
    @StateObject private var viewModel = AchievementViewModel()
    
    var body: some View {
        ZStack {
            Color(hex: "02102b")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Unlocked Section
                    if !viewModel.unlockedAchievements.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Unlocked")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white.opacity(0.95))
                            
                            ForEach(viewModel.unlockedAchievements) { achievement in
                                AchievementRow(achievement: achievement, progress: 1.0, isUnlocked: true)
                            }
                        }
                    }
                    
                    // Locked Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("In Progress")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white.opacity(0.95))
                        
                        ForEach(viewModel.achievements.filter { !$0.isUnlocked }) { achievement in
                            let progress = viewModel.getProgress(for: achievement)
                            AchievementRow(achievement: achievement, progress: progress, isUnlocked: false)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Achievements")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            viewModel.checkAchievements()
        }
    }
}

struct AchievementRow: View {
    let achievement: Achievement
    let progress: Double
    let isUnlocked: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(isUnlocked ? Color(hex: "FFBE00").opacity(0.2) : Color(hex: "0a1a3b"))
                    .frame(width: 60, height: 60)
                
                Image(systemName: achievement.iconName)
                    .font(.title2)
                    .foregroundColor(isUnlocked ? Color(hex: "FFBE00") : Color(hex: "8A8F98"))
            }
            
            // Info
            VStack(alignment: .leading, spacing: 8) {
                Text(achievement.name)
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.95))
                
                Text(achievement.description)
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "8A8F98").opacity(0.7))
                
                if !isUnlocked {
                    ProgressView(value: progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: Color(hex: "BD0E1B")))
                        .scaleEffect(x: 1, y: 1.5, anchor: .center)
                    
                    Text("\(Int(progress * 100))%")
                        .font(.caption)
                        .foregroundColor(Color(hex: "8A8F98").opacity(0.7))
                } else if let unlockedDate = achievement.unlockedDate {
                    Text("Unlocked \(unlockedDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.caption)
                        .foregroundColor(Color(hex: "FFBE00"))
                }
            }
            
            Spacer()
            
            if isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(Color(hex: "FFBE00"))
            }
        }
        .padding()
        .background(Color(hex: "0a1a3b"))
        .cornerRadius(16)
        .opacity(isUnlocked ? 1.0 : 0.7)
    }
}

#Preview {
    NavigationView {
        AchievementsView()
    }
}

