//
//  MealViewModel.swift
//  MySchoolManager
//
//  Created by 김주환 on 11/27/24.
//

import Foundation
import Alamofire

class MealViewModel: ObservableObject {
    @Published var meals: [MealInfo] = []
    
    private let apiKey = "e07b8244818e462db88f133bf6fbfa35"
    private let baseUrl = "https://open.neis.go.kr/hub/mealServiceDietInfo"
    
    func fetchMeal(officeCode: String, schoolCode: String, date: String) {
        // 9일치 급식을 가져오기 위한 요청
        var dateArray: [String] = []
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        
        // 오늘부터 9일치 날짜 생성
        for i in 0..<9 {
            let date = Calendar.current.date(byAdding: .day, value: i, to: Date())!
            let formattedDate = formatter.string(from: date)
            dateArray.append(formattedDate)
        }
        
        // 날짜마다 급식 데이터를 요청
        for date in dateArray {
            let parameters: [String: String] = [
                "ATPT_OFCDC_SC_CODE": officeCode,
                "SD_SCHUL_CODE": schoolCode,
                "KEY": apiKey,
                "MLSV_YMD": date,
                "Type": "xml"
            ]
            
            AF.request(baseUrl, method: .get, parameters: parameters)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        let parser = XMLParser(data: data)
                        let parserDelegate = MealData()
                        parser.delegate = parserDelegate
                        
                        if parser.parse() {
                            DispatchQueue.main.async {
                                // 급식 정보 추가
                                self.meals.append(contentsOf: parserDelegate.mealServiceDietInfos)
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
}


class MealData: NSObject, XMLParserDelegate {
    var mealServiceDietInfos: [MealInfo] = []
    var currentElement = ""
    
    var currentDate = ""
    var currentMealType = ""
    var currentDishName = ""
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if currentElement == "row" {
            currentDishName = ""
            currentMealType = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let trimmedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        switch currentElement {
        case "MLSV_YMD": // 날짜 정보
            currentDate = trimmedString
        case "MMEAL_SC_NM": // 식사 타입 (아침, 점심, 저녁)
            currentMealType = trimmedString
        case "DDISH_NM": // 급식 메뉴
            currentDishName += trimmedString
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "row" {
            let mealInfo = MealInfo(date: currentDate, mealType: currentMealType, dishName: currentDishName)
            mealServiceDietInfos.append(mealInfo)
            print("급식 추가됨: \(mealInfo)") // 디버깅용 출력
        }
        currentElement = ""
    }
}
