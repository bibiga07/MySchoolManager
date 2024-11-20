//
//  CustomTabBarNavigationView.swift
//  MySchoolManager
//
//  Created by 김주환 on 11/20/24.
//

import SwiftUI

struct CustomTabBarNavigationView: View {
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selectedTab: $selectedTab)
            
            Rectangle()
                .foregroundColor(.white)
                .frame(width: 353, height: 54)
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.25), radius: 0.25, x: 0, y: 0.5)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(red: 0.97, green: 0.97, blue: 0.97), lineWidth: 1)
                )
                .overlay {
                    HStack {
                        TabButton(tab: .home, selectedTab: $selectedTab)
                        TabButton(tab: .search, selectedTab: $selectedTab)
                        TabButton(tab: .profile, selectedTab: $selectedTab)
                    }
                }
        }
    }
}

#Preview {
    CustomTabBarNavigationView()
}
