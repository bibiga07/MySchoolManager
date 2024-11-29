//
//  ScheduleViewModel.swift
//  MySchoolManager
//
//  Created by 김주환 on 11/27/24.
//

import Foundation
import Alamofire

class ScheduleViewModel: ObservableObject {
    @Published var schedule: [ScheduleInfo] = []
    
    private let apiKey = "e07b8244818e462db88f133bf6fbfa35"
    private let baseUrl = "https://open.neis.go.kr/hub/hisTimetable"
    
    func fetchSchedule(officeCode: String, schoolCode: String, date: String, schoolName: String, selectedClass: String, selectedGrade: String) {
        var parameters: [String: String] = [
                "ATPT_OFCDC_SC_CODE": officeCode,
                "SD_SCHUL_CODE": schoolCode,
                "KEY": apiKey,
                "GRADE": selectedGrade,
                "ALL_TI_YMD": date,
                "Type": "xml"
            ]
            
            if schoolName.contains("중학교") {
                parameters["CLASS_NM"] = selectedClass
            } else {
                parameters["CLRM_NM"] = selectedClass
            }
            
            AF.request(baseUrl, method: .get, parameters: parameters)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        let parser = XMLParser(data: data)
                        let parserDelegate = ScheduleData(date: date)
                        parser.delegate = parserDelegate
                        
                        if parser.parse() {
                            DispatchQueue.main.async {
                                self.schedule.append(contentsOf: parserDelegate.scheduleInfos)
                            }
                        }
                    case .failure(let error):
                        print("API 요청 실패: \(error.localizedDescription)")
                    }
                }
    }
    
    func getWeekDates() -> [String] {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        
        var weekDates: [String] = []
        for i in 0..<5 {
            if let date = calendar.date(byAdding: .day, value: i, to: Date().startOfWeek) {
                weekDates.append(formatter.string(from: date))
            }
        }
        return weekDates
    }
}

extension Date {
    var startOfWeek: Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        components.weekday = calendar.firstWeekday
        return calendar.date(from: components)!
    }
}
