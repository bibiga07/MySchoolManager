//
//  TabView.swift
//  MySchoolManager
//
//  Created by 김주환 on 11/20/24.
//

import SwiftUI

struct TabView: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        switch selectedTab {
        case .home:
            NavigationView {
                MainView()
            }
        case .search:
            NavigationView {
                SelectView()
            }
        case .profile:
            NavigationView {
                MainView()
            }
        }
    }
}

#Preview {
    TabView(selectedTab: .constant(.home))
}
