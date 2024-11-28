//
//  MySchoolManagerApp.swift
//  MySchoolManager
//
//  Created by 김주환 on 11/7/24.
//

import SwiftUI

@main
struct MySchoolManagerApp: App {
    @State private var selectedSchoolName: String? = nil

    var body: some Scene {
        WindowGroup {
            if let schoolName = selectedSchoolName, !schoolName.isEmpty {
                // schoolName이 비어 있지 않으면 HomeView로 이동
                CustomTabBarNavigationView()
            } else {
                // schoolName이 비어 있으면 SelectView로 이동
                SelectView()
                    .onAppear {
                        // 앱 시작 시 UserDefaults에서 selectedSchoolName 값 가져오기
                        selectedSchoolName = UserDefaults.standard.string(forKey: "selectedSchoolName")
                    }
            }
        }
    }
}
