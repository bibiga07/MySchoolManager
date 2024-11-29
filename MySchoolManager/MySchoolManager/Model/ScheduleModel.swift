//
//  ScheduleModel.swift
//  MySchoolManager
//
//  Created by 김주환 on 11/27/24.
//

import Foundation

struct ScheduleInfo: Identifiable {
    let id = UUID()
    let subjectName: String
    let date: String
    var period: String
}

class ScheduleData: NSObject, XMLParserDelegate {
    var scheduleInfos: [ScheduleInfo] = []
    var currentElement = ""
    var currentSubjectName = ""
    var currentPeriod = ""  // 현재 교시를 저장할 변수 추가
    var date: String  // 날짜를 저장할 변수
    
    // 고정된 전체 교시 배열 (1~7교시 기준)
    let totalPeriods = ["1", "2", "3", "4", "5", "6", "7"]

    // 초기화 메소드에 date 매개변수 추가
    init(date: String) {
        self.date = date
        self.scheduleInfos = Array(repeating: ScheduleInfo(subjectName: "---", date: date, period: "---"), count: totalPeriods.count)
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if currentElement == "row" {
            currentSubjectName = ""
            currentPeriod = ""  // 교시 초기화
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if currentElement == "ITRT_CNTNT" {
            currentSubjectName += trimmed
            print("Subject: \(currentSubjectName)")  // 값 확인
        } else if currentElement == "PERIO" {
            currentPeriod = trimmed
            print("Period: \(currentPeriod)")  // 값 확인
        }
    }

    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "row" {
            if let periodIndex = Int(currentPeriod), periodIndex > 0 && periodIndex <= totalPeriods.count {
                let subject = currentSubjectName.isEmpty ? "---" : currentSubjectName
                scheduleInfos[periodIndex - 1] = ScheduleInfo(subjectName: subject, date: self.date, period: currentPeriod)
            }
        }
        currentElement = ""
    }

}
