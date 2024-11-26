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
    @FocusState private var isTextFieldFocused: Bool
    @FocusState private var isTextFieldFocused_Gr: Bool
    @FocusState private var isTextFieldFocused_Cl: Bool
    
    @State private var selectedSchoolName: String = ""
    @State private var selectedGrade = ""
    @State private var selectedClass = ""
    @StateObject private var keyboardResponder = KeyboardResponder()
    
    @State private var navigateToNextView = false
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading) {
                    Spacer().frame(height: 154)
                    if selectedSchoolName.isEmpty {
                        Text("재학중인")
                            .font(.system(size: 20, weight: .semibold))
                        Text("학교를 알려주세요!")
                            .font(.system(size: 20, weight: .semibold))
                    } else {
                        Text("몇 학년 몇 반인지 알려주세요!")
                            .font(.system(size: 20, weight: .semibold))
                    }
                    
                    if selectedSchoolName.isEmpty {
                        Spacer()
                            .frame(height: 26)
                    } else {
                        Spacer()
                            .frame(height: 18)
                    }
                    
                    if !selectedSchoolName.isEmpty {
                        HStack {
                            VStack(alignment: .leading) {
                                if isTextFieldFocused_Gr || !selectedGrade.isEmpty {
                                    Text("학년")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(isTextFieldFocused_Gr ? .cPrimary : .gray)
                                } else {
                                    Text("")
                                }
                                TextField("학년", text: $selectedGrade)
                                    .focused($isTextFieldFocused_Gr)
                                Rectangle()
                                    .frame(width: 120, height: 1)
                                    .foregroundColor(isTextFieldFocused_Gr ? .cPrimary : .gray)
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                if isTextFieldFocused_Cl || !selectedClass.isEmpty {
                                    Text("반")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(isTextFieldFocused_Cl ? .cPrimary : .gray)
                                } else {
                                    Text("")
                                }
                                TextField("반", text: $selectedClass)
                                    .focused($isTextFieldFocused_Cl)
                                Rectangle()
                                    .frame(width: 120, height: 1)
                                    .foregroundColor(isTextFieldFocused_Cl ? .cPrimary : .gray)
                            }
                        }
                        .frame(width: 313)
                        .padding(.bottom, 34)
                    }
                    
                    VStack(alignment: .leading) {
                        if isTextFieldFocused || !selectedSchoolName.isEmpty {
                            Text("학교이름")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(isTextFieldFocused ? .cPrimary : .gray)
                        } else {
                            Text("")
                        }
                        TextField("학교이름", text: Binding(
                            get: { selectedSchoolName.isEmpty ? viewModel.searchText : selectedSchoolName },
                            set: { newValue in
                                if selectedSchoolName.isEmpty {
                                    viewModel.searchText = newValue  // 검색 수행
                                } else {
                                    selectedSchoolName = newValue  // 선택된 학교 이름 표시
                                }
                            }
                        ))
                        .focused($isTextFieldFocused)
                        .onChange(of: viewModel.searchText) { _ in
                            if selectedSchoolName.isEmpty {
                                viewModel.searchSchools()  // 검색어 변경 시 검색 수행
                            }
                        }
                        Rectangle()
                            .frame(width: 313, height: 1)
                            .foregroundColor(isTextFieldFocused ? .cPrimary : .gray)
                    }
                    
                    if viewModel.filteredSchools.isEmpty {
                        Text("")
                    } else {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 26) {
                                ForEach(viewModel.filteredSchools) { school in
                                    Button(action: {
                                        saveSchoolInfo(school: school)
                                        selectedSchoolName = school.schoolName
                                        viewModel.searchText = ""
                                        viewModel.filteredSchools = []
                                        isTextFieldFocused = false
                                    }) {
                                        VStack(alignment: .leading, spacing: 7) {
                                            Text(school.schoolName)
                                                .font(.system(size: 13, weight: .semibold))
                                                .foregroundColor(.black)
                                            Text("학교 코드: \(school.schoolCode)")
                                                .font(.system(size: 12, weight: .semibold))
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.top, 23)
                    }
                }
                .padding(.leading, 42)
                .onTapGesture {
                    hideKeyboard()
                }
                
                
                
                Spacer()
                if !selectedSchoolName.isEmpty && !selectedClass.isEmpty && !selectedGrade.isEmpty {
                    Button {
                        saveAdditionalInfo()
                        navigateToNextView = true
                    } label: {
                        if keyboardResponder.isKeyboardVisible {
                            Rectangle()
                                .frame(maxWidth: .infinity, maxHeight: 56)
                                .foregroundColor(.cPrimary)
                                .overlay {
                                    Text("나의 학교 매니저 시작하기")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                        } else {
                            Rectangle()
                                .frame(maxWidth: .infinity, maxHeight: 80)
                                .foregroundColor(.cPrimary)
                                .overlay {
                                    Text("나의 학교 매니저 시작하기")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                        }
                    }
                    .background(
                        NavigationLink("", destination: CustomTabBarNavigationView(), isActive: $navigateToNextView)
                            .hidden()
                    )
                    
                }
                
            }
            .ignoresSafeArea(.container)
            
        }
    }
    
    
    func saveSchoolInfo(school: SchoolSearchModel) {
        UserDefaults.standard.set(school.schoolName, forKey: "selectedSchoolName")
        UserDefaults.standard.set(school.schoolCode, forKey: "selectedSchoolCode")
        UserDefaults.standard.set(school.officeCode, forKey: "selectedOfficeCode")
    }
    
    func saveAdditionalInfo() {
        UserDefaults.standard.set(selectedGrade, forKey: "selectedGrade")
        UserDefaults.standard.set(selectedClass, forKey: "selectedClass")
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    SelectView()
}
