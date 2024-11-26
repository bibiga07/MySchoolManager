//
//  SchoolSearchViewModel.swift
//  MySchoolManager
//
//  Created by 김주환 on 11/21/24.
//

import SwiftUI

class SchoolSearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var filteredSchools: [SchoolSearchModel] = []
    private var allSchools: [SchoolSearchModel] = []

    init() {
        loadAllCSVs()
    }

    func loadAllCSVs() {
        let csvFileNames = ["Daegu", "Busan", "Seoul"]
        
        for fileName in csvFileNames {
            if let path = Bundle.main.path(forResource: fileName, ofType: "csv") {
                print("Path for \(fileName): \(path)")
                do {
                    // 읽을 때 인코딩을 UTF-8로 설정
                    let content = try String(contentsOfFile: path, encoding: .utf8)
                    let rows = content.split(whereSeparator: { $0.isNewline })
                    
                    
                    // 실제 데이터만 필터링
                    var validRows: [String] = []
                    for row in rows {
                        let trimmedRow = row.trimmingCharacters(in: .whitespacesAndNewlines)
                        if !trimmedRow.isEmpty {  // 빈 줄 건너뛰기
                            validRows.append(trimmedRow)
                        }
                    }

                    print("Rows in \(fileName): \(validRows.count)")
                    for row in validRows {
                        let columns = row.split(separator: ",")
                        if columns.count == 3 {
                            let school = SchoolSearchModel(
                                officeCode: String(columns[0]),
                                schoolCode: String(columns[1]),
                                schoolName: String(columns[2])
                            )
                            allSchools.append(school)
                        }
                    }
                } catch {
                    print("Error reading \(fileName): \(error)")
                }
            } else {
                print("File \(fileName).csv not found.")
            }
        }
    }





    func searchSchools() {
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        if trimmedSearchText.isEmpty {
            filteredSchools = []
        } else {
            filteredSchools = allSchools.filter {
                $0.schoolName.lowercased().contains(trimmedSearchText)
            }
        }
    }
}

