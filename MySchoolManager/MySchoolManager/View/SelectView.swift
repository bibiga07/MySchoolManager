//
//  SelectView.swift
//  MySchoolManager
//
//  Created by 김주환 on 11/7/24.
//

import SwiftUI

struct SelectView: View {
    
    @StateObject private var viewModel = SchoolSearchViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("재학중인")
                .font(.system(size: 20, weight: .semibold))
            Text("학교를 알려주세요!")
                .font(.system(size: 20, weight: .semibold))
            
            TextField("학교 이름", text: $viewModel.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: viewModel.searchText) { _ in
                    viewModel.searchSchools()
                }
            
            if viewModel.filteredSchools.isEmpty {
                Text("검색 결과가 없습니다.")
            } else {
                List(viewModel.filteredSchools) { school in
                    Button(action: {
                        saveSchoolInfo(school: school)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        VStack(alignment: .leading) {
                            Text(school.schoolName)
                                .font(.headline)
                            Text("학교 코드: \(school.schoolCode)")
                                .font(.subheadline)
                        }
                    }
                }
            }
        }
        
        
    }
    
    func saveSchoolInfo(school: SchoolSearchModel) {
        UserDefaults.standard.set(school.schoolName, forKey: "selectedSchoolName")
        UserDefaults.standard.set(school.schoolCode, forKey: "selectedSchoolCode")
    }
}

#Preview {
    SelectView()
}
