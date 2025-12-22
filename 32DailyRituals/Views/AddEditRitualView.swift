//
//  AddEditRitualView.swift
//  32DailyRituals
//
//  Created by Роман Главацкий on 19.12.2025.
//

import SwiftUI

struct AddEditRitualView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = RitualViewModel()
    
    let ritual: DailyRitual?
    
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var timeOfDay: TimeOfDay = .morning
    @State private var duration: Int = 10
    @State private var category: RitualCategory = .mindfulness
    @State private var iconName: String = "brain.head.profile"
    @State private var priority: PriorityLevel = .medium
    @State private var isActive: Bool = true
    
    init(ritual: DailyRitual? = nil) {
        self.ritual = ritual
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "02102b")
                    .ignoresSafeArea()
                
                Form {
                    Section("Basic Information") {
                        TextField("Ritual Name", text: $name)
                            .foregroundColor(.white.opacity(0.95))
                        TextField("Description", text: $description, axis: .vertical)
                            .foregroundColor(.white.opacity(0.95))
                            .lineLimit(3...5)
                    }
                    .listRowBackground(Color(hex: "0a1a3b"))
                    
                    Section("Schedule") {
                        Picker("Time of Day", selection: $timeOfDay) {
                            ForEach(TimeOfDay.allCases, id: \.self) { time in
                                Text(time.rawValue).tag(time)
                            }
                        }
                        .foregroundColor(.white.opacity(0.95))
                        
                        Picker("Duration (minutes)", selection: $duration) {
                            ForEach([5, 10, 15, 20, 30, 45, 60], id: \.self) { minutes in
                                Text("\(minutes) min").tag(minutes)
                            }
                        }
                        .foregroundColor(.white.opacity(0.95))
                    }
                    .listRowBackground(Color(hex: "0a1a3b"))
                    
                    Section("Category & Priority") {
                        Picker("Category", selection: $category) {
                            ForEach(RitualCategory.allCases, id: \.self) { cat in
                                HStack {
                                    Image(systemName: cat.icon)
                                    Text(cat.rawValue)
                                }
                                .tag(cat)
                            }
                        }
                        .foregroundColor(.white.opacity(0.95))
                        
                        Picker("Priority", selection: $priority) {
                            ForEach(PriorityLevel.allCases, id: \.self) { level in
                                Text(level.rawValue).tag(level)
                            }
                        }
                        .foregroundColor(.white.opacity(0.95))
                    }
                    .listRowBackground(Color(hex: "0a1a3b"))
                    
                    Section("Icon") {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(["brain.head.profile", "figure.walk", "fork.knife", "checklist", "heart.fill", "book.fill", "person.2.fill", "paintbrush.fill", "sun.max.fill", "moon.fill", "leaf.fill"], id: \.self) { icon in
                                    Button(action: { iconName = icon }) {
                                        Image(systemName: icon)
                                            .font(.title2)
                                            .foregroundColor(iconName == icon ? Color(hex: "BD0E1B") : Color(hex: "8A8F98"))
                                            .padding()
                                            .background(iconName == icon ? Color(hex: "BD0E1B").opacity(0.2) : Color(hex: "0a1a3b"))
                                            .cornerRadius(12)
                                    }
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    .listRowBackground(Color(hex: "0a1a3b"))
                    
                    Section {
                        Toggle("Active", isOn: $isActive)
                            .foregroundColor(.white.opacity(0.95))
                    }
                    .listRowBackground(Color(hex: "0a1a3b"))
                }
                .scrollContentBackground(.hidden)
                .background(Color(hex: "02102b"))
            }
            .navigationTitle(ritual == nil ? "New Ritual" : "Edit Ritual")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "BD0E1B"))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveRitual()
                    }
                    .foregroundColor(Color(hex: "BD0E1B"))
                    .fontWeight(.semibold)
                }
            }
        }
        .onAppear {
            if let ritual = ritual {
                loadRitual(ritual)
            }
        }
    }
    
    private func loadRitual(_ ritual: DailyRitual) {
        name = ritual.name
        description = ritual.description
        timeOfDay = ritual.timeOfDay
        duration = ritual.durationInMinutes
        category = ritual.category
        iconName = ritual.iconName
        priority = ritual.priority
        isActive = ritual.isActive
    }
    
    private func saveRitual() {
        guard !name.isEmpty else { return }
        
        let newRitual = DailyRitual(
            id: ritual?.id ?? UUID(),
            name: name,
            description: description,
            timeOfDay: timeOfDay,
            duration: TimeInterval(duration * 60),
            category: category,
            iconName: iconName,
            isActive: isActive,
            priority: priority,
            streak: ritual?.streak ?? 0,
            bestStreak: ritual?.bestStreak ?? 0,
            lastCompleted: ritual?.lastCompleted
        )
        
        DataManager.shared.saveRitual(newRitual)
        dismiss()
    }
}

#Preview {
    AddEditRitualView()
}

