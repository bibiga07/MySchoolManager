//
//  TabButton.swift
//  MySchoolManager
//
//  Created by 김주환 on 11/20/24.
//

import SwiftUI

struct TabButton: View {
    let tab: Tab
    @Binding var selectedTab: Tab
    
    var body: some View {
        Button(action: {
            selectedTab = tab
        }) {
            VStack {
                Image(systemName: tab.icon)
                    .font(.system(size: 20))
                    .foregroundColor(selectedTab == tab ? .cPrimary : .black)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

enum Tab: String {
    case home
    case search
    case profile
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .search: return "Search"
        case .profile: return "Profile"
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .search: return "magnifyingglass"
        case .profile: return "person.fill"
        }
    }
}

#Preview {
    TabButton(tab: .home, selectedTab: .constant(.home))
}
