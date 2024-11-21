//
//  SchoolSearchModel.swift
//  MySchoolManager
//
//  Created by 김주환 on 11/21/24.
//

import SwiftUI

struct SchoolSearchModel: Identifiable {
    let id = UUID()
    let officeCode: String
    let schoolCode: String
    let schoolName: String
}
