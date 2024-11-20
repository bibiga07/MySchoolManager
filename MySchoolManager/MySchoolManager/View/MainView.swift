//
//  MainView.swift
//  MySchoolManager
//
//  Created by 김주환 on 11/19/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            Text(".")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            VStack {
                Color(.cPrimary).frame(height: 295).ignoresSafeArea()
                Spacer()
            }
        }
    }
}

#Preview {
    MainView()
}
