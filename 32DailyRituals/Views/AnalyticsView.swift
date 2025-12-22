//
//  AnalyticsView.swift
//  32DailyRituals
//
//  Created by Роман Главацкий on 19.12.2025.
//

import SwiftUI

struct AnalyticsView: View {
    @StateObject private var viewModel = AnalyticsViewModel()
    @State private var selectedPeriod: AnalyticsViewModel.Period = .week
    
    var body: some View {
        ZStack {
            Color(hex: "02102b")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Period Selector
                    periodSelector
                    
                    // Completion Rate
                    completionRateCard
                    
                    // Stats Grid
                    statsGrid
                    
                    // Best Ritual
                    bestRitualCard
                    
                    // Time Spent
                    timeSpentCard
                }
                .padding()
            }
        }
        .navigationTitle("Analytics")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            viewModel.updateTodaySummary()
        }
    }
    
    private var periodSelector: some View {
        Picker("Period", selection: $selectedPeriod) {
            ForEach(AnalyticsViewModel.Period.allCases, id: \.self) { period in
                Text(period.rawValue).tag(period)
            }
        }
        .pickerStyle(.segmented)
        .background(Color(hex: "0a1a3b"))
        .cornerRadius(12)
    }
    
    private var completionRateCard: some View {
        VStack(spacing: 16) {
            Text("Completion Rate")
                .font(.headline)
                .foregroundColor(.white.opacity(0.95))
            
            let rate = viewModel.getCompletionRate(for: selectedPeriod)
            
            ZStack {
                Circle()
                    .stroke(Color(hex: "0a1a3b"), lineWidth: 12)
                    .frame(width: 120, height: 120)
                
                Circle()
                    .trim(from: 0, to: rate)
                    .stroke(Color(hex: "FFBE00"), style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                
                Text("\(Int(rate * 100))%")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white.opacity(0.95))
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(hex: "0a1a3b"))
        .cornerRadius(16)
    }
    
    private var statsGrid: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                StatCard(
                    title: "Total Rituals",
                    value: "\(viewModel.getSummaries(for: selectedPeriod).reduce(0) { $0 + $1.totalRituals })",
                    color: Color(hex: "BD0E1B")
                )
                
                StatCard(
                    title: "Completed",
                    value: "\(viewModel.getSummaries(for: selectedPeriod).reduce(0) { $0 + $1.completedRituals.count })",
                    color: Color(hex: "FFBE00")
                )
            }
            
            if let moodChange = viewModel.getAverageMoodChange(for: selectedPeriod) {
                StatCard(
                    title: "Avg Mood Change",
                    value: String(format: "%.1f", moodChange),
                    color: Color(hex: "4ECDC4")
                )
            }
        }
    }
    
    private var bestRitualCard: some View {
        Group {
            if let bestRitual = viewModel.getBestRitual() {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Best Performing Ritual")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.95))
                    
                    HStack {
                        Image(systemName: bestRitual.iconName)
                            .font(.title2)
                            .foregroundColor(bestRitual.color)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(bestRitual.name)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white.opacity(0.95))
                            
                            HStack(spacing: 8) {
                                Label("\(bestRitual.streak)", systemImage: "flame.fill")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "FFBE00"))
                            }
                        }
                        
                        Spacer()
                    }
                }
                .padding()
                .background(Color(hex: "0a1a3b"))
                .cornerRadius(16)
            } else {
                EmptyView()
            }
        }
    }
    
    private var timeSpentCard: some View {
        let totalTime = viewModel.getTotalTimeSpent(for: selectedPeriod)
        let hours = Int(totalTime) / 3600
        let minutes = (Int(totalTime) % 3600) / 60
        
        return VStack(spacing: 12) {
            Text("Total Time Spent")
                .font(.headline)
                .foregroundColor(.white.opacity(0.95))
            
            HStack(spacing: 8) {
                Text("\(hours)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "FFBE00"))
                Text("hours")
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "8A8F98").opacity(0.7))
                
                Text("\(minutes)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "FFBE00"))
                Text("minutes")
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "8A8F98").opacity(0.7))
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(hex: "0a1a3b"))
        .cornerRadius(16)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(Color(hex: "8A8F98").opacity(0.7))
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(hex: "0a1a3b"))
        .cornerRadius(16)
    }
}

#Preview {
    NavigationView {
        AnalyticsView()
    }
}

