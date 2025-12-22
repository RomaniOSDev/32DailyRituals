//
//  RitualListView.swift
//  32DailyRituals
//
//  Created by Роман Главацкий on 19.12.2025.
//

import SwiftUI

struct RitualListView: View {
    @StateObject private var viewModel = RitualViewModel()
    let timeOfDay: TimeOfDay?
    
    @State private var showAddRitual = false
    
    init(timeOfDay: TimeOfDay? = nil) {
        self.timeOfDay = timeOfDay
    }
    
    var body: some View {
        ZStack {
            Color(hex: "02102b")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Search Bar
                searchBar
                
                // Filters
                filtersSection
                
                // Rituals List
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.filteredRituals) { ritual in
                            NavigationLink(destination: RitualDetailView(ritual: ritual)) {
                                RitualRowView(ritual: ritual)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(timeOfDay?.rawValue ?? "All Rituals")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showAddRitual = true }) {
                    Image(systemName: "plus")
                        .foregroundColor(Color(hex: "BD0E1B"))
                }
            }
        }
        .sheet(isPresented: $showAddRitual) {
            AddEditRitualView()
        }
        .onAppear {
            if let timeOfDay = timeOfDay {
                viewModel.selectedTimeOfDay = timeOfDay
            }
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(hex: "8A8F98").opacity(0.7))
            
            TextField("Search rituals...", text: $viewModel.searchText)
                .foregroundColor(.white.opacity(0.95))
        }
        .padding()
        .background(Color(hex: "0a1a3b"))
        .cornerRadius(12)
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    private var filtersSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // Time Filter
                ForEach(TimeOfDay.allCases, id: \.self) { time in
                    FilterChip(
                        title: time.rawValue,
                        isSelected: viewModel.selectedTimeOfDay == time,
                        color: Color(hex: time.colorHex)
                    ) {
                        viewModel.selectedTimeOfDay = viewModel.selectedTimeOfDay == time ? nil : time
                    }
                }
                
                // Category Filter
                ForEach(RitualCategory.allCases, id: \.self) { category in
                    FilterChip(
                        title: category.rawValue,
                        isSelected: viewModel.selectedCategory == category,
                        color: Color(hex: "BD0E1B")
                    ) {
                        viewModel.selectedCategory = viewModel.selectedCategory == category ? nil : category
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }
}

struct RitualRowView: View {
    let ritual: DailyRitual
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(ritual.color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: ritual.iconName)
                    .font(.title3)
                    .foregroundColor(ritual.color)
            }
            
            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(ritual.name)
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.95))
                
                Text(ritual.description)
                    .font(.caption)
                    .foregroundColor(Color(hex: "8A8F98").opacity(0.7))
                    .lineLimit(1)
                
                HStack(spacing: 8) {
                    Label("\(ritual.durationInMinutes) min", systemImage: "clock")
                        .font(.caption2)
                        .foregroundColor(Color(hex: "8A8F98").opacity(0.7))
                    
                    if ritual.streak > 0 {
                        Label("\(ritual.streak)", systemImage: "flame.fill")
                            .font(.caption2)
                            .foregroundColor(Color(hex: "FFBE00"))
                    }
                }
            }
            
            Spacer()
            
            // Status
            VStack {
                Circle()
                    .fill(Color(hex: ritual.completionStatus.colorHex))
                    .frame(width: 12, height: 12)
                
                Spacer()
            }
        }
        .padding()
        .background(Color(hex: "0a1a3b"))
        .cornerRadius(16)
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : Color(hex: "8A8F98"))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? color : Color(hex: "0a1a3b"))
                .cornerRadius(20)
        }
    }
}

#Preview {
    NavigationView {
        RitualListView()
    }
}

