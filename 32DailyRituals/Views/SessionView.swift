//
//  SessionView.swift
//  32DailyRituals
//
//  Created by Роман Главацкий on 19.12.2025.
//

import SwiftUI

struct SessionView: View {
    @StateObject private var sessionViewModel: SessionViewModel
    @Environment(\.dismiss) var dismiss
    
    let ritual: DailyRitual
    
    init(ritual: DailyRitual) {
        self.ritual = ritual
        _sessionViewModel = StateObject(wrappedValue: SessionViewModel(ritual: ritual))
    }
    
    var body: some View {
        ZStack {
            Color(hex: "02102b")
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                // Ritual Info
                VStack(spacing: 16) {
                    Image(systemName: ritual.iconName)
                        .font(.system(size: 60))
                        .foregroundColor(ritual.color)
                    
                    Text(ritual.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white.opacity(0.95))
                    
                    Text(ritual.description)
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "8A8F98").opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 40)
                
                // Timer
                timerSection
                
                // Progress
                progressSection
                
                Spacer()
                
                // Controls
                controlsSection
                
                // Optional Fields
                if sessionViewModel.isRunning {
                    optionalFieldsSection
                }
            }
            .padding()
        }
        .onAppear {
            if !sessionViewModel.isRunning {
                sessionViewModel.startSession()
            }
        }
    }
    
    private var timerSection: some View {
        VStack(spacing: 16) {
            Text(formatTime(sessionViewModel.elapsedTime))
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .foregroundColor(.white.opacity(0.95))
            
            if ritual.duration > 0 {
                Text("of \(formatTime(ritual.duration))")
                    .font(.title3)
                    .foregroundColor(Color(hex: "8A8F98").opacity(0.7))
            }
        }
    }
    
    private var progressSection: some View {
        VStack(spacing: 8) {
            ProgressView(value: sessionViewModel.progress)
                .progressViewStyle(LinearProgressViewStyle(tint: ritual.color))
                .scaleEffect(x: 1, y: 3, anchor: .center)
            
            if ritual.duration > 0 && sessionViewModel.remainingTime > 0 {
                Text("\(formatTime(sessionViewModel.remainingTime)) remaining")
                    .font(.caption)
                    .foregroundColor(Color(hex: "8A8F98").opacity(0.7))
            }
        }
        .padding(.horizontal)
    }
    
    private var controlsSection: some View {
        VStack(spacing: 12) {
            if sessionViewModel.isRunning {
                HStack(spacing: 16) {
                    Button(action: {
                        sessionViewModel.pauseSession()
                    }) {
                        HStack {
                            Image(systemName: "pause.fill")
                            Text("Pause")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "0a1a3b"))
                        .cornerRadius(16)
                    }
                    
                    Button(action: {
                        sessionViewModel.completeSession()
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Complete")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "FFBE00"))
                        .cornerRadius(16)
                    }
                }
                
                Button(action: {
                    sessionViewModel.skipSession()
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "xmark.circle.fill")
                        Text("Skip")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "BD0E1B"))
                    .cornerRadius(16)
                }
            } else {
                Button(action: {
                    sessionViewModel.resumeSession()
                }) {
                    HStack {
                        Image(systemName: "play.fill")
                        Text("Resume")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(ritual.color)
                    .cornerRadius(16)
                }
            }
        }
    }
    
    private var optionalFieldsSection: some View {
        VStack(spacing: 16) {
            Divider()
                .background(Color(hex: "8A8F98").opacity(0.3))
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Session Details")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.95))
                
                // Quality
                VStack(alignment: .leading, spacing: 8) {
                    Text("Quality")
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "8A8F98").opacity(0.7))
                    
                    HStack {
                        ForEach(1...5, id: \.self) { index in
                            Button(action: {
                                sessionViewModel.quality = index
                            }) {
                                Image(systemName: index <= sessionViewModel.quality ? "star.fill" : "star")
                                    .font(.title3)
                                    .foregroundColor(Color(hex: "FFBE00"))
                            }
                        }
                    }
                }
                
                // Mood
                VStack(alignment: .leading, spacing: 8) {
                    Text("Mood Before: \(sessionViewModel.moodBefore)")
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "8A8F98").opacity(0.7))
                    
                    Slider(value: Binding(
                        get: { Double(sessionViewModel.moodBefore) },
                        set: { sessionViewModel.moodBefore = Int($0) }
                    ), in: 1...10, step: 1)
                    .tint(ritual.color)
                    
                    Text("Mood After: \(sessionViewModel.moodAfter)")
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "8A8F98").opacity(0.7))
                    
                    Slider(value: Binding(
                        get: { Double(sessionViewModel.moodAfter) },
                        set: { sessionViewModel.moodAfter = Int($0) }
                    ), in: 1...10, step: 1)
                    .tint(ritual.color)
                }
                
                // Notes
                TextField("Notes (optional)", text: $sessionViewModel.notes, axis: .vertical)
                    .foregroundColor(.white.opacity(0.95))
                    .lineLimit(3...5)
                    .padding()
                    .background(Color(hex: "0a1a3b"))
                    .cornerRadius(12)
            }
        }
    }
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) / 60 % 60
        let seconds = Int(timeInterval) % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}

#Preview {
    SessionView(ritual: DailyRitual(
        name: "Morning Meditation",
        description: "10 minutes of silence",
        timeOfDay: .morning,
        duration: 600,
        category: .mindfulness,
        iconName: "brain.head.profile"
    ))
}

