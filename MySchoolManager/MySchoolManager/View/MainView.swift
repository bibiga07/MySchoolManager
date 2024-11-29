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
    
    func formatMealDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "M월d일(EEE)"
            formatter.locale = Locale(identifier: "ko_KR")
            return formatter.string(from: date)
        }
        return dateString
    }
    
    func formatDateToDay(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "EEEE" // 요일 포맷으로 변환
            formatter.locale = Locale(identifier: "ko_KR")
            return formatter.string(from: date)
        }
        return dateString
    }
    
    func cleanDishName(_ text: String) -> String {
        var cleanedText = text.replacingOccurrences(of: "<br/>", with: "\n")
        
        let allergyRegex = try! NSRegularExpression(pattern: "\\(\\d+(\\.\\d+)*\\)", options: [])
        cleanedText = allergyRegex.stringByReplacingMatches(in: cleanedText, options: [], range: NSRange(location: 0, length: cleanedText.count), withTemplate: "")
        
        return cleanedText
    }
    
    func filteredSchedules(for date: String, dayIndex: Int) -> [ScheduleInfo] {
        return scheduleViewModel.schedule.filter { schedule in
            // Ensure both are the same type for comparison
            if let periodInt = Int(schedule.period) {
                return schedule.date == date && periodInt == dayIndex + 1
            }
            return false
        }
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
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(mealViewModel.meals) { meal in
                        Rectangle()
                            .frame(width:124, height: 172)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 2)
                                ZStack {
                                    VStack(alignment: .leading) {
                                        Spacer()
                                            .frame(height: 11)
                                        Rectangle()
                                            .frame(width:99 ,height: 19)
                                            .foregroundColor(.cPrimary)
                                            .cornerRadius(10)
                                            .overlay {
                                                Text("\(formatMealDate(meal.date))")
                                                    .font(.system(size: 12, weight: .regular))
                                                    .foregroundColor(.white)
                                            }
                                        Spacer()
                                            .frame(height:14)
                                        let cleanedMealName = cleanDishName(meal.dishName)
                                        
                                        Text(cleanedMealName)
                                            .font(.system(size: 12, weight: .regular))
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 12)
                                    if meal.mealType == "조식" {
                                        Image("breakfast")
                                            .resizable()
                                            .frame(width: 19, height: 21)
                                            .padding(.leading, 85)
                                            .padding(.top, 130)
                                    } else if meal.mealType == "중식" {
                                        Image("lunch")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 25)
                                            .padding(.leading, 80)
                                            .padding(.top, 130)
                                    } else {
                                        Image("dinner")
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                            .padding(.leading, 85)
                                            .padding(.top, 130)
                                    }
                                }
                            }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 190)
            
            Spacer()
            
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible()), count: 5), // 5개의 열 (월~금)
                spacing: 10
            ) {
                // 월~금 요일 반복
                ForEach(0..<5) { dayIndex in
                    // 각 요일에 대해 7교시씩 표시
                    VStack {
                        Text(scheduleViewModel.getWeekDates()[dayIndex])
                            .font(.system(size: 14, weight: .bold))
                            .padding(.bottom, 5)
                        
                        ForEach(0..<7) { periodIndex in
                            // 각 교시별로 수업 정보 가져오기
                            let date = scheduleViewModel.getWeekDates()[dayIndex]
                            let filteredSchedules = filteredSchedules(for: date, dayIndex: periodIndex)
                            
                            VStack(alignment: .leading) {
                                if filteredSchedules.isEmpty {
                                    // 수업이 없다면 "-" 표시
                                    Text("-")
                                        .font(.system(size: 12, weight: .regular))
                                        .foregroundColor(.black)
                                } else {
                                    ForEach(filteredSchedules) { schedule in
                                        Text(schedule.subjectName)
                                            .padding(.vertical, 2)
                                            .font(.system(size: 12, weight: .regular))
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                        }
                    }
                }
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
            let weekDates = scheduleViewModel.getWeekDates()
            for date in weekDates {
                scheduleViewModel.fetchSchedule(
                    officeCode: officeCode,
                    schoolCode: schoolCode,
                    date: date,  // 각 날짜로 반복 호출
                    schoolName: schoolName,
                    selectedClass: selectedClass,
                    selectedGrade: selectedGrade
                )
            }
        }
    }
}

#Preview {
    MainView()
}
