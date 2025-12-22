//
//  RitualDetailView.swift
//  32DailyRituals
//
//  Created by Роман Главацкий on 19.12.2025.
//

import SwiftUI

struct RitualDetailView: View {
    @StateObject private var viewModel = RitualViewModel()
    @StateObject private var analyticsViewModel = AnalyticsViewModel()
    let ritual: DailyRitual
    
    @State private var showEditSheet = false
    @State private var showDeleteAlert = false
    
    var body: some View {
        ZStack {
            Color(hex: "02102b")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header Card
                    headerCard
                    
                    // Stats
                    statsSection
                    
                    // Actions
                    actionsSection
                    
                    // History
                    historySection
                }
                .padding()
            }
        }
        .navigationTitle(ritual.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: { showEditSheet = true }) {
                        Label("Edit", systemImage: "pencil")
                    }
                    Button(role: .destructive, action: { showDeleteAlert = true }) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(Color(hex: "BD0E1B"))
                }
            }
        }
        .sheet(isPresented: $showEditSheet) {
            AddEditRitualView(ritual: ritual)
        }
        .alert("Delete Ritual", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteRitual(ritual)
            }
        } message: {
            Text("Are you sure you want to delete this ritual? This action cannot be undone.")
        }
    }
    
    private var headerCard: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(ritual.color.opacity(0.2))
                    .frame(width: 80, height: 80)
                
                Image(systemName: ritual.iconName)
                    .font(.system(size: 40))
                    .foregroundColor(ritual.color)
            }
            
            Text(ritual.description)
                .font(.body)
                .foregroundColor(.white.opacity(0.95))
                .multilineTextAlignment(.center)
            
            HStack(spacing: 24) {
                VStack {
                    Text("\(ritual.durationInMinutes)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white.opacity(0.95))
                    Text("minutes")
                        .font(.caption)
                        .foregroundColor(Color(hex: "8A8F98").opacity(0.7))
                }
                
                Divider()
                    .frame(height: 40)
                    .background(Color(hex: "8A8F98").opacity(0.3))
                
                VStack {
                    Text("\(ritual.streak)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "FFBE00"))
                    Text("day streak")
                        .font(.caption)
                        .foregroundColor(Color(hex: "8A8F98").opacity(0.7))
                }
                
                Divider()
                    .frame(height: 40)
                    .background(Color(hex: "8A8F98").opacity(0.3))
                
                VStack {
                    Text("\(ritual.bestStreak)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white.opacity(0.95))
                    Text("best")
                        .font(.caption)
                        .foregroundColor(Color(hex: "8A8F98").opacity(0.7))
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(hex: "0a1a3b"))
        .cornerRadius(16)
    }
    
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Details")
                .font(.headline)
                .foregroundColor(.white.opacity(0.95))
            
            VStack(spacing: 8) {
                DetailRow(label: "Time of Day", value: ritual.timeOfDay.rawValue)
                DetailRow(label: "Category", value: ritual.category.rawValue)
                DetailRow(label: "Priority", value: ritual.priority.rawValue)
                DetailRow(label: "Status", value: ritual.completionStatus.rawValue)
            }
        }
        .padding()
        .background(Color(hex: "0a1a3b"))
        .cornerRadius(16)
    }
    
    private var actionsSection: some View {
        VStack(spacing: 12) {
            NavigationLink(destination: SessionView(ritual: ritual)) {
                HStack {
                    Image(systemName: "play.circle.fill")
                        .font(.title2)
                    Text("Start Ritual")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(ritual.color)
                .cornerRadius(16)
            }
            
            HStack(spacing: 12) {
                Button(action: {
                    viewModel.completeRitual(ritual)
                }) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Complete")
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "FFBE00"))
                    .cornerRadius(16)
                }
                
                Button(action: {
                    viewModel.skipRitual(ritual)
                }) {
                    HStack {
                        Image(systemName: "xmark.circle.fill")
                        Text("Skip")
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "BD0E1B"))
                    .cornerRadius(16)
                }
            }
        }
    }
    
    private var historySection: some View {
        let sessions = DataManager.shared.getSessions(for: ritual.id)
        
        return VStack(alignment: .leading, spacing: 12) {
            Text("History")
                .font(.headline)
                .foregroundColor(.white.opacity(0.95))
            
            if sessions.isEmpty {
                Text("No sessions yet")
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "8A8F98").opacity(0.7))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "0a1a3b"))
                    .cornerRadius(12)
            } else {
                ForEach(sessions.prefix(5)) { session in
                    SessionRowView(session: session)
                }
            }
        }
        .padding()
        .background(Color(hex: "0a1a3b"))
        .cornerRadius(16)
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(Color(hex: "8A8F98").opacity(0.7))
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.95))
        }
    }
}

struct SessionRowView: View {
    let session: RitualSession
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(session.startTime.formatted(date: .abbreviated, time: .shortened))
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.95))
                
                if let quality = session.quality {
                    HStack(spacing: 4) {
                        ForEach(1...5, id: \.self) { index in
                            Image(systemName: index <= quality ? "star.fill" : "star")
                                .font(.caption2)
                                .foregroundColor(Color(hex: "FFBE00"))
                        }
                    }
                }
            }
            
            Spacer()
            
            if session.duration > 0 {
                Text(formatDuration(session.duration))
                    .font(.caption)
                    .foregroundColor(Color(hex: "8A8F98").opacity(0.7))
            }
        }
        .padding(.vertical, 4)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        return "\(minutes) min"
    }
}

#Preview {
    NavigationView {
        RitualDetailView(ritual: DailyRitual(
            name: "Morning Meditation",
            description: "10 minutes of silence",
            timeOfDay: .morning,
            duration: 600,
            category: .mindfulness,
            iconName: "brain.head.profile"
        ))
    }
}

