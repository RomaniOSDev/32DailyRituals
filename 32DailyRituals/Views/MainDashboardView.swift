//
//  MainDashboardView.swift
//  32DailyRituals
//
//  Created by Роман Главацкий on 19.12.2025.
//

import SwiftUI

struct MainDashboardView: View {
    @StateObject private var ritualViewModel = RitualViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            Color(hex: "02102b")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection
                    
                    // Progress Card
                    progressCard
                    
                    // Streak Card
                    streakCard
                    
                    // Time Sections
                    timeSection(timeOfDay: .morning, color: Color(hex: "FF6B6B"))
                    timeSection(timeOfDay: .afternoon, color: Color(hex: "4ECDC4"))
                    timeSection(timeOfDay: .evening, color: Color(hex: "6C5CE7"))
                    
                    // Active Ritual
                    if let activeRitual = ritualViewModel.getActiveRitual() {
                        activeRitualCard(ritual: activeRitual)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Daily Rituals")
        .navigationBarTitleDisplayMode(.large)
        .foregroundColor(.white)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(Color(hex: "BD0E1B"))
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Today")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white.opacity(0.95))
            
            Text(Date().formatted(date: .abbreviated, time: .omitted))
                .font(.subheadline)
                .foregroundColor(Color(hex: "8A8F98").opacity(0.7))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var progressCard: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Today's Progress")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.95))
                Spacer()
                Text("\(ritualViewModel.getCompletedTodayCount())/\(ritualViewModel.getTotalTodayCount())")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "FFBE00"))
            }
            
            ProgressView(value: Double(ritualViewModel.getCompletedTodayCount()), total: Double(max(ritualViewModel.getTotalTodayCount(), 1)))
                .progressViewStyle(LinearProgressViewStyle(tint: Color(hex: "FFBE00")))
                .scaleEffect(x: 1, y: 2, anchor: .center)
        }
        .padding()
        .background(Color(hex: "0a1a3b"))
        .cornerRadius(16)
    }
    
    private var streakCard: some View {
        HStack {
            Image(systemName: "flame.fill")
                .font(.title)
                .foregroundColor(Color(hex: "FFBE00"))
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(StreakSystem.calculateDailyStreak(allRituals: ritualViewModel.rituals)) days streak")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.95))
                Text("Keep it up!")
                    .font(.caption)
                    .foregroundColor(Color(hex: "8A8F98").opacity(0.7))
            }
            
            Spacer()
        }
        .padding()
        .background(Color(hex: "0a1a3b"))
        .cornerRadius(16)
    }
    
    private func timeSection(timeOfDay: TimeOfDay, color: Color) -> some View {
        let rituals = ritualViewModel.getRituals(for: timeOfDay)
        
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(timeOfDay.rawValue)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white.opacity(0.95))
                Spacer()
                NavigationLink(destination: RitualListView(timeOfDay: timeOfDay)) {
                    Text("See All")
                        .font(.caption)
                        .foregroundColor(color)
                }
            }
            
            if rituals.isEmpty {
                Text("No rituals scheduled")
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "8A8F98").opacity(0.7))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "0a1a3b"))
                    .cornerRadius(12)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(rituals.prefix(3)) { ritual in
                            NavigationLink(destination: RitualDetailView(ritual: ritual)) {
                                RitualCard(ritual: ritual, color: color)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func activeRitualCard(ritual: DailyRitual) -> some View {
        NavigationLink(destination: SessionView(ritual: ritual)) {
            HStack {
                Image(systemName: ritual.iconName)
                    .font(.title2)
                    .foregroundColor(Color(hex: "4ECDC4"))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Active: \(ritual.name)")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.95))
                    Text("Tap to continue")
                        .font(.caption)
                        .foregroundColor(Color(hex: "8A8F98").opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "play.circle.fill")
                    .font(.title2)
                    .foregroundColor(Color(hex: "4ECDC4"))
            }
            .padding()
            .background(Color(hex: "0a1a3b"))
            .cornerRadius(16)
        }
    }
}

struct RitualCard: View {
    let ritual: DailyRitual
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: ritual.iconName)
                .font(.title2)
                .foregroundColor(color)
            
            Text(ritual.name)
                .font(.headline)
                .foregroundColor(.white.opacity(0.95))
                .lineLimit(2)
            
            Text("\(ritual.durationInMinutes) min")
                .font(.caption)
                .foregroundColor(Color(hex: "8A8F98").opacity(0.7))
            
            Spacer()
            
            HStack {
                if ritual.streak > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.caption2)
                        Text("\(ritual.streak)")
                            .font(.caption2)
                    }
                    .foregroundColor(Color(hex: "FFBE00"))
                }
                
                Spacer()
                
                Circle()
                    .fill(ritual.completionStatus.colorHex == "FFBE00" ? Color(hex: "FFBE00") : Color.clear)
                    .frame(width: 8, height: 8)
            }
        }
        .padding()
        .frame(width: 140, height: 140)
        .background(Color(hex: "0a1a3b"))
        .cornerRadius(16)
    }
}

#Preview {
    MainDashboardView()
}

