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
    
    func fetchSchedule(officeCode: String, schoolCode: String, date: String) {
        let parameters: [String: String] = [
            "ATPT_OFCDC_SC_CODE": officeCode,
            "SD_SCHUL_CODE": schoolCode,
            "KEY": apiKey,
            "ALL_TI_YMD": date,
            "Type": "xml"
        ]
        
        AF.request(baseUrl, method: .get, parameters: parameters)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    let parser = XMLParser(data: data)
                    let parserDelegate = ScheduleData()
                    parser.delegate = parserDelegate
                    
                    if parser.parse() {
                        DispatchQueue.main.async {
                            self.schedule = parserDelegate.scheduleInfos
                        }
                    } else {
                        print("XML 파싱 실패")
                    }
                case .failure(let error):
                    print("API 요청 실패: \(error.localizedDescription)")
                }
            }
    }
}

class ScheduleData: NSObject, XMLParserDelegate {
    var scheduleInfos: [ScheduleInfo] = []
    var currentElement = ""
    var currentSubjectName = ""
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if currentElement == "row" {
            currentSubjectName = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentElement == "ITRT_CNTNT" {
            currentSubjectName += string.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "row" {
            let scheduleInfo = ScheduleInfo(subjectName: currentSubjectName)
            scheduleInfos.append(scheduleInfo)
        }
        currentElement = ""
    }
}
