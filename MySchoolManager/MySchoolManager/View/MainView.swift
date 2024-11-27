//
//  MainView.swift
//  MySchoolManager
//
//  Created by 김주환 on 11/19/24.
//

import SwiftUI

struct MainView: View {
    @ObservedObject private var mealViewModel = MealViewModel()
    @ObservedObject private var scheduleViewModel = ScheduleViewModel()
    
    @State private var schoolName: String = UserDefaults.standard.string(forKey: "selectedSchoolName") ?? "학교 이름 없음"
    @State private var selectedGrade: String = UserDefaults.standard.string(forKey: "selectedGrade") ?? "학년 없음"
    @State private var selectedClass: String = UserDefaults.standard.string(forKey: "selectedClass") ?? "반 없음"
    @State private var officeCode: String = UserDefaults.standard.string(forKey: "selectedOfficeCode") ?? "교육청 코드 없음"
    @State private var schoolCode: String = UserDefaults.standard.string(forKey: "selectedSchoolCode") ?? "학교 코드 없음"
    
    private var todayDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일 EEEE"
        return formatter.string(from: Date())
    }
    
    private var sendDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: Date())
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 37) {
                Text("\(schoolName) \(selectedGrade)학년 \(selectedClass)반")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 18)
                Text(todayDate)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 19)
            }
            Spacer()
            
            List(mealViewModel.meals) { meal in
                VStack(alignment: .leading) {
                    Text("\(meal.date) - \(meal.mealType)") // 날짜와 식사 타입
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(meal.dishName) // 급식 메뉴
                        .font(.body)
                        .foregroundColor(.black)
                }
            }
            
            List(scheduleViewModel.schedule) { schedule in
                Text(schedule.subjectName)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            VStack {
                Color(.cPrimary).frame(height: 295).ignoresSafeArea()
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            mealViewModel.fetchMeal(officeCode: officeCode, schoolCode: schoolCode, date: sendDate)
            scheduleViewModel.fetchSchedule(officeCode: officeCode, schoolCode: schoolCode, date: sendDate)
        }
    }
}


#Preview {
    MainView()
}
