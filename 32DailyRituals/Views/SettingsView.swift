//
//  SettingsView.swift
//  32DailyRituals
//
//  Created by Роман Главацкий on 19.12.2025.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color(hex: "02102b")
                .ignoresSafeArea()
            
            List {
                Section {
                    // App Info
                    HStack {
                        Spacer()
                        VStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(Color(hex: "BD0E1B").opacity(0.2))
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "sparkles")
                                    .font(.system(size: 40))
                                    .foregroundColor(Color(hex: "BD0E1B"))
                            }
                            
                            Text("Daily Rituals")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white.opacity(0.95))
                            
                            Text("Version 1.0.0")
                                .font(.caption)
                                .foregroundColor(Color(hex: "8A8F98").opacity(0.7))
                        }
                        Spacer()
                    }
                    .padding(.vertical, 20)
                }
                .listRowBackground(Color(hex: "0a1a3b"))
                
                Section("Support") {
                    SettingsRow(
                        icon: "star.fill",
                        iconColor: Color(hex: "FFBE00"),
                        title: "Rate Us",
                        action: {
                            rateApp()
                        }
                    )
                    
                    SettingsRow(
                        icon: "lock.shield.fill",
                        iconColor: Color(hex: "4ECDC4"),
                        title: "Privacy Policy",
                        action: {
                            if let url = URL(string: "https://www.termsfeed.com/live/e617a8ed-d207-4c29-8109-95dc12657d97") {
                                UIApplication.shared.open(url)
                            }
                        }
                    )
                    
                    SettingsRow(
                        icon: "doc.text.fill",
                        iconColor: Color(hex: "6C5CE7"),
                        title: "Terms of Service",
                        action: {
                            if let url = URL(string: "https://www.termsfeed.com/live/f09d645e-e2f9-4eb4-acf6-f53174616196") {
                                UIApplication.shared.open(url)
                            }
                        }
                    )
                }
                .listRowBackground(Color(hex: "0a1a3b"))
                
                Section("About") {
                    SettingsRow(
                        icon: "info.circle.fill",
                        iconColor: Color(hex: "8A8F98"),
                        title: "About Daily Rituals",
                        action: {
                            // Можно добавить экран "О приложении"
                        }
                    )
                }
                .listRowBackground(Color(hex: "0a1a3b"))
            }
            .scrollContentBackground(.hidden)
            .background(Color(hex: "02102b"))
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private func rateApp() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
    
    private func openPrivacyPolicy() {
        // Замените на ваш URL политики конфиденциальности
        if let url = URL(string: "https://example.com/privacy") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openTermsOfService() {
        // Замените на ваш URL условий использования
        if let url = URL(string: "https://example.com/terms") {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.95))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(Color(hex: "8A8F98").opacity(0.7))
            }
            .padding(.vertical, 4)
        }
    }
}

#Preview {
    NavigationView {
        SettingsView()
    }
}

